package com.logistel.config;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseConfig {
    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Mengambil konfigurasi dari Environment Variables Railway
            String host = System.getenv("MYSQL_HOST");
            String port = System.getenv("MYSQL_PORT");
            String database = System.getenv("MYSQL_DATABASE");
            String user = System.getenv("MYSQL_USER");
            String password = System.getenv("MYSQL_PASSWORD");
            
            String url;
            // Jika berjalan di Railway (Variabel bervariasi/terisi)
            if (host != null) {
                url = "jdbc:mysql://" + host + ":" + port + "/" + database + "?useSSL=false&allowPublicKeyRetrieval=true";
            } else {
                // Fallback otomatis ke localhost jika dijalankan di laptop sendiri
                url = "jdbc:mysql://localhost:3306/logistel_db";
                user = "root";
                password = "";
            }
            
            return DriverManager.getConnection(url, user, password);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}