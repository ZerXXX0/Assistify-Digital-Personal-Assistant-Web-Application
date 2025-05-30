/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import config.DB;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.sql.ResultSet;
import java.sql.SQLException;


public class Activity {
    private int idtask;
    private String title;
    private String description;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private int priority;


    public Activity() {}

    public Activity(String title, String description, LocalDateTime startTime, LocalDateTime endTime) {
        this.title = title;
        this.description = description;
        this.startTime = startTime;
        this.endTime = endTime;
        this.priority = 1; 
    }

    public Activity(int idtask, String title, String description, LocalDateTime startTime, LocalDateTime endTime, int priority) {
        this.idtask = idtask;
        this.title = title;
        this.description = description;
        this.startTime = startTime;
        this.endTime = endTime;
        this.priority = priority;
    }

    public boolean insertActivity(DB db) {
        try {
            String query = "INSERT INTO task (title, description, startTime, endTime, priority) VALUES ('" + 
                          this.title + "', '" + (this.description != null ? this.description : "") + "', '" + 
                          Timestamp.valueOf(this.startTime) + "', '" + Timestamp.valueOf(this.endTime) + "', " + 
                          this.priority + ")";
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error inserting activity: " + e.getMessage());
            return false;
        }
    }

    public static Activity getActivityById(DB db, int idtask) {
        Activity activity = null;
        try {
            String query = "SELECT * FROM task WHERE idtask = " + idtask;
            ResultSet rs = db.getData(query);
            if (rs != null && rs.next()) {
                activity = new Activity(
                    rs.getInt("idtask"), 
                    rs.getString("title"), 
                    rs.getString("description"),
                    rs.getTimestamp("startTime").toLocalDateTime(), 
                    rs.getTimestamp("endTime").toLocalDateTime(),
                    rs.getInt("priority")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error getting activity: " + e.getMessage());
        }
        return activity;
    }

    public boolean updateActivity(DB db) {
        try {
            String query = "UPDATE task SET title = '" + this.title + "', description = '" + 
                          (this.description != null ? this.description : "") + "', startTime = '" + 
                          Timestamp.valueOf(this.startTime) + "', endTime = '" + 
                          Timestamp.valueOf(this.endTime) + "', priority = " + this.priority + 
                          " WHERE idtask = " + this.idtask;
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error updating activity: " + e.getMessage());
            return false;
        }
    }

    public boolean deleteActivity(DB db) {
        try {
            // Delete related reminders first
            String deleteReminders = "DELETE FROM reminder WHERE idtask = " + this.idtask;
            db.runQuery(deleteReminders);
            
            // Delete the activity
            String query = "DELETE FROM task WHERE idtask = " + this.idtask;
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error deleting activity: " + e.getMessage());
            return false;
        }
    }

    // Getters and Setters
    public int getIdtask() {
        return idtask;
    }

    public void setIdtask(int idtask) {
        this.idtask = idtask;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDateTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }

    public LocalDateTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalDateTime endTime) {
        this.endTime = endTime;
    }

    public int getPriority() {
        return priority;
    }

    public void setPriority(int priority) {
        this.priority = priority;
    }
}
