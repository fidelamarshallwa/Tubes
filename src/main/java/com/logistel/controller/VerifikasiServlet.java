package com.logistel.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.logistel.config.DatabaseConfig;

@WebServlet("/verifikasi-servlet")
public class VerifikasiServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idPeminjaman = request.getParameter("id");
        String action = request.getParameter("action"); // "APPROVED" atau "REJECTED"

        try (Connection conn = DatabaseConfig.getConnection()) {
            // 1. Update Status Peminjaman
            String updateSql = "UPDATE peminjaman SET status = ? WHERE id_peminjaman = ?";
            PreparedStatement ps = conn.prepareStatement(updateSql);
            ps.setString(1, action);
            ps.setString(2, idPeminjaman);
            ps.executeUpdate();

            // 2. Jika disetujui, kurangi stok barang (opsional, tergantung kebutuhan logika bisnis Anda)
            if ("APPROVED".equals(action)) {
                // Logika: Kurangi stok berdasarkan barang yang dipinjam
                // Contoh: Mengurangi stok pada tabel barang
                String updateStok = "UPDATE barang b " +
                                    "JOIN detail_peminjaman_barang dp ON b.id_barang = dp.id_barang " +
                                    "SET b.stok = b.stok - dp.jumlah " +
                                    "WHERE dp.id_peminjaman = ?";
                PreparedStatement psStok = conn.prepareStatement(updateStok);
                psStok.setString(1, idPeminjaman);
                psStok.executeUpdate();
            }

            // Redirect kembali ke dashboard admin
            response.sendRedirect("dashboard-admin.jsp?status=success");
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("dashboard-admin.jsp?error=database_error");
        }
    }
}
