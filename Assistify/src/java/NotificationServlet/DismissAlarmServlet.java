package NotificationServlet;

import config.DB;
import model.Alarm;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "DismissAlarmServlet", urlPatterns = {"/DismissAlarmServlet"})
public class DismissAlarmServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain;charset=UTF-8");
        
        // Debug logging
        System.out.println("=== DismissAlarmServlet Debug ===");
        System.out.println("Method: " + request.getMethod());
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("Error: Not logged in");
            response.getWriter().write("error: Not logged in");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        String alarmIdStr = request.getParameter("alarmId");
        
        System.out.println("User ID: " + userId);
        System.out.println("Alarm ID: " + alarmIdStr);
        
        if (alarmIdStr == null) {
            String errorMsg = "error: Missing alarmId parameter";
            System.out.println(errorMsg);
            response.getWriter().write(errorMsg);
            return;
        }
        
        try {
            int alarmId = Integer.parseInt(alarmIdStr.trim());
            
            DB db = new DB();
            db.connect();
            
            try {
                // Get the current alarm
                Alarm alarm = Alarm.getAlarmById(alarmId, db);
                if (alarm == null) {
                    String errorMsg = "error: Alarm not found with ID: " + alarmId;
                    System.out.println(errorMsg);
                    response.getWriter().write(errorMsg);
                    return;
                }
                
                // Check if this alarm belongs to the current user
                if (alarm.getUserId() != userId) {
                    String errorMsg = "error: You don't have permission to dismiss this alarm";
                    System.out.println(errorMsg);
                    response.getWriter().write(errorMsg);
                    return;
                }
                
                // Set alarm status to dismissed/inactive
                alarm.setStatus("inactive");
                
                boolean success = alarm.updateAlarm(db);
                
                if (success) {
                    System.out.println("Alarm dismissed successfully");
                    response.getWriter().write("success: Alarm dismissed");
                } else {
                    String errorMsg = "error: Failed to dismiss alarm";
                    System.out.println(errorMsg);
                    response.getWriter().write(errorMsg);
                }
                
            } catch (Exception e) {
                String errorMsg = "error: Database error - " + e.getMessage();
                System.err.println("Database error: " + e.getMessage());
                e.printStackTrace();
                response.getWriter().write(errorMsg);
            } finally {
                db.disconnect();
            }
            
        } catch (NumberFormatException e) {
            String errorMsg = "error: Invalid number format - alarmId: '" + alarmIdStr + "'";
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
        return "Dismiss Alarm servlet - marks alarm as dismissed";
    }
}
