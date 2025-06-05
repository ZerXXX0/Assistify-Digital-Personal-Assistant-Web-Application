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

public class ToDoItem extends Task {

    public ToDoItem() {}

    public ToDoItem(String title, LocalDateTime startTime, int priority) {
        super();
    }

    public ToDoItem(int idtask, String title, String description, LocalDateTime startTime, int priority) {
        super();
    }

    // Database operations
    public boolean insertToDoItem(DB db) {
        try {
            String query = "INSERT INTO task (title, description, startTime, endTime, priority) VALUES ('" + 
                          getTitle() + "', '" + (getDescription() != null ? getDescription() : "") + "', '" + 
                          getStartTime() + "', " +  getPriority() + ")";
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error inserting todo item: " + e.getMessage());
            return false;
        }
    }

    public static ToDoItem getToDoItemById(DB db, int idtask) {
        ToDoItem toDoItem = null;
        try {
            String query = "SELECT * FROM task WHERE idtask = " + idtask;
            ResultSet rs = db.getData(query);
            if (rs != null && rs.next()) {
                toDoItem = new ToDoItem(
                    rs.getInt("idtask"), 
                    rs.getString("title"), 
                    rs.getString("description"),
                    rs.getTimestamp("startTime").toLocalDateTime(),
                    rs.getInt("priority")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error getting todo item: " + e.getMessage());
        }
        return toDoItem;
    }

    public boolean updateToDoItem(DB db) {
        try {
            String query = "UPDATE task SET title = '" + getTitle() + "', description = '" + 
                          (getDescription() != null ? getDescription() : "") + "', startTime = '" + 
                          getStartTime() + "', priority = " + getPriority() + 
                          " WHERE idtask = " + getIdtask();
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error updating todo item: " + e.getMessage());
            return false;
        }
    }

    public boolean deleteToDoItem(DB db) {
        try {
            // Delete related reminders first
            String deleteReminders = "DELETE FROM reminder WHERE idtask = " + getIdtask();
            db.runQuery(deleteReminders);
            
            // Delete the todo item
            String query = "DELETE FROM task WHERE idtask = " + getIdtask();
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error deleting todo item: " + e.getMessage());
            return false;
        }
    }

    public void markComplete() {
        System.out.println("Task '" + getTitle() + "' marked as completed.");
    }

    public void setReminder() {
        System.out.println("Setting reminder for ToDoItem: " + getTitle());
    }
}
