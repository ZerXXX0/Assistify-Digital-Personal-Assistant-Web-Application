/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package ReminderServlet;

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
@WebServlet(name = "AddReminderServlet", urlPatterns = {"/AddReminderServlet"})
public class AddReminderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        DB db = new DB(); // Membuat object Koneksi
        
        db.connect(); // Koneksi ke database
        
        // Ambil data dari form
        Timestamp time = request.getParameter("time");
        String message = request.getParameter("message");
        int idTask = Integer.parseInt(request.getParameter("idtask"));
        
        // Buat object barang
        Reminder reminder = new Reminder(time, message, idTask);
        
        String query = "INSERT INTO reminder (time, message, idTask) VALUES ('"
                + reminder.getTime() + "', '"
                + reminder.getMessage() + "', '"
                + reminder.getIdTask() + "' )";
        
        // Simpan ke database
        db.runQuery(query);

        response.sendRedirect("ReminderServlet");
    }
}
