package model;

import config.DB;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class TextNote extends Note {
    private String noteText;

    // Constructors
    public TextNote() {
        super();
    }
    
    public TextNote(String title, String noteText, Timestamp createdDate) {
        super(title, createdDate);
        this.noteText = noteText;
    }
    
    public TextNote(int id, String title, String noteText, Timestamp createdDate, int userId) {
        super(id, title, createdDate, userId);
        this.noteText = noteText;
    }

    // Database operations
    @Override
    public boolean saveToDatabase(DB db) {
        try {
            String query = "INSERT INTO textnote (title, note_text, created_date, user_id) VALUES ('" + 
                          (title != null ? title.replace("'", "''") : "") + "', '" + 
                          (noteText != null ? noteText.replace("'", "''") : "") + "', '" + 
                          createdDate + "', " + userId + ")";
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error saving text note: " + e.getMessage());
            return false;
        }
    }
    
    public static List<TextNote> getAllTextNotes(DB db, int userId) {
        List<TextNote> notes = new ArrayList<>();
        try {
            String query = "SELECT * FROM textnote WHERE user_id = " + userId + " ORDER BY created_date DESC";
            ResultSet rs = db.getData(query);
            
            while (rs != null && rs.next()) {
                TextNote note = new TextNote(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("note_text"),
                    rs.getTimestamp("created_date"),
                    rs.getInt("user_id")
                );
                notes.add(note);
            }
        } catch (SQLException e) {
            System.err.println("Error getting text notes: " + e.getMessage());
        }
        return notes;
    }
    
    public static List<TextNote> getRecentTextNotesByUser(DB db, int userId, int limit) {
        List<TextNote> notes = new ArrayList<>();
        try {
            String query = "SELECT * FROM textnote WHERE user_id = " + userId + " ORDER BY created_date DESC LIMIT " + limit;
            ResultSet rs = db.getData(query);
            
            while (rs != null && rs.next()) {
                TextNote note = new TextNote(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("note_text"),
                    rs.getTimestamp("created_date"),
                    rs.getInt("user_id")
                );
                notes.add(note);
            }
        } catch (SQLException e) {
            System.err.println("Error getting recent text notes: " + e.getMessage());
        }
        return notes;
    }
    
    public static TextNote getTextNoteById(int id, DB db) {
        try {
            String query = "SELECT * FROM textnote WHERE id = " + id;
            ResultSet rs = db.getData(query);
            
            if (rs != null && rs.next()) {
                return new TextNote(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("note_text"),
                    rs.getTimestamp("created_date"),
                    rs.getInt("user_id")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error getting text note: " + e.getMessage());
        }
        return null;
    }
    
    @Override
    public boolean updateNote(DB db) {
        try {
            String query = "UPDATE textnote SET title = '" + 
                          (title != null ? title.replace("'", "''") : "") + "', note_text = '" + 
                          (noteText != null ? noteText.replace("'", "''") : "") + 
                          "' WHERE id = " + id;
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error updating text note: " + e.getMessage());
            return false;
        }
    }
    
    @Override
    public boolean deleteNote(DB db) {
        try {
            String query = "DELETE FROM textnote WHERE id = " + id;
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error deleting text note: " + e.getMessage());
            return false;
        }
    }
    
    // Override parent methods for compatibility
    @Override
    public String getTextNote() {
        return noteText;
    }
    
    @Override
    public void setTextNote(String textNote) {
        this.noteText = textNote;
    }
    
    public void showNote() {
        System.out.println("Title: " + title);
        System.out.println("Content: " + noteText);
        System.out.println("Created: " + createdDate);
    }
    
    public void editNote(String newText) {
        this.noteText = newText;
    }

    // Getters and Setters
    public String getNoteText() {
        return noteText;
    }

    public void setNoteText(String noteText) {
        this.noteText = noteText;
    }
}
