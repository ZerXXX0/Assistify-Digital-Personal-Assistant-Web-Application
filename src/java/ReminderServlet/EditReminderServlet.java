package ReminderServlet;

import config.DB;
import model.Reminder;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "EditReminderServlet", urlPatterns = {"/EditReminderServlet"})
public class EditReminderServlet extends HttpServlet {

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
        String timeStr = request.getParameter("time");
        String message = request.getParameter("message");
        String type = request.getParameter("type");
        String idtaskStr = request.getParameter("idtask");
        
        // Validation
        if (idStr == null || timeStr == null || timeStr.trim().isEmpty() || 
            message == null || message.trim().isEmpty()) {
            response.sendRedirect("HomeServlet?page=reminder&error=Invalid parameters");
            return;
        }
        
        DB db = new DB();
        db.connect();
        
        try {
            int id = Integer.parseInt(idStr);
            
            // Verify ownership
            Reminder existingReminder = Reminder.getReminderById(id, db);
            if (existingReminder == null || existingReminder.getUserId() != userId) {
                response.sendRedirect("HomeServlet?page=reminder&error=Reminder not found or access denied");
                return;
            }
            
            LocalDateTime time = LocalDateTime.parse(timeStr, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
            int idtask = 0;
            
            // Parse idtask if provided and type is specified
            if (idtaskStr != null && !idtaskStr.trim().isEmpty() && 
                type != null && !type.trim().isEmpty()) {
                idtask = Integer.parseInt(idtaskStr);
            }
            
            // Update reminder
            Reminder reminder = new Reminder(
                id,
                Timestamp.valueOf(time), 
                message.trim(), 
                idtask, 
                (type != null && !type.trim().isEmpty()) ? type : null, 
                userId
            );
            
            boolean success = reminder.updateReminder(db);
            
            if (success) {
                response.sendRedirect("ReminderServlet?page=reminder&success=Reminder updated successfully");
            } else {
                response.sendRedirect("HomeServlet?page=reminder&error=Failed to update reminder");
            }
            
        } catch (Exception e) {
            response.sendRedirect("HomeServlet?page=reminder&error=Error updating reminder: " + e.getMessage());
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
        return "Edit Reminder servlet";
    }
}
