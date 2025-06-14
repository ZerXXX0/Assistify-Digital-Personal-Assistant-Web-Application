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

@WebServlet(name = "EditJournalEntryServlet", urlPatterns = {"/EditJournalEntryServlet"})
public class EditJournalEntryServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login_page.jsp");
            return;
        }
        
        String idStr = request.getParameter("id");
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        
        if (idStr == null || content == null || content.trim().isEmpty()) {
            response.sendRedirect("HomeServlet?page=journal&error=Invalid parameters");
            return;
        }
        
        // If title is empty, set a default title
        if (title == null || title.trim().isEmpty()) {
            title = "Journal Entry";
        }
        
        DB db = new DB();
        db.connect();
        
        try {
            int id = Integer.parseInt(idStr);
            int userId = (Integer) session.getAttribute("userId");
            
            // Get existing journal entry and verify ownership
            JournalEntry journalEntry = JournalEntry.getEntryById(db, id);
            if (journalEntry == null || journalEntry.getUserId() != userId) {
                response.sendRedirect("HomeServlet?page=journal&error=Journal entry not found or access denied");
                return;
            }

            // Update the title and content
            journalEntry.setTitle(title.trim());
            journalEntry.setContent(content.trim());
            
            System.out.println("Updating journal entry ID: " + id);
            System.out.println("New title: " + title);
            System.out.println("New content length: " + content.length());
            
            boolean success = journalEntry.updateEntry(db);
            
            if (success) {
                response.sendRedirect("HomeServlet?page=journal&success=Journal entry updated successfully");
            } else {
                response.sendRedirect("HomeServlet?page=journal&error=Failed to update journal entry");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("HomeServlet?page=journal&error=Invalid journal entry ID");
        } catch (Exception e) {
            System.err.println("Error in EditJournalEntryServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("HomeServlet?page=journal&error=Error updating journal entry: " + e.getMessage());
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
        return "Edit Journal Entry servlet";
    }
}
