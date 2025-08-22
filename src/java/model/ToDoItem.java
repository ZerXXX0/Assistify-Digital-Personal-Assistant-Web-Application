package model;

import config.DB;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ToDoItem extends Task {
    private Timestamp dueDate;
    private int priority;
    private boolean isCompleted;

    // Constructors
    public ToDoItem() {
        super();
    }
    
    public ToDoItem(String title, Timestamp dueDate, int priority) {
        super(title);
        this.dueDate = dueDate;
        this.priority = priority;
        this.isCompleted = false;
    }
    
    public ToDoItem(int id, String title, Timestamp dueDate, int priority, boolean isCompleted, int userId) {
        super(id, title, userId);
        this.dueDate = dueDate;
        this.priority = priority;
        this.isCompleted = isCompleted;
    }

    // Database operations
    @Override
    public boolean saveToDatabase(DB db) {
        try {
            String query = "INSERT INTO todoitem (title, due_date, priority, is_completed, user_id) VALUES ('" + 
                          (getTitle() != null ? getTitle().replace("'", "''") : "") + "', " + 
                          (dueDate != null ? "'" + dueDate + "'" : "NULL") + ", " + 
                          priority + ", " + 
                          (isCompleted ? "TRUE" : "FALSE") + ", " + 
                          getUserId() + ")";
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error saving todo item: " + e.getMessage());
            return false;
        }
    }
    
    public static List<ToDoItem> getAllToDoItems(DB db, int userId) {
        List<ToDoItem> items = new ArrayList<>();
        try {
            String query = "SELECT * FROM todoitem WHERE user_id = " + userId + " ORDER BY priority DESC";
            ResultSet rs = db.getData(query);
            
            while (rs != null && rs.next()) {
                ToDoItem item = new ToDoItem(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getTimestamp("due_date"),
                    rs.getInt("priority"),
                    rs.getBoolean("is_completed"),
                    rs.getInt("user_id")
                );
                items.add(item);
            }
        } catch (SQLException e) {
            System.err.println("Error getting todo items: " + e.getMessage());
        }
        return items;
    }
    
    // Alternative method name for consistency
    public static List<ToDoItem> getToDoItemsByUser(DB db, int userId) {
        return getAllToDoItems(db, userId);
    }
    
    public static ToDoItem getToDoItemById(int id, DB db) {
        try {
            String query = "SELECT * FROM todoitem WHERE id = " + id;
            ResultSet rs = db.getData(query);
            
            if (rs != null && rs.next()) {
                return new ToDoItem(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getTimestamp("due_date"),
                    rs.getInt("priority"),
                    rs.getBoolean("is_completed"),
                    rs.getInt("user_id")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error getting todo item: " + e.getMessage());
        }
        return null;
    }
    
    @Override
    public boolean updateTask(DB db) {
        try {
            String query = "UPDATE todoitem SET title = '" + 
                          (getTitle() != null ? getTitle().replace("'", "''") : "") + "', due_date = " + 
                          (dueDate != null ? "'" + dueDate + "'" : "NULL") + ", priority = " + 
                          priority + ", is_completed = " + 
                          (isCompleted ? "TRUE" : "FALSE") + 
                          " WHERE id = " + getId();
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error updating todo item: " + e.getMessage());
            return false;
        }
    }
    
    @Override
    public boolean deleteTask(DB db) {
        try {
            // Delete related reminders first
            String deleteReminders = "DELETE FROM reminder WHERE idtask = " + getId() + " AND type = 'todoitem'";
            db.runQuery(deleteReminders);
            
            // Delete the todo item
            String query = "DELETE FROM todoitem WHERE id = " + getId();
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error deleting todo item: " + e.getMessage());
            return false;
        }
    }
    
    public boolean markComplete(DB db) {
        this.isCompleted = true;
        return this.updateTask(db);
    }
    
    public boolean setReminder(DB db, String message, Timestamp time) {
        try {
            String query = "INSERT INTO reminder (time, message, idtask, type, user_id) VALUES ('" + 
                          time + "', '" + 
                          (message != null ? message.replace("'", "''") : "") + "', " + 
                          getId() + ", 'todoitem', " + getUserId() + ")";
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error setting reminder: " + e.getMessage());
            return false;
        }
    }

    // Getters and Setters
    public Timestamp getDueDate() {
        return dueDate;
    }

    public void setDueDate(Timestamp dueDate) {
        this.dueDate = dueDate;
    }

    public int getPriority() {
        return priority;
    }

    public void setPriority(int priority) {
        this.priority = priority;
    }
    
    public boolean isCompleted() {
        return isCompleted;
    }
    
    public void setCompleted(boolean isCompleted) {
        this.isCompleted = isCompleted;
    }
}
