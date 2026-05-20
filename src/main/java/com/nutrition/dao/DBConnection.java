package com.nutrition.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    public static Connection getConnection() throws SQLException {
        String url = System.getenv("DATABASE_URL");

        if (url == null || url.isEmpty()) {
            throw new SQLException("DATABASE_URL environment variable not set");
        }

        // Handle both postgres:// and postgresql:// formats
        if (url.startsWith("postgres://")) {
            url = url.replace("postgres://", "jdbc:postgresql://");
        } else if (url.startsWith("postgresql://")) {
            url = url.replace("postgresql://", "jdbc:postgresql://");
        }

        // Add SSL — required by Render PostgreSQL
        if (!url.contains("sslmode")) {
            url += (url.contains("?") ? "&" : "?") + "sslmode=require";
        }

        try {
            Class.forName("org.postgresql.Driver");
            return DriverManager.getConnection(url);
        } catch (ClassNotFoundException e) {
            throw new SQLException("PostgreSQL JDBC Driver not found", e);
        }
    }
}