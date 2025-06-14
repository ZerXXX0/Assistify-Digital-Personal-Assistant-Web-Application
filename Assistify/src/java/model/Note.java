package model;

import config.DB;
import java.sql.Timestamp;

public abstract class Note {
    protected int id;
    protected String title;
    protected Timestamp createdDate;
    protected int userId;

    // Constructors
    public Note() {}
    
    public Note(String title, Timestamp createdDate) {
        this.title = title;
        this.createdDate = createdDate;
    }
    
    public Note(int id, String title, Timestamp createdDate, int userId) {
        this.id = id;
        this.title = title;
        this.createdDate = createdDate;
        this.userId = userId;
    }

    // Abstract methods to be implemented by subclasses
    public abstract boolean saveToDatabase(DB db);
    public abstract boolean updateNote(DB db);
    public abstract boolean deleteNote(DB db);
    public static Note getNoteById(int id, DB db) {
        // Try to get from TextNote first
        TextNote textNote = TextNote.getTextNoteById(id, db);
        if (textNote != null) {
            return textNote;
        }
        
        // Try to get from VoiceNote
        VoiceNote voiceNote = VoiceNote.getVoiceNoteById(id, db);
        if (voiceNote != null) {
            return voiceNote;
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

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    // Default implementations for TextNote and VoiceNote compatibility
    public String getTextNote() {
        return null;
    }
    
    public void setTextNote(String textNote) {
        // Override in TextNote
    }
    
    public String getVoiceNote() {
        return null;
    }
    
    public void setVoiceNote(String voiceNote) {
        // Override in VoiceNote
    }
}
