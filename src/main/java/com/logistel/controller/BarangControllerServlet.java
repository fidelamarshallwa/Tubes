package com.logistel.controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.logistel.config.DatabaseConfig;

@WebServlet("/barang-action")
public class BarangControllerServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action");
        String id = request.getParameter("id");

        try (Connection conn = DatabaseConfig.getConnection()) {
            if ("hapus".equals(action)) {
                PreparedStatement ps = conn.prepareStatement("DELETE FROM barang WHERE id_barang = ?");
                ps.setString(1, id);
                ps.executeUpdate();
            } else if ("edit".equals(action)) {
                PreparedStatement ps = conn.prepareStatement("UPDATE barang SET nama_barang=?, stok=? WHERE id_barang=?");
                ps.setString(1, request.getParameter("nama_barang").toUpperCase());
                ps.setString(2, request.getParameter("stok"));
                ps.setString(3, id);
                ps.executeUpdate();
            }
            response.sendRedirect("dashboard-admin.jsp");
        } catch (Exception e) { e.printStackTrace(); }
    }
}