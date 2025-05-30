package model;

import config.DB;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class JournalEntry {
    private int id;
    private Timestamp entrydate;
    private String content;

    // Constructors
    public JournalEntry() {}
    
    public JournalEntry(int id, Timestamp entrydate, String content) {
        this.id = id;
        this.entrydate = entrydate;
        this.content = content;
    }
    
    public JournalEntry(Timestamp entrydate, String content) {
        this.entrydate = entrydate;
        this.content = content;
    }

    // Database operations
    public boolean saveToDatabase(DB db) {
        try {
            String query = "INSERT INTO journalentry (entrydate, content) VALUES ('" + 
                          entrydate + "', '" + content + "')";
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error saving journal entry: " + e.getMessage());
            return false;
        }
    }
    
    public static List<JournalEntry> getAllEntries(DB db) {
        List<JournalEntry> entries = new ArrayList<>();
        try {
            String query = "SELECT * FROM journalentry ORDER BY entrydate DESC";
            ResultSet rs = db.getData(query);
            
            while (rs != null && rs.next()) {
                JournalEntry entry = new JournalEntry(
                    rs.getInt("id"),
                    rs.getTimestamp("entrydate"),
                    rs.getString("content")
                );
                entries.add(entry);
            }
        } catch (SQLException e) {
            System.err.println("Error getting journal entries: " + e.getMessage());
        }
        return entries;
    }
    
    public boolean updateEntry(DB db) {
        try {
            String query = "UPDATE journalentry SET entrydate = '" + entrydate + 
                          "', content = '" + content + "' WHERE id = " + id;
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error updating journal entry: " + e.getMessage());
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

    public Timestamp getEntrydate() {
        return entrydate;
    }

    public void setEntrydate(Timestamp entrydate) {
        this.entrydate = entrydate;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
