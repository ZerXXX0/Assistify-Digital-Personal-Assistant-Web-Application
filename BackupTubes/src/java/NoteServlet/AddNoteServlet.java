/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package NoteServlet;

import config.DB;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.Timestamp;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Fathan Fardian Sanum
 */
@WebServlet(name = "AddNoteServlet", urlPatterns = {"/AddNoteServlet"})
public class AddNoteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        DB db = new DB(); // Membuat object Koneksi
        
        db.connect(); // Koneksi ke database
        
        // Ambil data dari form
        String title = request.getParameter("title");
        String textNote = request.getParameter("textNote");
        String voiceNote = request.getParameter("voiceNote");
        
        Timestamp createdDate = request.getParameter("createdDate");
        
        // Buat object barang
        Note note = new Note(title, textNote, voiceNote, createdDate);
        
        String query = "INSERT INTO barang (title, textNote, voiceNote) VALUES ('"
                + note.getTitle() + "', '"
                + note.getTextNote() + "', '"
                + note.getVoiceNote() + "', '"
                + note.getCreatedDate() + "' )";
        
        // Simpan ke database
        db.runQuery(query);

        response.sendRedirect("BarangServlet");
    }
}
