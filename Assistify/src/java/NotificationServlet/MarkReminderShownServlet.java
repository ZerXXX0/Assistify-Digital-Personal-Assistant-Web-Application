package NotificationServlet;

import config.DB;
import model.Reminder;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "MarkReminderShownServlet", urlPatterns = {"/MarkReminderShownServlet"})
public class MarkReminderShownServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain;charset=UTF-8");
        
        // Debug logging
        System.out.println("=== MarkReminderShownServlet Debug ===");
        System.out.println("Method: " + request.getMethod());
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("Error: Not logged in");
            response.getWriter().write("error: Not logged in");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        String reminderIdStr = request.getParameter("reminderId");
        
        System.out.println("User ID: " + userId);
        System.out.println("Reminder ID: " + reminderIdStr);
        
        if (reminderIdStr == null) {
            String errorMsg = "error: Missing reminderId parameter";
            System.out.println(errorMsg);
            response.getWriter().write(errorMsg);
            return;
        }
        
        try {
            int reminderId = Integer.parseInt(reminderIdStr.trim());
            
            DB db = new DB();
            db.connect();
            
            try {
                // Get the current reminder
                Reminder reminder = Reminder.getReminderById(reminderId, db);
                if (reminder == null) {
                    String errorMsg = "error: Reminder not found with ID: " + reminderId;
                    System.out.println(errorMsg);
                    response.getWriter().write(errorMsg);
                    return;
                }
                
                // Check if this reminder belongs to the current user
                if (reminder.getUserId() != userId) {
                    String errorMsg = "error: You don't have permission to mark this reminder";
                    System.out.println(errorMsg);
                    response.getWriter().write(errorMsg);
                    return;
                }
                
                // Add a 'shown' field to reminder table or use a separate table to track shown reminders
                // For now, we'll add a simple log entry or update a status field
                // Since the Reminder model doesn't have a 'shown' status, we'll use a direct query
                
                String updateQuery = "UPDATE reminder SET message = CONCAT(message, ' [SHOWN]') WHERE id = " + reminderId + 
                                   " AND user_id = " + userId + " AND message NOT LIKE '%[SHOWN]%'";
                
                System.out.println("Marking reminder as shown: " + updateQuery);
                db.runQuery(updateQuery);
                
                System.out.println("Reminder marked as shown successfully");
                response.getWriter().write("success: Reminder marked as shown");
                
            } catch (Exception e) {
                String errorMsg = "error: Database error - " + e.getMessage();
                System.err.println("Database error: " + e.getMessage());
                e.printStackTrace();
                response.getWriter().write(errorMsg);
            } finally {
                db.disconnect();
            }
            
        } catch (NumberFormatException e) {
            String errorMsg = "error: Invalid number format - reminderId: '" + reminderIdStr + "'";
            System.out.println(errorMsg);
            response.getWriter().write(errorMsg);
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
        return "Mark Reminder as Shown servlet - tracks shown reminders";
    }
}
