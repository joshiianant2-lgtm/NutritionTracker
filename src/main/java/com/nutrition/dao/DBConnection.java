package com.nutrition.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {

    public static Connection getConnection() throws SQLException {
        String url = System.getenv("DATABASE_URL");

        if (url == null || url.isEmpty()) {
            throw new SQLException("DATABASE_URL environment variable not set");
        }

        if (url.startsWith("postgres://")) {
            url = url.replace("postgres://", "jdbc:postgresql://");
        } else if (url.startsWith("postgresql://")) {
            url = url.replace("postgresql://", "jdbc:postgresql://");
        }

        // Use Properties to set SSL options
        Properties props = new Properties();
        props.setProperty("sslmode", "require");
        props.setProperty("sslfactory", "org.postgresql.ssl.NonValidatingFactory");

        try {
            Class.forName("org.postgresql.Driver");
            return DriverManager.getConnection(url, props);
        } catch (ClassNotFoundException e) {
            throw new SQLException("PostgreSQL JDBC Driver not found", e);
        }
    }
}