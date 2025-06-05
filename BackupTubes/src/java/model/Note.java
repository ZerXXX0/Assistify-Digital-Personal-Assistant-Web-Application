/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import config.DB;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Note {
    private int id;
    private String title;
    private String textNote;
    private String voiceNote;
    private Timestamp createdDate;

    // Constructors
    public Note() {}
    
    public Note(int id, String title, String textNote, String voiceNote, Timestamp createdDate) {
        this.id = id;
        this.title = title;
        this.textNote = textNote;
        this.voiceNote = voiceNote;
        this.createdDate = createdDate;
    }
    
    public Note(String title, String textNote, String voiceNote, Timestamp createdDate) {
        this.title = title;
        this.textNote = textNote;
        this.voiceNote = voiceNote;
        this.createdDate = createdDate;
    }

    // Database operations
    public boolean saveToDatabase(DB db) {
        try {
            String query = "INSERT INTO note (title, textNote, voiceNote, createdDate) VALUES ('" + 
                          title + "', " + (textNote != null ? "'" + textNote + "'" : "NULL") + ", " +
                          (voiceNote != null ? "'" + voiceNote + "'" : "NULL") + ", '" + createdDate + "')";
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error saving note: " + e.getMessage());
            return false;
        }
    }
    
    public static List<Note> getAllNotes(DB db) {
        List<Note> notes = new ArrayList<>();
        try {
            String query = "SELECT * FROM note ORDER BY createdDate DESC";
            ResultSet rs = db.getData(query);
            
            while (rs != null && rs.next()) {
                Note note = new Note(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("textNote"),
                    rs.getString("voiceNote"),
                    rs.getTimestamp("createdDate")
                );
                notes.add(note);
            }
        } catch (SQLException e) {
            System.err.println("Error getting notes: " + e.getMessage());
        }
        return notes;
    }
    
    public static Note getNoteById(int id, DB db) {
        try {
            String query = "SELECT * FROM note WHERE id = " + id;
            ResultSet rs = db.getData(query);
            
            if (rs != null && rs.next()) {
                return new Note(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("textNote"),
                    rs.getString("voiceNote"),
                    rs.getTimestamp("createdDate")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error getting note: " + e.getMessage());
        }
        return null;
    }
    
    public boolean updateNote(DB db) {
        try {
            String query = "UPDATE note SET title = '" + title + "', textNote = " + 
                          (textNote != null ? "'" + textNote + "'" : "NULL") + ", voiceNote = " +
                          (voiceNote != null ? "'" + voiceNote + "'" : "NULL") + 
                          ", createdDate = '" + createdDate + "' WHERE id = " + id;
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error updating note: " + e.getMessage());
            return false;
        }
    }
    
    public boolean deleteNote(DB db) {
        try {
            String query = "DELETE FROM note WHERE id = " + id;
            db.runQuery(query);
            return true;
        } catch (Exception e) {
            System.err.println("Error deleting note: " + e.getMessage());
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

    public String getTextNote() {
        return textNote;
    }

    public void setTextNote(String textNote) {
        this.textNote = textNote;
    }

    public String getVoiceNote() {
        return voiceNote;
    }

    public void setVoiceNote(String voiceNote) {
        this.voiceNote = voiceNote;
    }

    public String getCreatedDate() {
        return "" + createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }
}
