package com.nutrition.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	 private static final String URL = "jdbc:oracle:thin:@joshi:1521/XE";
	    private static final String USERNAME = "fitness";
	    private static final String PASSWORD = "gym";
	    
	    public static Connection getConnection() throws SQLException {
	        try {
	            Class.forName("oracle.jdbc.driver.OracleDriver");
	            return DriverManager.getConnection(URL, USERNAME, PASSWORD);
	        } catch (ClassNotFoundException e) {
	            throw new SQLException("Oracle JDBC Driver not found", e);
	        }
	    }
}
