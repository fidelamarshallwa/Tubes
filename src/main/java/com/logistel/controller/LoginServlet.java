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
import javax.servlet.http.HttpSession;
import com.logistel.config.DatabaseConfig;

@WebServlet("/login-process")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Ambil data dari login.jsp
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role"); // Menangkap pilihan role dari dropdown

        try (Connection conn = DatabaseConfig.getConnection()) {
            // 2. Query disesuaikan dengan role yang dipilih
            String sql = "SELECT p.*, u.nim, u.nama_ormawa, u.no_handphone, u.email_sso " +
                         "FROM pengguna p " +
                         "LEFT JOIN user u ON p.id_pengguna = u.id_user " +
                         "WHERE p.username = ? AND p.password = ? AND p.role = ?";
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, role);
            
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Login Berhasil
                HttpSession session = request.getSession();
                session.setAttribute("id_pengguna", rs.getInt("id_pengguna"));
                session.setAttribute("nama", rs.getString("nama"));
                session.setAttribute("username", rs.getString("username"));
                session.setAttribute("role", rs.getString("role"));

                // Simpan data khusus jika User
                if ("User".equals(role)) {
                    session.setAttribute("nim", rs.getString("nim"));
                    session.setAttribute("ormawa", rs.getString("nama_ormawa"));
                    session.setAttribute("hp", rs.getString("no_handphone"));
                    session.setAttribute("email", rs.getString("email_sso"));
                    response.sendRedirect("dashboard-user.jsp");
                } else {
                    // Redirect untuk Admin
                    response.sendRedirect("dashboard-admin.jsp");
                }
            } else {
                // Login Gagal (Username/Password atau Role tidak cocok)
                request.setAttribute("error", "Username, Password, atau Peran (Role) tidak sesuai!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Koneksi database bermasalah: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}