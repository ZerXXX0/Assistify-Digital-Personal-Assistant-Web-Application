package model;

import config.DB;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class VoiceNote extends Note {
    private String voiceFile;

    // Constructors
    public VoiceNote() {
        super();
    }
    
    public VoiceNote(String title, String voiceFile, Timestamp createdDate) {
        super(title, createdDate);
        this.voiceFile = voiceFile;
    }
    
    public VoiceNote(int id, String title, String voiceFile, Timestamp createdDate, int userId) {
        super(id, title, createdDate, userId);
        this.voiceFile = voiceFile;
    }

    // Database operations
    @Override
    public boolean saveToDatabase(DB db) {
        try {
            String query = "INSERT INTO voicenote (title, voice_file, created_date, user_id) VALUES ('" + 
                          (title != null ? title.replace("'", "''") : "") + "', '" + 
                          (voiceFile != null ? voiceFile.replace("'", "''") : "") + "', '" + 
                          createdDate + "', " + userId + ")";
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error saving voice note: " + e.getMessage());
            return false;
        }
    }
    
    public static List<VoiceNote> getAllVoiceNotes(DB db, int userId) {
        List<VoiceNote> notes = new ArrayList<>();
        try {
            String query = "SELECT * FROM voicenote WHERE user_id = " + userId + " ORDER BY created_date DESC";
            ResultSet rs = db.getData(query);
            
            while (rs != null && rs.next()) {
                VoiceNote note = new VoiceNote(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("voice_file"),
                    rs.getTimestamp("created_date"),
                    rs.getInt("user_id")
                );
                notes.add(note);
            }
        } catch (SQLException e) {
            System.err.println("Error getting voice notes: " + e.getMessage());
        }
        return notes;
    }
    
    public static List<VoiceNote> getRecentVoiceNotesByUser(DB db, int userId, int limit) {
        List<VoiceNote> notes = new ArrayList<>();
        try {
            String query = "SELECT * FROM voicenote WHERE user_id = " + userId + " ORDER BY created_date DESC LIMIT " + limit;
            ResultSet rs = db.getData(query);
            
            while (rs != null && rs.next()) {
                VoiceNote note = new VoiceNote(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("voice_file"),
                    rs.getTimestamp("created_date"),
                    rs.getInt("user_id")
                );
                notes.add(note);
            }
        } catch (SQLException e) {
            System.err.println("Error getting recent voice notes: " + e.getMessage());
        }
        return notes;
    }
    
    public static VoiceNote getVoiceNoteById(int id, DB db) {
        try {
            String query = "SELECT * FROM voicenote WHERE id = " + id;
            ResultSet rs = db.getData(query);
            
            if (rs != null && rs.next()) {
                return new VoiceNote(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("voice_file"),
                    rs.getTimestamp("created_date"),
                    rs.getInt("user_id")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error getting voice note: " + e.getMessage());
        }
        return null;
    }
    
    @Override
    public boolean updateNote(DB db) {
        try {
            String query = "UPDATE voicenote SET title = '" + 
                          (title != null ? title.replace("'", "''") : "") + "', voice_file = '" + 
                          (voiceFile != null ? voiceFile.replace("'", "''") : "") + 
                          "' WHERE id = " + id;
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error updating voice note: " + e.getMessage());
            return false;
        }
    }
    
    @Override
    public boolean deleteNote(DB db) {
        try {
            String query = "DELETE FROM voicenote WHERE id = " + id;
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error deleting voice note: " + e.getMessage());
            return false;
        }
    }
    
    // Override parent methods for compatibility
    @Override
    public String getVoiceNote() {
        return voiceFile;
    }
    
    @Override
    public void setVoiceNote(String voiceNote) {
        this.voiceFile = voiceNote;
    }
    
    public void playNote() {
        System.out.println("Playing voice note: " + voiceFile);
        // Implementation would depend on how you want to play audio files
    }

    // Getters and Setters
    public String getVoiceFile() {
        return voiceFile;
    }

    public void setVoiceFile(String voiceFile) {
        this.voiceFile = voiceFile;
    }
}
