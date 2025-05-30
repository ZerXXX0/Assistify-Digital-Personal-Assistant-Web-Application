package model;

import config.DB;
import java.sql.ResultSet;
import java.sql.SQLException;

public class User {
    private int id;
    private String username;
    private String password;
    private String email;

    // Constructors
    public User() {}
    
    public User(int id, String username, String password, String email) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.email = email;
    }
    
    public User(String username, String password, String email) {
        this.username = username;
        this.password = password;
        this.email = email;
    }

    // Database operations
    public boolean saveToDatabase(DB db) {
        try {
            String query = "INSERT INTO user (username, password, email) VALUES ('" + 
                          username + "', '" + password + "', '" + email + "')";
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error saving user: " + e.getMessage());
            return false;
        }
    }
    
    public static User authenticate(String username, String password, DB db) {
        try {
            String query = "SELECT * FROM user WHERE username = '" + username + "' AND password = '" + password + "'";
            ResultSet rs = db.getData(query);
            
            if (rs != null && rs.next()) {
                return new User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("email")
                );
            }
        } catch (SQLException e) {
            System.err.println("Authentication error: " + e.getMessage());
        }
        return null;
    }
    
    public static boolean usernameExists(String username, DB db) {
        try {
            String query = "SELECT username FROM user WHERE username = '" + username + "'";
            ResultSet rs = db.getData(query);
            return rs != null && rs.next();
        } catch (SQLException e) {
            System.err.println("Error checking username: " + e.getMessage());
            return false;
        }
    }
    
    public boolean updateProfile(DB db) {
        try {
            String query = "UPDATE user SET username = '" + username + "', email = '" + email + "' WHERE id = " + id;
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error updating profile: " + e.getMessage());
            return false;
        }
    }
    
    public boolean updatePassword(String newPassword, DB db) {
        try {
            if (newPassword.length() > 25) {
                System.err.println("Password too long (max 25 characters)");
                return false;
            }
            String query = "UPDATE user SET password = '" + newPassword + "' WHERE id = " + id;
            db.runQuery(query);
            this.password = newPassword;
            return true;
        } catch (Exception e) {
            System.err.println("Error updating password: " + e.getMessage());
            return false;
        }
    }

    public void deleteUser(DB db) {
        try {
            String query = "DELETE FROM user WHERE id = " + this.id;
            db.runQuery(query);
        } catch (Exception e) {
            System.err.println("Error deleting user: " + e.getMessage());
        }
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
