package com.logistel.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.logistel.config.DatabaseConfig;

@WebServlet("/pengajuan-peminjaman")
public class PengajuanPeminjamanServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Ambil session yang aktif
        HttpSession session = request.getSession(false);
        
        // Proteksi: Jaga-jaga jika session kosong / expired, tendang kembali ke login
        if (session == null || session.getAttribute("id_pengguna") == null) {
            response.sendRedirect("login.jsp?status=timeout");
            return;
        }

        // 1. OTOMATIS: Mengambil id_pengguna dari session untuk mengisi id_user di database peminjaman
        int idUserFix = (Integer) session.getAttribute("id_pengguna");

        // Ambil data dari form jsp
        String nim = request.getParameter("nim");
        String tipe = request.getParameter("tipe_inventaris"); // "Barang" atau "Ruangan"
        String idItemRaw = request.getParameter("id_item");    // Menerima mentah string: "BARANG_3" atau "RUANGAN_3"
        String jumlahStr = request.getParameter("jumlah");
        String kegiatan = request.getParameter("nama_kegiatan");
        String tglMulai = request.getParameter("tanggal_mulai");     // Format: YYYY-MM-DD
        String tglSelesai = request.getParameter("tanggal_selesai"); // Format: YYYY-MM-DD
        String deskripsi = request.getParameter("deskripsi");

        // Validasi input wajib awal
        if (idItemRaw == null || idItemRaw.trim().isEmpty() || tglMulai == null || tglSelesai == null) {
            response.setContentType("text/html");
            response.getWriter().println("<h3>Gagal Validasi: Parameter id_item, tanggal_mulai, atau tanggal_selesai kosong!</h3>");
            return;
        }

        Connection conn = null;
        PreparedStatement psCheck = null;
        PreparedStatement psPeminjaman = null;
        PreparedStatement psDetail = null;
        ResultSet rsCheck = null;
        ResultSet rsKeys = null;

        try {
            conn = DatabaseConfig.getConnection();
            conn.setAutoCommit(false); // Mode transaksi database aktif

            // =================================================================
            // 1. MEMBONGKAR PREFIKS ID ("BARANG_3" -> 3)
            // =================================================================
            int idItemAsli = 0;
            if (idItemRaw.contains("_")) {
                String[] parts = idItemRaw.split("_");
                idItemAsli = Integer.parseInt(parts[1].trim()); 
            } else {
                idItemAsli = Integer.parseInt(idItemRaw.trim());
            }

            // =================================================================
            // 2. FITUR ANTI-BENTROK (VALIDASI KETERSEDIAAN JADWAL)
            // =================================================================
            boolean isBentrok = false;
            
            if ("Barang".equalsIgnoreCase(tipe)) {
                String sqlCheckBarang = "SELECT COUNT(*) FROM detail_peminjaman_barang db " +
                                        "JOIN peminjaman p ON db.id_peminjaman = p.id_peminjaman " +
                                        "WHERE db.id_barang = ? " +
                                        "AND p.status IN ('APPROVED', 'RETURN_REQUESTED') " +
                                        "AND (? <= p.tanggal_selesai AND ? >= p.tanggal_mulai)";
                psCheck = conn.prepareStatement(sqlCheckBarang);
                psCheck.setInt(1, idItemAsli);
                psCheck.setString(2, tglMulai);
                psCheck.setString(3, tglSelesai);
                
            } else if ("Ruangan".equalsIgnoreCase(tipe)) {
                String sqlCheckRuangan = "SELECT COUNT(*) FROM detail_peminjaman_ruangan dr " +
                                         "JOIN peminjaman p ON dr.id_peminjaman = p.id_peminjaman " +
                                         "WHERE dr.id_ruangan = ? " +
                                         "AND p.status IN ('APPROVED', 'RETURN_REQUESTED') " +
                                         "AND (? <= p.tanggal_selesai AND ? >= p.tanggal_mulai)";
                psCheck = conn.prepareStatement(sqlCheckRuangan);
                psCheck.setInt(1, idItemAsli);
                psCheck.setString(2, tglMulai);
                psCheck.setString(3, tglSelesai);
            }

            if (psCheck != null) {
                rsCheck = psCheck.executeQuery();
                if (rsCheck.next() && rsCheck.getInt(1) > 0) {
                    isBentrok = true;
                }
            }

            // Jika terdeteksi bentrok jadwal, gagalkan pengajuan
            if (isBentrok) {
                conn.rollback();
                response.sendRedirect("dashboard-user.jsp?status=bentrok");
                return;
            }

            // =================================================================
            // 3. INSERT KE TABEL INDUK (peminjaman) -> DISESUAIKAN DENGAN SQL DUMP
            // =================================================================
            // Kolom nama_kegiatan dan deskripsi dihapus dari query ini karena tidak ada di tabel peminjaman
            String sqlPeminjaman = "INSERT INTO peminjaman (id_user, tanggal_mulai, tanggal_selesai, status, barcode) VALUES (?, ?, ?, 'PENDING', ?)";
            psPeminjaman = conn.prepareStatement(sqlPeminjaman, Statement.RETURN_GENERATED_KEYS);
            
            psPeminjaman.setInt(1, idUserFix); 
            psPeminjaman.setString(2, tglMulai);
            psPeminjaman.setString(3, tglSelesai);
            
            String barcodeData = java.util.UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            psPeminjaman.setString(4, barcodeData);
            
            psPeminjaman.executeUpdate();

            // Ambil ID Peminjaman yang baru saja digenerate
            int idPeminjamanGenerated = 0;
            rsKeys = psPeminjaman.getGeneratedKeys();
            if (rsKeys.next()) {
                idPeminjamanGenerated = rsKeys.getInt(1);
            }

            // =================================================================
            // 4. INSERT KE TABEL DETAIL (Di sini nama_kegiatan & deskripsi dimasukkan)
            // =================================================================
            if (idPeminjamanGenerated != 0) {
                if ("Barang".equalsIgnoreCase(tipe)) {
                    String sqlDetailBarang = "INSERT INTO detail_peminjaman_barang (id_peminjaman, id_barang, jumlah, nama_kegiatan, deskripsi) VALUES (?, ?, ?, ?, ?)";
                    psDetail = conn.prepareStatement(sqlDetailBarang);
                    psDetail.setInt(1, idPeminjamanGenerated);
                    psDetail.setInt(2, idItemAsli); 
                    
                    int jumlahFix = 1;
                    if (jumlahStr != null && !jumlahStr.trim().isEmpty()) {
                        jumlahFix = Integer.parseInt(jumlahStr.trim());
                    }
                    psDetail.setInt(3, jumlahFix);
                    psDetail.setString(4, kegiatan);
                    psDetail.setString(5, deskripsi);
                    psDetail.executeUpdate();

                } else if ("Ruangan".equalsIgnoreCase(tipe)) {
                    String sqlDetailRuangan = "INSERT INTO detail_peminjaman_ruangan (id_peminjaman, id_ruangan, nama_kegiatan, deskripsi) VALUES (?, ?, ?, ?)";
                    psDetail = conn.prepareStatement(sqlDetailRuangan);
                    psDetail.setInt(1, idPeminjamanGenerated);
                    psDetail.setInt(2, idItemAsli); 
                    psDetail.setString(3, kegiatan);
                    psDetail.setString(4, deskripsi);
                    psDetail.executeUpdate();
                }
            }

            conn.commit(); // Sukses total, simpan permanen ke MySQL Railway
            response.sendRedirect("dashboard-user.jsp?status=berhasil");

        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<h2>Terjadi Kesalahan System (Database Error):</h2>");
            out.println("<pre style='color:red; background:#f4f4f4; padding:15px; border:1px solid #ccc;'>");
            e.printStackTrace(out);
            out.println("</pre>");
            out.println("<br><a href='dashboard-user.jsp'>Kembali ke Dashboard</a>");
            
        } finally {
            try { if (rsCheck != null) rsCheck.close(); } catch (Exception e) {}
            try { if (rsKeys != null) rsKeys.close(); } catch (Exception e) {}
            try { if (psCheck != null) psCheck.close(); } catch (Exception e) {}
            try { if (psPeminjaman != null) psPeminjaman.close(); } catch (Exception e) {}
            try { if (psDetail != null) psDetail.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}