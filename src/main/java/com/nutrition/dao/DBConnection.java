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

        // Railway provides DATABASE_URL in postgres:// format
        // Convert to jdbc:postgresql:// format if needed
        if (url.startsWith("postgres://")) {
            url = url.replace("postgres://", "jdbc:postgresql://");
        }

        try {
            Class.forName("org.postgresql.Driver");
            return DriverManager.getConnection(url);
        } catch (ClassNotFoundException e) {
            throw new SQLException("PostgreSQL JDBC Driver not found", e);
        }
    }
}