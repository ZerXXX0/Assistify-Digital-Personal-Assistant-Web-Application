package model;

import config.DB;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Reminder {
    private int id;
    private Timestamp time;
    private String message;
    private int idtask;
    private String type; // "todoitem" or "activity"
    private int userId;

    // Constructors
    public Reminder() {}
    
    public Reminder(Timestamp time, String message, int idtask, String type, int userId) {
        this.time = time;
        this.message = message;
        this.idtask = idtask;
        this.type = type;
        this.userId = userId;
    }
    
    public Reminder(int id, Timestamp time, String message, int idtask, String type, int userId) {
        this.id = id;
        this.time = time;
        this.message = message;
        this.idtask = idtask;
        this.type = type;
        this.userId = userId;
    }

    // Database operations
    public boolean saveToDatabase(DB db) {
        try {
            String query = "INSERT INTO reminder (time, message, idtask, type, user_id) VALUES ('" + 
                          time + "', '" + (message != null ? message.replace("'", "''") : "") + "', " + 
                          (idtask > 0 ? idtask : "NULL") + ", " +
                          (type != null ? "'" + type + "'" : "NULL") + ", " + userId + ")";
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error saving reminder: " + e.getMessage());
            return false;
        }
    }
    
    public static List<Reminder> getRemindersByUser(DB db, int userId) {
        List<Reminder> reminders = new ArrayList<>();
        try {
            String query = "SELECT * FROM reminder WHERE user_id = " + userId + " ORDER BY time ASC";
            ResultSet rs = db.getData(query);
            
            while (rs != null && rs.next()) {
                Reminder reminder = new Reminder();
                reminder.setId(rs.getInt("id"));
                reminder.setTime(rs.getTimestamp("time"));
                reminder.setMessage(rs.getString("message"));
                reminder.setIdtask(rs.getInt("idtask"));
                reminder.setType(rs.getString("type"));
                reminder.setUserId(rs.getInt("user_id"));
                reminders.add(reminder);
            }
        } catch (SQLException e) {
            System.err.println("Error getting reminders by user: " + e.getMessage());
        }
        return reminders;
    }
    
        public static List<Reminder> getRemindersByUser(DB db, int userId, int limit) {
        List<Reminder> reminders = new ArrayList<>();
        try {
            // Construct the query with the LIMIT clause
            String query = "SELECT * FROM reminder WHERE user_id = " + userId +
                           " ORDER BY time ASC LIMIT " + limit; // Added LIMIT clause
            ResultSet rs = db.getData(query);

            while (rs != null && rs.next()) {
                Reminder reminder = new Reminder();
                reminder.setId(rs.getInt("id"));
                reminder.setTime(rs.getTimestamp("time"));
                reminder.setMessage(rs.getString("message"));
                // Check for null before getting int for nullable columns
                reminder.setIdtask(rs.getObject("idtask") != null ? rs.getInt("idtask") : 0); // Assuming 0 as default if null
                reminder.setType(rs.getString("type"));
                reminder.setUserId(rs.getInt("user_id"));
                reminders.add(reminder);
            }
        } catch (SQLException e) {
            System.err.println("Error getting reminders by user with limit: " + e.getMessage());
            e.printStackTrace();
        }
        return reminders;
    }
        
    public static List<Reminder> getActiveReminders(DB db, int userId) {
        List<Reminder> reminders = new ArrayList<>();
        try {
            String query = "SELECT * FROM reminder WHERE user_id = " + userId + 
                          " AND time <= NOW() AND time >= DATE_SUB(NOW(), INTERVAL 1 MINUTE) ORDER BY time DESC";
            ResultSet rs = db.getData(query);
            
            while (rs != null && rs.next()) {
                Reminder reminder = new Reminder();
                reminder.setId(rs.getInt("id"));
                reminder.setTime(rs.getTimestamp("time"));
                reminder.setMessage(rs.getString("message"));
                reminder.setIdtask(rs.getInt("idtask"));
                reminder.setType(rs.getString("type"));
                reminder.setUserId(rs.getInt("user_id"));
                reminders.add(reminder);
            }
        } catch (SQLException e) {
            System.err.println("Error getting active reminders: " + e.getMessage());
        }
        return reminders;
    }
    
    public static Reminder getReminderById(int id, DB db) {
        try {
            String query = "SELECT * FROM reminder WHERE id = " + id;
            ResultSet rs = db.getData(query);
            
            if (rs != null && rs.next()) {
                return new Reminder(
                    rs.getInt("id"),
                    rs.getTimestamp("time"),
                    rs.getString("message"),
                    rs.getInt("idtask"),
                    rs.getString("type"),
                    rs.getInt("user_id")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error getting reminder: " + e.getMessage());
        }
        return null;
    }
    
    public boolean updateReminder(DB db) {
        try {
            String query = "UPDATE reminder SET time = '" + time + "', message = '" + 
                          (message != null ? message.replace("'", "''") : "") + "', idtask = " + 
                          (idtask > 0 ? idtask : "NULL") + ", type = " +
                          (type != null ? "'" + type + "'" : "NULL") + " WHERE id = " + id;
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error updating reminder: " + e.getMessage());
            return false;
        }
    }
    
    public boolean deleteReminder(DB db) {
        try {
            String query = "DELETE FROM reminder WHERE id = " + id;
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error deleting reminder: " + e.getMessage());
            return false;
        }
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Timestamp getTime() {
        return time;
    }

    public void setTime(Timestamp time) {
        this.time = time;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public int getIdtask() {
        return idtask;
    }

    public void setIdtask(int idtask) {
        this.idtask = idtask;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }
}
