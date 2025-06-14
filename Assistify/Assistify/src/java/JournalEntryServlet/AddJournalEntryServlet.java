package JournalEntryServlet;

import config.DB;
import model.JournalEntry;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AddJournalEntryServlet", urlPatterns = {"/AddJournalEntryServlet"})
public class AddJournalEntryServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login_page.jsp");
            return;
        }
        
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        if (content == null || content.trim().isEmpty()) {
            response.sendRedirect("HomeServlet?page=journal&error=Content is required");
            return;
        }
        
        // If title is empty, set a default title
        if (title == null || title.trim().isEmpty()) {
            title = "Journal Entry";
        }
        
        DB db = new DB();
        db.connect();
        
        try {
            int userId = (Integer) session.getAttribute("userId");
            JournalEntry journalEntry = new JournalEntry(title.trim(), content.trim(), userId);
            
            System.out.println("Adding journal entry for user: " + userId);
            System.out.println("Title: " + title);
            System.out.println("Content length: " + content.length());
            
            boolean success = journalEntry.saveToDatabase(db);
            
            if (success) {
                response.sendRedirect("HomeServlet?page=journal&success=Journal entry added successfully");
            } else {
                response.sendRedirect("HomeServlet?page=journal&error=Failed to add journal entry");
            }
            
        } catch (Exception e) {
            System.err.println("Error in AddJournalEntryServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("HomeServlet?page=journal&error=Error adding journal entry: " + e.getMessage());
        } finally {
            db.disconnect();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Add Journal Entry servlet";
    }
}
