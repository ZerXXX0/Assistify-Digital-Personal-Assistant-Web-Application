/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package AlarmServlet;

import config.DB;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Alarm;

/**
 *
 * @author Fathan Fardian Sanum
 */
@WebServlet(name = "AddAlarmServlet", urlPatterns = {"/AddAlarmServlet"})
public class AddAlarmServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        DB db = new DB(); // Membuat object Koneksi
        
        db.connect(); // Koneksi ke database
        
        // Ambil data dari form
        String time = request.getParameter("time");
        String status = request.getParameter("status");
        
        // Buat object barang
        Alarm alarm = new Alarm(time, status);
        
        String query = "INSERT INTO alarm (time, status) VALUES ('"
                + alarm.getTime() +"', '"
                + alarm.getStatus()+ "' )";
        
        // Simpan ke database
        db.runQuery(query);

        response.sendRedirect("AlarmServlet");
    }
}
