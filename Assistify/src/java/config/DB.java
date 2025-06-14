/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package config;

/**
 *
 * @author Fathan Fardian Sanum
 */
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
/**
 *
 * @author Fathan Fardian Sanum
 */

public class DB {
    private Connection con;
    private Statement stmt;
    private boolean isConnected;
    private String message;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/assistify";

    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    public DB(){
        this.isConnected = false;
        this.message = "Koneksi belum diinisialisasi.";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            this.message = "MySQL JDBC Driver tidak ditemukan. Pastikan sudah ditambahkan ke Libraries. Error: " + e.getMessage();
            System.err.println(this.message);
        }
    }
    
    public void connect() {
        try {
            
            con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            stmt = con.createStatement();
            isConnected = true;
            message = "Koneksi ke database berhasil!";
            System.out.println(message);
        } catch (SQLException e) {
            isConnected = false;
            message = "Koneksi ke database gagal: " + e.getMessage();
            System.err.println(message);
            e.printStackTrace();
        }
    }
    
    public void disconnect() {
        try {
            if (stmt != null) {
                stmt.close();
            }
            if (con != null) {
                con.close();
            }
            isConnected = false;
            message = "Koneksi ke database ditutup.";
            System.out.println(message);
        } catch (SQLException e) {
            message = "Gagal menutup koneksi: " + e.getMessage();
            System.err.println(message);
        }
    }

    public void runQuery(String query) {
        if (!isConnected) {
            connect();
        }
        if (isConnected) {
            try {
                int result = stmt.executeUpdate(query);
                message = "Query berhasil dijalankan. " + result + " baris terpengaruh.";
                System.out.println(message + " Query: " + query);
            } catch (SQLException e) {
                message = "Gagal menjalankan query: " + e.getMessage() + ". Query: " + query;
                System.err.println(message);
            } finally {
                disconnect();
            }
        } else {
            message = "Tidak dapat menjalankan query, koneksi database gagal.";
            System.err.println(message);
        }
    }

    public ResultSet getData(String query) {
        ResultSet rs = null;
        if (!isConnected) {
            connect();
        }
        if (isConnected) {
            try {
                rs = stmt.executeQuery(query);
                message = "Data berhasil diambil.";
                System.out.println(message + " Query: " + query);
            } catch (SQLException e) {
                message = "Gagal mengambil data: " + e.getMessage() + ". Query: " + query;
                System.err.println(message);
            }
        } else {
            message = "Tidak dapat mengambil data, koneksi database gagal.";
            System.err.println(message);
        }
        return rs;
    }

        public ResultSet getDataS(String query) {
        ResultSet rs = null;
        if (!isConnected) {
            connect();
        }
        if (isConnected) {
            try {
                stmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                rs = stmt.executeQuery(query);
                message = "Data berhasil diambil.";
                System.out.println(message + " Query: " + query);
            } catch (SQLException e) {
                message = "Gagal mengambil data: " + e.getMessage() + ". Query: " + query;
                System.err.println(message);
            }
        } else {
            message = "Tidak dapat mengambil data, koneksi database gagal.";
            System.err.println(message);
        }
        return rs;
    }
        
    public String getMessage() {
        return message;
    }

    public boolean isConnected() {
        return isConnected;
    }
}
