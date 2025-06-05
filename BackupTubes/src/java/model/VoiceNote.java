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
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;

public class VoiceNote {
    private int id;
    private String title;
    private String voiceNote; // path to voice file
    private LocalDateTime createdDate;
    
    // Constructors
    public VoiceNote() {
        this.createdDate = LocalDateTime.now();
    }
    
    public VoiceNote(String title, String voiceNotePath) {
        this.title = title;
        this.voiceNote = voiceNotePath;
        this.createdDate = LocalDateTime.now();
    }
    
    public VoiceNote(int id, String title, String voiceNote, LocalDateTime createdDate) {
        this.id = id;
        this.title = title;
        this.voiceNote = voiceNote;
        this.createdDate = createdDate;
    }
    
    public boolean createNote(DB db) {
        try {
            String query = "INSERT INTO note (title, voiceNote, createdDate) VALUES ('" + 
                          title + "', '" + voiceNote + "', '" + Timestamp.valueOf(createdDate) + "')";
            db.runQuery(query);
            System.out.println("Creating Voice Note: " + title + ", at: " + createdDate);
            return true;
        } catch (Exception e) {
            System.err.println("Error creating voice note: " + e.getMessage());
            return false;
        }
    }
    
    public void play() {
        try {
            InputStream inputStream = new FileInputStream(voiceNote);
            // Note: You'll need to add audio library for actual playback
            System.out.println("Playing voice note from: " + voiceNote);
        } catch (FileNotFoundException e) {
            System.out.println("Voice file not found: " + voiceNote);
        } catch (Exception e) {
            System.out.println("Error playing voice note: " + e.getMessage());
        }
    }
    
    public void stop() {
        System.out.println("Playback stopped.");
    }
    
    public static VoiceNote getVoiceNoteById(int id, DB db) {
        try {
            String query = "SELECT * FROM note WHERE id = " + id + " AND voiceNote IS NOT NULL";
            ResultSet rs = db.getData(query);
            
            if (rs != null && rs.next()) {
                return new VoiceNote(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("voiceNote"),
                    rs.getTimestamp("createdDate").toLocalDateTime()
                );
            }
        } catch (SQLException e) {
            System.err.println("Error getting voice note: " + e.getMessage());
        }
        return null;
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

    public String getVoiceNote() {
        return voiceNote;
    }

    public void setVoiceNote(String voiceNote) {
        this.voiceNote = voiceNote;
    }

    public String getCreatedDate() {
        return "" + createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }
}
