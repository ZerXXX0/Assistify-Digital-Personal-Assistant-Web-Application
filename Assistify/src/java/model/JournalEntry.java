package model;

import config.DB;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class JournalEntry {
    private int id;
    private String title;
    private String content;
    private Timestamp entrydate;
    private int userId;

    // Constructors
    public JournalEntry() {}
    
    public JournalEntry(String title, String content, int userId) {
        this.title = title;
        this.content = content;
        this.userId = userId;
        this.entrydate = new Timestamp(System.currentTimeMillis());
    }
    
    public JournalEntry(int id, String title, String content, Timestamp entrydate, int userId) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.entrydate = entrydate;
        this.userId = userId;
    }

    // Database operations
    public boolean saveToDatabase(DB db) {
        try {
            String safeTitle = (title != null ? title.replace("'", "''") : "");
            String safeContent = (content != null ? content.replace("'", "''") : "");
            
            String query = "INSERT INTO journalentry (title, content, entrydate, user_id) VALUES ('" + 
                          safeTitle + "', '" + safeContent + "', CURRENT_TIMESTAMP, " + userId + ")";
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error saving journal entry: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public static List<JournalEntry> getEntriesByUser(DB db, int userId) {
        List<JournalEntry> entries = new ArrayList<>();
        try {
            String query = "SELECT * FROM journalentry WHERE user_id = " + userId + " ORDER BY entrydate DESC";
            ResultSet rs = db.getData(query);
            
            while (rs != null && rs.next()) {
                JournalEntry entry = new JournalEntry();
                entry.setId(rs.getInt("id"));
                entry.setTitle(rs.getString("title"));
                entry.setContent(rs.getString("content"));
                entry.setEntrydate(rs.getTimestamp("entrydate"));
                entry.setUserId(rs.getInt("user_id"));
                entries.add(entry);
            }
        } catch (SQLException e) {
            System.err.println("Error getting journal entries by user: " + e.getMessage());
            e.printStackTrace();
        }
        return entries;
    }
    
    public static List<JournalEntry> getRecentEntriesByUser(DB db, int userId, int limit) {
        List<JournalEntry> entries = new ArrayList<>();
        try {
            String query = "SELECT * FROM journalentry WHERE user_id = " + userId + 
                          " ORDER BY entrydate DESC LIMIT " + limit;
            ResultSet rs = db.getData(query);
            
            while (rs != null && rs.next()) {
                JournalEntry entry = new JournalEntry();
                entry.setId(rs.getInt("id"));
                entry.setTitle(rs.getString("title"));
                entry.setContent(rs.getString("content"));
                entry.setEntrydate(rs.getTimestamp("entrydate"));
                entry.setUserId(rs.getInt("user_id"));
                entries.add(entry);
            }
        } catch (SQLException e) {
            System.err.println("Error getting recent journal entries: " + e.getMessage());
            e.printStackTrace();
        }
        return entries;
    }
    
    public static JournalEntry getEntryById(DB db, int id) {
        try {
            String query = "SELECT * FROM journalentry WHERE id = " + id;
            ResultSet rs = db.getData(query);
            
            if (rs != null && rs.next()) {
                return new JournalEntry(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("content"),
                    rs.getTimestamp("entrydate"),
                    rs.getInt("user_id")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error getting journal entry by id: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean updateEntry(DB db) {
        try {
            String safeTitle = (title != null ? title.replace("'", "''") : "");
            String safeContent = (content != null ? content.replace("'", "''") : "");
            
            String query = "UPDATE journalentry SET title = '" + safeTitle + 
                          "', content = '" + safeContent + "' WHERE id = " + id;
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error updating journal entry: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteEntry(DB db) {
        try {
            String query = "DELETE FROM journalentry WHERE id = " + id;
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error deleting journal entry: " + e.getMessage());
            e.printStackTrace();
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

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getEntrydate() {
        return entrydate;
    }

    public void setEntrydate(Timestamp entrydate) {
        this.entrydate = entrydate;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }
}
