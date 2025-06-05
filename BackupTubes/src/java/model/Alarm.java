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
    private LocalDateTime time;
    private String status;

    // Constructors
    public Alarm() {}
    
    public Alarm(LocalDateTime time, String status){
        this.time = time;
        this.status = status;
    }
    
    public Alarm(int id, LocalDateTime time, String status) {
        this.id = id;
        this.time = time;
        this.status = status;
    }

    // Database operations
    public boolean saveToDatabase(DB db) {
        try {
            String query = "INSERT INTO alarm (time, status) VALUES ('" + 
                          Timestamp.valueOf(time) + "', '" + status + "')";
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
                Alarm alarm = new Alarm(
                    rs.getInt("id"),
                    rs.getTimestamp("time").toLocalDateTime(),
                    rs.getString("status")
                );
                alarms.add(alarm);
            }
        } catch (SQLException e) {
            System.err.println("Error getting alarms: " + e.getMessage());
        }
        return alarms;
    }
    
    public static Alarm getAlarmById(int id, DB db) {
        try {
            String query = "SELECT * FROM alarm WHERE id = " + id;
            ResultSet rs = db.getData(query);
            
            if (rs != null && rs.next()) {
                return new Alarm(
                    rs.getInt("id"),
                    rs.getTimestamp("time").toLocalDateTime(),
                    rs.getString("status")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error getting alarm: " + e.getMessage());
        }
        return null;
    }
    
    public boolean updateAlarm(DB db) {
        try {
            String query = "UPDATE alarm SET time = '" + Timestamp.valueOf(time) + 
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

    public void setTime(LocalDateTime time) {
        this.time = time;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
