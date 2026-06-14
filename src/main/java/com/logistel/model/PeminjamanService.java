package com.logistel.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.logistel.config.DatabaseConfig;

/**
 * Kelas PeminjamanService menangani logika bisnis (DAO/DAO Service) transaksi peminjaman
 * barang dan ruangan, termasuk pengajuan dan verifikasi persetujuan (approval/return) admin.
 */
public class PeminjamanService {

    /**
     * Mengajukan peminjaman barang baru dengan menyimpan data ke tabel 'peminjaman'
     * dan 'detail_peminjaman_barang' dalam satu transaksi SQL.
     *
     * @param peminjaman Objek Peminjaman utama (header)
     * @param detail     Objek DetailPeminjamanBarang (detail)
     * @return true jika berhasil disimpan, false jika gagal
     */
    public boolean ajukanPeminjamanBarang(Peminjaman peminjaman, DetailPeminjamanBarang detail) {
        Connection conn = null;
        PreparedStatement stmtPeminjaman = null;
        PreparedStatement stmtDetail = null;
        ResultSet generatedKeys = null;

        try {
            conn = DatabaseConfig.getConnection();
            conn.setAutoCommit(false); // Mulai transaksi

            // 1. Simpan header peminjaman
            String sqlPeminjaman = "INSERT INTO peminjaman (id_user, tanggal_mulai, tanggal_selesai, status, barcode) " +
                                   "VALUES (?, ?, ?, ?, ?)";
            stmtPeminjaman = conn.prepareStatement(sqlPeminjaman, Statement.RETURN_GENERATED_KEYS);
            // Ambil ID User dari relasi userPeminjam
            stmtPeminjaman.setInt(1, Integer.parseInt(peminjaman.getUserPeminjam().getIdPengguna()));
            stmtPeminjaman.setString(2, peminjaman.getTanggalMulai());
            stmtPeminjaman.setString(3, peminjaman.getTanggalSelesai());
            stmtPeminjaman.setString(4, peminjaman.getStatus()); // Biasanya "PENDING" saat pertama kali diajukan
            stmtPeminjaman.setString(5, peminjaman.getBarcode());

            int affectedRows = stmtPeminjaman.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Pengajuan peminjaman gagal, header tidak tersimpan.");
            }

            // Ambil ID peminjaman yang baru digenerasikan oleh database
            generatedKeys = stmtPeminjaman.getGeneratedKeys();
            int generatedIdPeminjaman = 0;
            if (generatedKeys.next()) {
                generatedIdPeminjaman = generatedKeys.getInt(1);
            } else {
                throw new SQLException("Pengajuan peminjaman gagal, tidak mendapatkan ID Peminjaman.");
            }

            // Update ID peminjaman di objek Java lokal
            peminjaman.setIdPeminjaman(generatedIdPeminjaman);
            detail.setPeminjaman(peminjaman);

            // 2. Simpan detail peminjaman barang
            String sqlDetail = "INSERT INTO detail_peminjaman_barang (id_peminjaman, id_barang, jumlah, nama_kegiatan, deskripsi) " +
                               "VALUES (?, ?, ?, ?, ?)";
            stmtDetail = conn.prepareStatement(sqlDetail);
            stmtDetail.setInt(1, generatedIdPeminjaman);
            stmtDetail.setInt(2, detail.getBarang().getIdBarang());
            stmtDetail.setInt(3, detail.getJumlah());
            stmtDetail.setString(4, detail.getNamaKegiatan());
            stmtDetail.setString(5, detail.getDeskripsi());

            stmtDetail.executeUpdate();

            // Commit transaksi jika seluruh langkah sukses
            conn.commit();
            System.out.println("[TRANSAKSI INFO] Berhasil mengajukan peminjaman barang. ID Peminjaman: " + generatedIdPeminjaman);
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    System.err.println("[TRANSAKSI WARNING] Pengajuan peminjaman barang gagal. Rollback transaksi...");
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("[TRANSAKSI ERROR] Gagal melakukan rollback: " + ex.getMessage());
                }
            }
            System.err.println("[TRANSAKSI ERROR] Gagal mengajukan peminjaman barang: " + e.getMessage());
            return false;
        } finally {
            try {
                if (generatedKeys != null) generatedKeys.close();
                if (stmtPeminjaman != null) stmtPeminjaman.close();
                if (stmtDetail != null) stmtDetail.close();
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException ex) {
                System.err.println("[TRANSAKSI ERROR] Gagal membersihkan resource: " + ex.getMessage());
            }
        }
    }

    /**
     * Mengajukan peminjaman ruangan baru dengan menyimpan data ke tabel 'peminjaman'
     * dan 'detail_peminjaman_ruangan' dalam satu transaksi SQL.
     *
     * @param peminjaman Objek Peminjaman utama (header)
     * @param detail     Objek DetailPeminjamanRuangan (detail)
     * @return true jika berhasil disimpan, false jika gagal
     */
    public boolean ajukanPeminjamanRuangan(Peminjaman peminjaman, DetailPeminjamanRuangan detail) {
        Connection conn = null;
        PreparedStatement stmtPeminjaman = null;
        PreparedStatement stmtDetail = null;
        ResultSet generatedKeys = null;

        try {
            conn = DatabaseConfig.getConnection();
            conn.setAutoCommit(false); // Mulai transaksi

            // 1. Simpan header peminjaman
            String sqlPeminjaman = "INSERT INTO peminjaman (id_user, tanggal_mulai, tanggal_selesai, status, barcode) " +
                                   "VALUES (?, ?, ?, ?, ?)";
            stmtPeminjaman = conn.prepareStatement(sqlPeminjaman, Statement.RETURN_GENERATED_KEYS);
            stmtPeminjaman.setInt(1, Integer.parseInt(peminjaman.getUserPeminjam().getIdPengguna()));
            stmtPeminjaman.setString(2, peminjaman.getTanggalMulai());
            stmtPeminjaman.setString(3, peminjaman.getTanggalSelesai());
            stmtPeminjaman.setString(4, peminjaman.getStatus());
            stmtPeminjaman.setString(5, peminjaman.getBarcode());

            int affectedRows = stmtPeminjaman.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Pengajuan peminjaman gagal, header tidak tersimpan.");
            }

            generatedKeys = stmtPeminjaman.getGeneratedKeys();
            int generatedIdPeminjaman = 0;
            if (generatedKeys.next()) {
                generatedIdPeminjaman = generatedKeys.getInt(1);
            } else {
                throw new SQLException("Pengajuan peminjaman gagal, tidak mendapatkan ID Peminjaman.");
            }

            peminjaman.setIdPeminjaman(generatedIdPeminjaman);
            detail.setPeminjaman(peminjaman);

            // 2. Simpan detail peminjaman ruangan
            String sqlDetail = "INSERT INTO detail_peminjaman_ruangan (id_peminjaman, id_ruangan, nama_kegiatan, deskripsi) " +
                               "VALUES (?, ?, ?, ?)";
            stmtDetail = conn.prepareStatement(sqlDetail);
            stmtDetail.setInt(1, generatedIdPeminjaman);
            stmtDetail.setInt(2, detail.getRuangan().getIdRuangan());
            stmtDetail.setString(3, detail.getNamaKegiatan());
            stmtDetail.setString(4, detail.getDeskripsi());

            stmtDetail.executeUpdate();

            conn.commit();
            System.out.println("[TRANSAKSI INFO] Berhasil mengajukan peminjaman ruangan. ID Peminjaman: " + generatedIdPeminjaman);
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    System.err.println("[TRANSAKSI WARNING] Pengajuan peminjaman ruangan gagal. Rollback transaksi...");
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("[TRANSAKSI ERROR] Gagal melakukan rollback: " + ex.getMessage());
                }
            }
            System.err.println("[TRANSAKSI ERROR] Gagal mengajukan peminjaman ruangan: " + e.getMessage());
            return false;
        } finally {
            try {
                if (generatedKeys != null) generatedKeys.close();
                if (stmtPeminjaman != null) stmtPeminjaman.close();
                if (stmtDetail != null) stmtDetail.close();
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException ex) {
                System.err.println("[TRANSAKSI ERROR] Gagal membersihkan resource: " + ex.getMessage());
            }
        }
    }

    /**
     * Memverifikasi peminjaman oleh Admin (ACC, Tolak, atau Kembali) dan menyesuaikan stok
     * inventaris barang/ruangan secara otomatis di database.
     *
     * @param idPeminjaman ID peminjaman yang diverifikasi
     * @param statusBaru   Status baru ("APPROVED", "REJECTED", "RETURNED")
     * @return true jika berhasil diperbarui beserta stoknya, false jika gagal
     */
    public boolean verifikasiPeminjaman(int idPeminjaman, String statusBaru) {
        Connection conn = null;
        PreparedStatement stmtUpdateStatus = null;
        PreparedStatement stmtGetDetailBarang = null;
        PreparedStatement stmtGetDetailRuangan = null;
        PreparedStatement stmtUpdateStokBarang = null;
        PreparedStatement stmtUpdateStokRuangan = null;
        ResultSet rsBarang = null;
        ResultSet rsRuangan = null;

        try {
            conn = DatabaseConfig.getConnection();
            conn.setAutoCommit(false); // Mulai transaksi untuk integritas status & stok

            // 1. Update status peminjaman
            String sqlUpdateStatus = "UPDATE peminjaman SET status = ? WHERE id_peminjaman = ?";
            stmtUpdateStatus = conn.prepareStatement(sqlUpdateStatus);
            stmtUpdateStatus.setString(1, statusBaru);
            stmtUpdateStatus.setInt(2, idPeminjaman);
            int affected = stmtUpdateStatus.executeUpdate();

            if (affected == 0) {
                throw new SQLException("Peminjaman dengan ID " + idPeminjaman + " tidak ditemukan.");
            }

            // 2. Jika status adalah APPROVED atau RETURNED, sesuaikan stok inventaris
            if ("APPROVED".equalsIgnoreCase(statusBaru) || "RETURNED".equalsIgnoreCase(statusBaru)) {
                
                // Cek apakah transaksi ini meminjam barang
                String sqlGetDetailBarang = "SELECT id_barang, jumlah FROM detail_peminjaman_barang WHERE id_peminjaman = ?";
                stmtGetDetailBarang = conn.prepareStatement(sqlGetDetailBarang);
                stmtGetDetailBarang.setInt(1, idPeminjaman);
                rsBarang = stmtGetDetailBarang.executeQuery();

                if (rsBarang.next()) {
                    int idBarang = rsBarang.getInt("id_barang");
                    int jumlah = rsBarang.getInt("jumlah");
                    
                    String sqlUpdateStokBarang;
                    if ("APPROVED".equalsIgnoreCase(statusBaru)) {
                        // Kurangi stok barang
                        sqlUpdateStokBarang = "UPDATE barang SET stok = stok - ? WHERE id_barang = ?";
                    } else {
                        // Kembalikan/tambah stok barang
                        sqlUpdateStokBarang = "UPDATE barang SET stok = stok + ? WHERE id_barang = ?";
                    }
                    stmtUpdateStokBarang = conn.prepareStatement(sqlUpdateStokBarang);
                    stmtUpdateStokBarang.setInt(1, jumlah);
                    stmtUpdateStokBarang.setInt(2, idBarang);
                    stmtUpdateStokBarang.executeUpdate();
                    System.out.println("[TRANSAKSI INFO] Stok barang ID " + idBarang + " berhasil disesuaikan (" + statusBaru + ").");
                }

                // Cek apakah transaksi ini meminjam ruangan
                String sqlGetDetailRuangan = "SELECT id_ruangan FROM detail_peminjaman_ruangan WHERE id_peminjaman = ?";
                stmtGetDetailRuangan = conn.prepareStatement(sqlGetDetailRuangan);
                stmtGetDetailRuangan.setInt(1, idPeminjaman);
                rsRuangan = stmtGetDetailRuangan.executeQuery();

                if (rsRuangan.next()) {
                    int idRuangan = rsRuangan.getInt("id_ruangan");
                    
                    String sqlUpdateStokRuangan;
                    if ("APPROVED".equalsIgnoreCase(statusBaru)) {
                        // Ruangan menjadi tidak tersedia (stok = 0)
                        sqlUpdateStokRuangan = "UPDATE ruangan SET stok = 0 WHERE id_ruangan = ?";
                    } else {
                        // Ruangan kembali tersedia (stok = 1)
                        sqlUpdateStokRuangan = "UPDATE ruangan SET stok = 1 WHERE id_ruangan = ?";
                    }
                    stmtUpdateStokRuangan = conn.prepareStatement(sqlUpdateStokRuangan);
                    stmtUpdateStokRuangan.setInt(1, idRuangan);
                    stmtUpdateStokRuangan.executeUpdate();
                    System.out.println("[TRANSAKSI INFO] Ketersediaan ruangan ID " + idRuangan + " berhasil disesuaikan (" + statusBaru + ").");
                }
            }

            conn.commit(); // Commit transaksi jika semuanya sukses
            System.out.println("[TRANSAKSI INFO] Verifikasi peminjaman ID " + idPeminjaman + " berhasil diubah menjadi: " + statusBaru);
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    System.err.println("[TRANSAKSI WARNING] Gagal melakukan verifikasi. Rollback transaksi...");
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("[TRANSAKSI ERROR] Gagal melakukan rollback: " + ex.getMessage());
                }
            }
            System.err.println("[TRANSAKSI ERROR] Kesalahan verifikasi peminjaman: " + e.getMessage());
            return false;
        } finally {
            try {
                if (rsBarang != null) rsBarang.close();
                if (rsRuangan != null) rsRuangan.close();
                if (stmtUpdateStatus != null) stmtUpdateStatus.close();
                if (stmtGetDetailBarang != null) stmtGetDetailBarang.close();
                if (stmtGetDetailRuangan != null) stmtGetDetailRuangan.close();
                if (stmtUpdateStokBarang != null) stmtUpdateStokBarang.close();
                if (stmtUpdateStokRuangan != null) stmtUpdateStokRuangan.close();
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException ex) {
                System.err.println("[TRANSAKSI ERROR] Gagal membersihkan resource verifikasi: " + ex.getMessage());
            }
        }
    }
}
