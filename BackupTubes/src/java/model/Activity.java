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


public class Activity extends Task {


    public Activity() {}

    public Activity(String title, String description, LocalDateTime startTime, LocalDateTime endTime) {
        super();
    }

    public Activity(int idtask, String title, String description, LocalDateTime startTime, int priority) {
        super();
    }

    public boolean insertActivity(DB db) {
        try {
            String query = "INSERT INTO task (title, description, startTime, endTime, priority) VALUES ('" + 
                          getTitle() + "', '" + (getDescription() != null ? getDescription() : "") + "', '" + 
                          getStartTime() + "', " + getPriority() + ")";
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
            String query = "UPDATE task SET title = '" + getTitle() + "', description = '" + 
                          (getDescription() != null ? getDescription() : "") + "', startTime = '" + 
                          Timestamp.valueOf(getStartTime()) + "', priority = " + getPriority() + 
                          " WHERE idtask = " + getIdtask();
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
            String deleteReminders = "DELETE FROM reminder WHERE idtask = " + getIdtask();
            db.runQuery(deleteReminders);
            
            // Delete the activity
            String query = "DELETE FROM task WHERE idtask = " + getIdtask();
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error deleting activity: " + e.getMessage());
            return false;
        }
    }
}
