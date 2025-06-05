/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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

    // Constructors
    public Reminder() {}
    
    public Reminder(int id, Timestamp time, String message, int idtask) {
        this.id = id;
        this.time = time;
        this.message = message;
        this.idtask = idtask;
    }
    
    public Reminder(Timestamp time, String message, int idtask) {
        this.time = time;
        this.message = message;
        this.idtask = idtask;
    }

    // Database operations
    public boolean saveToDatabase(DB db) {
        try {
            String query = "INSERT INTO reminder (time, message, idtask) VALUES ('" + 
                          time + "', '" + message + "', " + idtask + ")";
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error saving reminder: " + e.getMessage());
            return false;
        }
    }
    
    public static List<Reminder> getAllReminders(DB db) {
        List<Reminder> reminders = new ArrayList<>();
        try {
            String query = "SELECT * FROM reminder ORDER BY time ASC";
            ResultSet rs = db.getData(query);
            
            while (rs != null && rs.next()) {
                Reminder reminder = new Reminder(
                    rs.getInt("id"),
                    rs.getTimestamp("time"),
                    rs.getString("message"),
                    rs.getInt("idtask")
                );
                reminders.add(reminder);
            }
        } catch (SQLException e) {
            System.err.println("Error getting reminders: " + e.getMessage());
        }
        return reminders;
    }
    
    public static List<Reminder> getRemindersByTask(int idtask, DB db) {
        List<Reminder> reminders = new ArrayList<>();
        try {
            String query = "SELECT * FROM reminder WHERE idtask = " + idtask + " ORDER BY time ASC";
            ResultSet rs = db.getData(query);
            
            while (rs != null && rs.next()) {
                Reminder reminder = new Reminder(
                    rs.getInt("id"),
                    rs.getTimestamp("time"),
                    rs.getString("message"),
                    rs.getInt("idtask")
                );
                reminders.add(reminder);
            }
        } catch (SQLException e) {
            System.err.println("Error getting reminders by task: " + e.getMessage());
        }
        return reminders;
    }
    
    public boolean updateReminder(DB db) {
        try {
            String query = "UPDATE reminder SET time = '" + time + "', message = '" + 
                          message + "', idtask = " + idtask + " WHERE id = " + id;
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

    public String getTime() {
        return "" + time;
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
}
