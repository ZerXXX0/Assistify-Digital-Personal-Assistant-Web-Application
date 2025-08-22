package model;

import config.DB;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Alarm {
    private int id;
    private String title;
    private Timestamp time;
    private String status;
    private int userId;

    // Constructors
    public Alarm() {}
    
    public Alarm(String title, Timestamp time, String status, int userId) {
        this.title = title;
        this.time = time;
        this.status = status;
        this.userId = userId;
    }
    
    public Alarm(int id, String title, Timestamp time, String status, int userId) {
        this.id = id;
        this.title = title;
        this.time = time;
        this.status = status;
        this.userId = userId;
    }

    // Database operations
    public boolean saveToDatabase(DB db) {
        try {
            String query = "INSERT INTO alarm (title, time, status, user_id) VALUES ('" + 
                          title + "', '" + time + "', '" + status + "', " + userId + ")";
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error saving alarm: " + e.getMessage());
            return false;
        }
    }
    
    public static List<Alarm> getAllAlarms(DB db) {
        List<Alarm> alarms = new ArrayList<>();
        try {
            String query = "SELECT * FROM alarm ORDER BY time ASC";
            ResultSet rs = db.getData(query);
            
            while (rs != null && rs.next()) {
                Alarm alarm = new Alarm();
                alarm.setId(rs.getInt("id"));
                alarm.setTitle(rs.getString("title"));
                alarm.setTime(rs.getTimestamp("time"));
                alarm.setStatus(rs.getString("status"));
                alarm.setUserId(rs.getInt("user_id"));
                alarms.add(alarm);
            }
        } catch (SQLException e) {
            System.err.println("Error getting alarms: " + e.getMessage());
        }
        return alarms;
    }
    
    public static List<Alarm> getAlarmsByUser(DB db, int userId) {
        List<Alarm> alarms = new ArrayList<>();
        try {
            String query = "SELECT * FROM alarm WHERE user_id = " + userId + " ORDER BY time ASC";
            ResultSet rs = db.getData(query);
            
            while (rs != null && rs.next()) {
                Alarm alarm = new Alarm();
                alarm.setId(rs.getInt("id"));
                alarm.setTitle(rs.getString("title"));
                alarm.setTime(rs.getTimestamp("time"));
                alarm.setStatus(rs.getString("status"));
                alarm.setUserId(rs.getInt("user_id"));
                alarms.add(alarm);
            }
        } catch (SQLException e) {
            System.err.println("Error getting alarms by user: " + e.getMessage());
        }
        return alarms;
    }
    
    public static Alarm getAlarmById(int id, DB db) {
        try {
            String query = "SELECT * FROM alarm WHERE id = " + id;
            ResultSet rs = db.getData(query);
            
            if (rs != null && rs.next()) {
                Alarm alarm = new Alarm();
                alarm.setId(rs.getInt("id"));
                alarm.setTitle(rs.getString("title"));
                alarm.setTime(rs.getTimestamp("time"));
                alarm.setStatus(rs.getString("status"));
                alarm.setUserId(rs.getInt("user_id"));
                return alarm;
            }
        } catch (SQLException e) {
            System.err.println("Error getting alarm by id: " + e.getMessage());
        }
        return null;
    }
    
    public boolean updateAlarm(DB db) {
        try {
            String query = "UPDATE alarm SET title = '" + title + "', time = '" + time + 
                          "', status = '" + status + "' WHERE id = " + id;
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error updating alarm: " + e.getMessage());
            return false;
        }
    }
    
    public boolean deleteAlarm(DB db) {
        try {
            String query = "DELETE FROM alarm WHERE id = " + id;
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error deleting alarm: " + e.getMessage());
            return false;
        }
    }

    // Helper methods
    public String getTimeAsDateTime() {
        return time.toString();
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }

    public Timestamp getTime() {
        return time;
    }

    public void setTime(Timestamp time) {
        this.time = time;
    }
    
    public void setTime(LocalDateTime time) {
        this.time = Timestamp.valueOf(time);
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }
}
