package com.logistel.config;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseConfig {
    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Sesuaikan "logistel_db" dengan nama database di phpMyAdmin Anda
            return DriverManager.getConnection("jdbc:mysql://localhost:3306/logistel_db", "root", "");
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}