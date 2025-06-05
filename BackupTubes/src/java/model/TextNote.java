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

public class TextNote {
    private int id;
    private String title;
    private String textNote;
    private LocalDateTime createdDate;
    
    // Constructors
    public TextNote() {
        this.createdDate = LocalDateTime.now();
    }
    
    public TextNote(String title, String textNote) {
        this.title = title;
        this.textNote = textNote;
        this.createdDate = LocalDateTime.now();
    }
    
    public TextNote(int id, String title, String textNote, LocalDateTime createdDate) {
        this.id = id;
        this.title = title;
        this.textNote = textNote;
        this.createdDate = createdDate;
    }
    
    public boolean createNote(DB db) {
        try {
            String query = "INSERT INTO note (title, textNote, createdDate) VALUES ('" + 
                          title + "', '" + textNote + "', '" + Timestamp.valueOf(createdDate) + "')";
            db.runQuery(query);
            System.out.println("Creating Text Note: " + title + ", at: " + createdDate);
            return true;
        } catch (Exception e) {
            System.err.println("Error creating note: " + e.getMessage());
            return false;
        }
    }
    
    public void showNote() {
        System.out.println("Text Note: " + textNote);
    }
    
    public boolean editNote(String newNote, DB db) {
        try {
            String query = "UPDATE note SET textNote = '" + newNote + "' WHERE id = " + this.id;
            db.runQuery(query);
            this.textNote = newNote;
            System.out.println("Text Note edited: " + textNote);
            return true;
        } catch (Exception e) {
            System.err.println("Error editing note: " + e.getMessage());
            return false;
        }
    }
    
    public static TextNote getNoteById(int id, DB db) {
        try {
            String query = "SELECT * FROM note WHERE id = " + id + " AND textNote IS NOT NULL";
            ResultSet rs = db.getData(query);
            
            if (rs != null && rs.next()) {
                return new TextNote(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("textNote"),
                    rs.getTimestamp("createdDate").toLocalDateTime()
                );
            }
        } catch (SQLException e) {
            System.err.println("Error getting note: " + e.getMessage());
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

    public String getTextNote() {
        return textNote;
    }

    public void setTextNote(String textNote) {
        this.textNote = textNote;
    }

    public String getCreatedDate() {
        return "" + createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }
}
