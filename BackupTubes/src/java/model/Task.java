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

public class Task {
    private int idtask;
    private String title;
    private String description;
    private Timestamp startTime;

    private Integer priority;

    // Constructors
    public Task() {}
    
    public Task(int idtask, String title, String description, Timestamp startTime, Integer priority) {
        this.idtask = idtask;
        this.title = title;
        this.description = description;
        this.startTime = startTime;
        this.priority = priority;
    }
    
    public Task(String title, String description, Timestamp startTime, Integer priority) {
        this.title = title;
        this.description = description;
        this.startTime = startTime;
        this.priority = priority;
    }

    // Database operations
    public boolean saveToDatabase(DB db) {
        try {
            String query = "INSERT INTO task (title, description, startTime, endTime, priority) VALUES ('" + 
                          title + "', '" + (description != null ? description : "") + "', '" + 
                          startTime + "', '" + (priority != null ? priority : "NULL") + ")";
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error saving task: " + e.getMessage());
            return false;
        }
    }
    
    public static List<Task> getAllTasks(DB db) {
        List<Task> tasks = new ArrayList<>();
        try {
            String query = "SELECT * FROM task ORDER BY startTime ASC";
            ResultSet rs = db.getData(query);
            
            while (rs != null && rs.next()) {
                Task task = new Task(
                    rs.getInt("idtask"),
                    rs.getString("title"),
                    rs.getString("description"),
                    rs.getTimestamp("startTime"),
                    rs.getObject("priority") != null ? rs.getInt("priority") : null
                );
                tasks.add(task);
            }
        } catch (SQLException e) {
            System.err.println("Error getting tasks: " + e.getMessage());
        }
        return tasks;
    }
    
    public static Task getTaskById(int idtask, DB db) {
        try {
            String query = "SELECT * FROM task WHERE idtask = " + idtask;
            ResultSet rs = db.getData(query);
            
            if (rs != null && rs.next()) {
                return new Task(
                    rs.getInt("idtask"),
                    rs.getString("title"),
                    rs.getString("description"),
                    rs.getTimestamp("startTime"),
                    rs.getObject("priority") != null ? rs.getInt("priority") : null
                );
            }
        } catch (SQLException e) {
            System.err.println("Error getting task: " + e.getMessage());
        }
        return null;
    }
    
    public boolean updateTask(DB db) {
        try {
            String query = "UPDATE task SET title = '" + title + "', description = '" + 
                          (description != null ? description : "") + "', startTime = '" + startTime + "', priority = " + 
                          (priority != null ? priority : "NULL") + " WHERE idtask = " + idtask;
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error updating task: " + e.getMessage());
            return false;
        }
    }
    
    public boolean deleteTask(DB db) {
        try {
            // First delete related reminders
            String deleteReminders = "DELETE FROM reminder WHERE idtask = " + idtask;
            db.runQuery(deleteReminders);
            
            // Then delete the task
            String query = "DELETE FROM task WHERE idtask = " + idtask;
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error deleting task: " + e.getMessage());
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

    public String getStartTime() {
        return "" + startTime;
    }

    public void setStartTime(Timestamp startTime) {
        this.startTime = startTime;
    }

    public Integer getPriority() {
        return priority;
    }

    public void setPriority(Integer priority) {
        this.priority = priority;
    }
}
