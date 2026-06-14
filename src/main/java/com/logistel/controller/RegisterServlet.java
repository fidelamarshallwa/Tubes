package com.logistel.controller;


import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.logistel.config.DatabaseConfig;


@WebServlet("/register-process")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Ambil data dari form
        String nama = request.getParameter("nama");
        String nim = request.getParameter("nim");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String noHp = request.getParameter("no_hp");
        String ormawa = request.getParameter("ormawa");

        Connection conn = null;
        try {
            conn = DatabaseConfig.getConnection();
            // Matikan auto-commit untuk menjaga integritas data (transaksi)
            conn.setAutoCommit(false);

            // 2. Insert ke tabel 'pengguna' (Parent)
            String sqlPengguna = "INSERT INTO pengguna (nama, username, password, role) VALUES (?, ?, ?, 'User')";
            PreparedStatement ps1 = conn.prepareStatement(sqlPengguna, PreparedStatement.RETURN_GENERATED_KEYS);
            ps1.setString(1, nama);
            ps1.setString(2, username);
            ps1.setString(3, password); 
            ps1.executeUpdate();

            // 3. Ambil ID yang baru saja dibuat (id_pengguna)
            ResultSet rs = ps1.getGeneratedKeys();
            if (rs.next()) {
                int idBaru = rs.getInt(1);

                // 4. Insert ke tabel 'user' (Child)
                // Pastikan kolom sesuai dengan DDL Anda: id_user, nim, nama_ormawa, no_handphone, email_sso
                String sqlUser = "INSERT INTO user (id_user, nim, nama_ormawa, no_handphone, email_sso) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement ps2 = conn.prepareStatement(sqlUser);
                ps2.setInt(1, idBaru);           // FK dari pengguna
                ps2.setString(2, nim);      // Asumsi NIM = Username
                ps2.setString(3, ormawa);
                ps2.setString(4, noHp);          // Data dari user
                ps2.setString(5, username);      // Email SSO = Username
                ps2.executeUpdate();
            }

            // Jika semua sukses, simpan perubahan
            conn.commit();
            response.sendRedirect("login.jsp");

        } catch (SQLException e) {
            // Jika ada error, batalkan semua perubahan
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            
            request.setAttribute("error", "Registrasi Gagal: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}