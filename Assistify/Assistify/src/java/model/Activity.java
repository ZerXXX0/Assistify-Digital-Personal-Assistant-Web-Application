package model;

import config.DB;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Activity extends Task {
    private String description;
    private Timestamp startTime;
    private Timestamp endTime;

    // Constructors
    public Activity() {
        super();
    }
    
    public Activity(String title, String description, Timestamp startTime, Timestamp endTime) {
        super(title);
        this.description = description;
        this.startTime = startTime;
        this.endTime = endTime;
    }
    
    public Activity(int id, String title, String description, Timestamp startTime, Timestamp endTime, int userId) {
        super(id, title, userId);
        this.description = description;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    // Database operations
    @Override
    public boolean saveToDatabase(DB db) {
        try {
            String query = "INSERT INTO activity (title, description, start_time, end_time, user_id) VALUES ('" + 
                          (getTitle() != null ? getTitle().replace("'", "''") : "") + "', '" + 
                          (description != null ? description.replace("'", "''") : "") + "', " + 
                          (startTime != null ? "'" + startTime + "'" : "NULL") + ", " + 
                          (endTime != null ? "'" + endTime + "'" : "NULL") + ", " + 
                          getUserId() + ")";
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error saving activity: " + e.getMessage());
            return false;
        }
    }
    
    public static List<Activity> getAllActivities(DB db, int userId) {
        List<Activity> activities = new ArrayList<>();
        try {
            String query = "SELECT * FROM activity WHERE user_id = " + userId + " ORDER BY start_time ASC";
            ResultSet rs = db.getData(query);
            
            while (rs != null && rs.next()) {
                Activity activity = new Activity(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("description"),
                    rs.getTimestamp("start_time"),
                    rs.getTimestamp("end_time"),
                    rs.getInt("user_id")
                );
                activities.add(activity);
            }
        } catch (SQLException e) {
            System.err.println("Error getting activities: " + e.getMessage());
        }
        return activities;
    }
    
    // Alternative method name for consistency
    public static List<Activity> getActivitiesByUser(DB db, int userId) {
        return getAllActivities(db, userId);
    }
    
    public static List<Activity> getTodayActivities(DB db, int userId) {
        List<Activity> activities = new ArrayList<>();
        try {
            String query = "SELECT * FROM activity WHERE user_id = " + userId + 
                          " AND DATE(start_time) = CURDATE() ORDER BY start_time ASC";
            ResultSet rs = db.getData(query);
            
            while (rs != null && rs.next()) {
                Activity activity = new Activity(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("description"),
                    rs.getTimestamp("start_time"),
                    rs.getTimestamp("end_time"),
                    rs.getInt("user_id")
                );
                activities.add(activity);
            }
        } catch (SQLException e) {
            System.err.println("Error getting today's activities: " + e.getMessage());
        }
        return activities;
    }
    
    public static Activity getActivityById(int id, DB db) {
        try {
            String query = "SELECT * FROM activity WHERE id = " + id;
            ResultSet rs = db.getData(query);
            
            if (rs != null && rs.next()) {
                return new Activity(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("description"),
                    rs.getTimestamp("start_time"),
                    rs.getTimestamp("end_time"),
                    rs.getInt("user_id")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error getting activity: " + e.getMessage());
        }
        return null;
    }
    
    @Override
    public boolean updateTask(DB db) {
        try {
            String query = "UPDATE activity SET title = '" + 
                          (getTitle() != null ? getTitle().replace("'", "''") : "") + "', description = '" + 
                          (description != null ? description.replace("'", "''") : "") + "', start_time = " + 
                          (startTime != null ? "'" + startTime + "'" : "NULL") + ", end_time = " + 
                          (endTime != null ? "'" + endTime + "'" : "NULL") + 
                          " WHERE id = " + getId();
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error updating activity: " + e.getMessage());
            return false;
        }
    }
    
    @Override
    public boolean deleteTask(DB db) {
        try {
            // Delete related reminders first
            String deleteReminders = "DELETE FROM reminder WHERE idtask = " + getId() + " AND type = 'activity'";
            db.runQuery(deleteReminders);
            
            // Delete the activity
            String query = "DELETE FROM activity WHERE id = " + getId();
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error deleting activity: " + e.getMessage());
            return false;
        }
    }
    
    public boolean setReminder(DB db, String message, Timestamp time) {
        try {
            String query = "INSERT INTO reminder (time, message, idtask, type, user_id) VALUES ('" + 
                          time + "', '" + 
                          (message != null ? message.replace("'", "''") : "") + "', " + 
                          getId() + ", 'activity', " + getUserId() + ")";
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error setting reminder: " + e.getMessage());
            return false;
        }
    }

    // Getters and Setters
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getStartTime() {
        return startTime;
    }

    public void setStartTime(Timestamp startTime) {
        this.startTime = startTime;
    }

    public Timestamp getEndTime() {
        return endTime;
    }

    public void setEndTime(Timestamp endTime) {
        this.endTime = endTime;
    }
}
