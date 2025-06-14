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

@WebServlet(name = "DeleteJournalEntryServlet", urlPatterns = {"/DeleteJournalEntryServlet"})
public class DeleteJournalEntryServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login_page.jsp");
            return;
        }
        
        String idStr = request.getParameter("id");
        
        if (idStr == null) {
            response.sendRedirect("HomeServlet?page=journal&error=Invalid journal entry ID");
            return;
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
            
            boolean success = journalEntry.deleteEntry(db);
            
            if (success) {
                response.sendRedirect("HomeServlet?page=journal&success=Journal entry deleted successfully");
            } else {
                response.sendRedirect("HomeServlet?page=journal&error=Failed to delete journal entry");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("HomeServlet?page=journal&error=Invalid journal entry ID");
        } catch (Exception e) {
            response.sendRedirect("HomeServlet?page=journal&error=Error deleting journal entry: " + e.getMessage());
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
        return "Delete Journal Entry servlet";
    }
}
