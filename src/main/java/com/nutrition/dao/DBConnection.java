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

            // Parse the URI to extract components
            URI uri = new URI(dbUrl);
            String host = uri.getHost();
            int port = uri.getPort() == -1 ? 5432 : uri.getPort();
            String path = uri.getPath(); // e.g. /nutritiontracker_db
            String[] userInfo = uri.getUserInfo().split(":");
            String user = userInfo[0];
            String password = userInfo[1];

            String jdbcUrl = "jdbc:postgresql://" + host + ":" + port + path
                           + "?sslmode=require";

            Properties props = new Properties();
            props.setProperty("user", user);
            props.setProperty("password", password);
            props.setProperty("sslmode", "require");
            props.setProperty("sslfactory", "org.postgresql.ssl.NonValidatingFactory");

            return DriverManager.getConnection(jdbcUrl, props);

        } catch (Exception e) {
            throw new SQLException("Failed to connect: " + e.getMessage(), e);
        }
    }
}