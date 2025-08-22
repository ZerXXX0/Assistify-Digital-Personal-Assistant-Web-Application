package ReminderServlet;

import config.DB;
import model.Reminder;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "DeleteReminderServlet", urlPatterns = {"/DeleteReminderServlet"})
public class DeleteReminderServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login_page.jsp");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        String idStr = request.getParameter("id");
        
        if (idStr == null) {
            response.sendRedirect("ReminderServlet?page=reminder&error=Invalid reminder ID");
            return;
        }
        
        DB db = new DB();
        db.connect();
        
        try {
            int id = Integer.parseInt(idStr);
            
            // Verify ownership before deletion
            Reminder reminder = Reminder.getReminderById(id, db);
            if (reminder == null || reminder.getUserId() != userId) {
                response.sendRedirect("ReminderServlet?page=reminder&error=Reminder not found or access denied");
                return;
            }
            
            boolean success = reminder.deleteReminder(db);
            
            if (success) {
                response.sendRedirect("ReminderServlet?page=reminder&success=Reminder deleted successfully");
            } else {
                response.sendRedirect("ReminderServlet?page=reminder&error=Failed to delete reminder");
            }
            
        } catch (Exception e) {
            response.sendRedirect("ReminderServlet?page=reminder&error=Error deleting reminder: " + e.getMessage());
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
        return "Delete Reminder servlet";
    }
}
