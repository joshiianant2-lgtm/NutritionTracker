package com.nutrition.dao;

import java.net.URI;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {

    public static Connection getConnection() throws SQLException {
        String dbUrl = System.getenv("DATABASE_URL");

        if (dbUrl == null || dbUrl.isEmpty()) {
            throw new SQLException("DATABASE_URL environment variable not set");
        }

        try {
            Class.forName("org.postgresql.Driver");

            URI uri = new URI(dbUrl);
            String host = uri.getHost();
            int port = uri.getPort() == -1 ? 5432 : uri.getPort();
            String path = uri.getPath();
            String[] userInfo = uri.getUserInfo().split(":");
            String user = userInfo[0];
            String password = userInfo[1];

            String jdbcUrl = "jdbc:postgresql://" + host + ":" + port + path;

            Properties props = new Properties();
            props.setProperty("user", user);
            props.setProperty("password", password);

            // Use SSL only for Render (not Railway internal network)
            if (!host.contains("railway.internal")) {
                props.setProperty("sslmode", "require");
                props.setProperty("sslfactory", "org.postgresql.ssl.NonValidatingFactory");
            } else {
                props.setProperty("sslmode", "disable");
            }

            return DriverManager.getConnection(jdbcUrl, props);

        } catch (Exception e) {
            throw new SQLException("Failed to connect: " + e.getMessage(), e);
        }
    }
}