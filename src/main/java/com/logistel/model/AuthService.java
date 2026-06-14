package com.logistel.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.logistel.config.DatabaseConfig;

/**
 * Kelas AuthService menangani logika bisnis autentikasi (login) dan
 * registrasi akun pengguna baru ke database MySQL.
 */
public class AuthService {

    /**
     * Mendaftarkan pengguna baru (User) ke database dengan mekanisme transaksi SQL.
     * Mengisi tabel 'pengguna' terlebih dahulu, lalu menggunakan ID yang digenerasi
     * untuk mengisi tabel 'user'.
     *
     * @param user     Objek User yang berisi data profil (nama, nim, ormawa, no hp, email sso)
     * @param username Username akun baru
     * @param password Password akun baru
     * @return true jika berhasil terdaftar, false jika gagal
     */
    public boolean registerUser(User user, String username, String password) {
        Connection conn = null;
        PreparedStatement stmtPengguna = null;
        PreparedStatement stmtUser = null;
        ResultSet generatedKeys = null;

        try {
            conn = DatabaseConfig.getConnection();
            
            // Menonaktifkan auto-commit untuk memulai transaksi SQL secara manual
            conn.setAutoCommit(false);

            // Langkah A: INSERT data ke tabel "pengguna"
            String sqlPengguna = "INSERT INTO pengguna (nama, username, password, role) VALUES (?, ?, ?, 'User')";
            stmtPengguna = conn.prepareStatement(sqlPengguna, Statement.RETURN_GENERATED_KEYS);
            stmtPengguna.setString(1, user.getNama());
            stmtPengguna.setString(2, username);
            stmtPengguna.setString(3, password); // Dalam aplikasi produksi nyata, gunakan password hashing (misal: BCrypt)

            int affectedRows = stmtPengguna.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Gagal membuat baris pengguna baru.");
            }

            // Dapatkan ID auto-increment yang digenerasikan oleh MySQL
            generatedKeys = stmtPengguna.getGeneratedKeys();
            int generatedId = 0;
            if (generatedKeys.next()) {
                generatedId = generatedKeys.getInt(1);
            } else {
                throw new SQLException("Gagal mendapatkan ID pengguna baru.");
            }

            // Langkah B: INSERT data ke tabel "user" menggunakan ID di atas sebagai "id_user"
            String sqlUser = "INSERT INTO user (id_user, nim, nama_ormawa, no_handphone, email_sso) VALUES (?, ?, ?, ?, ?)";
            stmtUser = conn.prepareStatement(sqlUser);
            stmtUser.setInt(1, generatedId);
            stmtUser.setString(2, user.getNim());
            stmtUser.setString(3, user.getNamaOrmawa());
            stmtUser.setString(4, user.getNoHandphone());
            stmtUser.setString(5, user.getEmailSSO());

            stmtUser.executeUpdate();

            // Commit seluruh transaksi jika kedua langkah di atas berhasil
            conn.commit();
            System.out.println("[AUTH INFO] Registrasi user berhasil untuk username: " + username);

            // Perbarui atribut objek User lokal dengan data yang tersimpan di database
            user.setIdPengguna(String.valueOf(generatedId));
            user.setUsername(username);
            user.setPassword(password);

            return true;

        } catch (SQLException e) {
            // Melakukan rollback transaksi jika terjadi kesalahan SQL di salah satu langkah
            if (conn != null) {
                try {
                    System.err.println("[AUTH WARNING] Terjadi kesalahan SQL saat registrasi. Melakukan rollback...");
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("[AUTH ERROR] Gagal melakukan rollback transaksi: " + ex.getMessage());
                }
            }
            System.err.println("[AUTH ERROR] Proses registrasi gagal: " + e.getMessage());
            return false;
        } finally {
            // Memastikan resource database ditutup kembali ke kolam (pool)
            try {
                if (generatedKeys != null) generatedKeys.close();
                if (stmtPengguna != null) stmtPengguna.close();
                if (stmtUser != null) stmtUser.close();
                if (conn != null) {
                    conn.setAutoCommit(true); // Kembalikan mode auto-commit ke default (true)
                }
            } catch (SQLException ex) {
                System.err.println("[AUTH ERROR] Gagal membersihkan resource koneksi: " + ex.getMessage());
            }
        }
    }

    /**
     * Melakukan proses autentikasi login pengguna berdasarkan username dan password.
     * Menggunakan LEFT JOIN untuk menarik data profil admin/user dalam satu query.
     *
     * @param username Username yang dimasukkan
     * @param password Password yang dimasukkan
     * @return Objek Admin atau User (sebagai subtype dari Pengguna), atau null jika gagal login
     */
    public Pengguna login(String username, String password) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        // Query mengambil data utama pengguna sekaligus join dengan tabel admin & user
        String sql = "SELECT p.id_pengguna, p.nama, p.username, p.password, p.role, " +
                     "       a.no_pegawai, " +
                     "       u.nim, u.nama_ormawa, u.no_handphone, u.email_sso " +
                     "FROM pengguna p " +
                     "LEFT JOIN admin a ON p.id_pengguna = a.id_admin " +
                     "LEFT JOIN user u ON p.id_pengguna = u.id_user " +
                     "WHERE p.username = ? AND p.password = ?";

        try {
            conn = DatabaseConfig.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);

            rs = stmt.executeQuery();

            if (rs.next()) {
                String idPengguna = String.valueOf(rs.getInt("id_pengguna"));
                String nama = rs.getString("nama");
                String dbUsername = rs.getString("username");
                String dbPassword = rs.getString("password");
                String role = rs.getString("role");

                if ("Admin".equalsIgnoreCase(role)) {
                    String noPegawai = rs.getString("no_pegawai");
                    System.out.println("[AUTH INFO] Login sukses sebagai Admin: " + nama);
                    return new Admin(idPengguna, nama, dbUsername, dbPassword, noPegawai);
                } else if ("User".equalsIgnoreCase(role)) {
                    String nim = rs.getString("nim");
                    String namaOrmawa = rs.getString("nama_ormawa");
                    String noHandphone = rs.getString("no_handphone");
                    String emailSSO = rs.getString("email_sso");
                    System.out.println("[AUTH INFO] Login sukses sebagai User: " + nama);
                    return new User(idPengguna, nama, dbUsername, dbPassword, nim, namaOrmawa, noHandphone, emailSSO);
                }
            } else {
                System.out.println("[AUTH WARNING] Login gagal: Username atau password salah.");
            }
        } catch (SQLException e) {
            System.err.println("[AUTH ERROR] Kesalahan sistem saat login: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
            } catch (SQLException ex) {
                System.err.println("[AUTH ERROR] Gagal menutup resource select: " + ex.getMessage());
            }
        }
        return null;
    }
}
