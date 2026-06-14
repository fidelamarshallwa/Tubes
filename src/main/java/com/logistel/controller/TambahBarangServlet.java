package com.logistel.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.logistel.config.DatabaseConfig;

@WebServlet("/tambah-barang")
public class TambahBarangServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Mengambil data dari form modal
        String namaBarang = request.getParameter("nama_barang");
        String stokStr = request.getParameter("stok");

        try (Connection conn = DatabaseConfig.getConnection()) {
            int stok = Integer.parseInt(stokStr);

            // Query Insert ke database
            String sql = "INSERT INTO barang (nama_barang, stok) VALUES (?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            
            // Kita buat toUpperCase() agar penamaan barang di database seragam
            ps.setString(1, namaBarang.toUpperCase()); 
            ps.setInt(2, stok);
            
            ps.executeUpdate();

            // Jika sukses, kembalikan ke dashboard admin
            response.sendRedirect("dashboard-admin.jsp?status=tambah_sukses");
            
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("dashboard-admin.jsp?error=gagal_tambah");
        }
    }
}