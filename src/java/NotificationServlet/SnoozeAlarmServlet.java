package NotificationServlet;

import config.DB;
import model.Alarm;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.Calendar;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "SnoozeAlarmServlet", urlPatterns = {"/SnoozeAlarmServlet"})
public class SnoozeAlarmServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain;charset=UTF-8");
        
        // Debug logging
        System.out.println("=== SnoozeAlarmServlet Debug ===");
        System.out.println("Method: " + request.getMethod());
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("Error: Not logged in");
            response.getWriter().write("error: Not logged in");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        String alarmIdStr = request.getParameter("alarmId");
        String minutesStr = request.getParameter("minutes");
        
        System.out.println("User ID: " + userId);
        System.out.println("Alarm ID: " + alarmIdStr);
        System.out.println("Minutes: " + minutesStr);
        
        if (alarmIdStr == null || minutesStr == null) {
            String errorMsg = "error: Missing parameters - alarmId: " + alarmIdStr + ", minutes: " + minutesStr;
            System.out.println(errorMsg);
            response.getWriter().write(errorMsg);
            return;
        }
        
        try {
            int alarmId = Integer.parseInt(alarmIdStr.trim());
            int minutes = Integer.parseInt(minutesStr.trim());
            
            // Validate minutes (reasonable range)
            if (minutes < 1 || minutes > 60) {
                String errorMsg = "error: Invalid minutes value: " + minutes + " (must be 1-60)";
                System.out.println(errorMsg);
                response.getWriter().write(errorMsg);
                return;
            }
            
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
                    String errorMsg = "error: You don't have permission to snooze this alarm";
                    System.out.println(errorMsg);
                    response.getWriter().write(errorMsg);
                    return;
                }
                
                // Calculate new time (current time + snooze minutes)
                Calendar calendar = Calendar.getInstance();
                calendar.add(Calendar.MINUTE, minutes);
                Timestamp newTime = new Timestamp(calendar.getTimeInMillis());
                
                System.out.println("Original alarm time: " + alarm.getTime());
                System.out.println("New snoozed time: " + newTime);
                
                // Update the alarm time
                alarm.setTime(newTime);
                alarm.setStatus("active"); // Ensure it's still active
                
                boolean success = alarm.updateAlarm(db);
                
                if (success) {
                    System.out.println("Alarm snoozed successfully");
                    response.getWriter().write("success: Alarm snoozed for " + minutes + " minutes");
                } else {
                    String errorMsg = "error: Failed to update alarm";
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
            String errorMsg = "error: Invalid number format - alarmId: '" + alarmIdStr + "', minutes: '" + minutesStr + "'";
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
        return "Snooze Alarm servlet - delays alarm by specified minutes";
    }
}
