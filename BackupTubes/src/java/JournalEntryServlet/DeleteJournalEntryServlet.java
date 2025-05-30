/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package JournalEntryServlet;

import config.DB;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Fathan Fardian Sanum
 */
@WebServlet(name = "DeleteJournalEntryServlet", urlPatterns = {"/DeleteJournalEntryServlet"})
public class DeleteJournalEntryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        DB db = new DB();
        
        db.connect();
        
        String query = "DELETE FROM journalentry WHERE id=" + id;
        db.runQuery(query);
        
        response.sendRedirect("JournalEntryServlet");
    }
}
