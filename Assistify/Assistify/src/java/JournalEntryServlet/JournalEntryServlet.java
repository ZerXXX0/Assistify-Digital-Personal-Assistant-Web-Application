package JournalEntryServlet;

import config.DB;
import model.JournalEntry;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "JournalEntryServlet", urlPatterns = {"/JournalEntryServlet"})
public class JournalEntryServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login_page.jsp");
            return;
        }
    
        int userId = (Integer) session.getAttribute("userId");
        DB db = new DB();
    
        try {
            db.connect();
            List<JournalEntry> journalList = JournalEntry.getEntriesByUser(db, userId);
            
            System.out.println("Loading journal entries for user: " + userId);
            System.out.println("Journal entries found: " + journalList.size());
            request.setAttribute("journalList", journalList);
            response.sendRedirect("HomeServlet?page=journal");
        
        } catch (Exception e) {
            System.err.println("Error in JournalEntryServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("HomeServlet?page=journal&error=Error loading journal entries: " + e.getMessage());
        } finally {
            if (db != null) {
                db.disconnect();
            }
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
        return "Journal Entry management servlet";
    }
}
