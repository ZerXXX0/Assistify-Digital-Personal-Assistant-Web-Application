package NotificationServlet;

import config.DB;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "UpdateNotificationSettingsServlet", urlPatterns = {"/UpdateNotificationSettingsServlet"})
public class UpdateNotificationSettingsServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain;charset=UTF-8");
        
        // Debug: Print all parameters
        System.out.println("=== UpdateNotificationSettingsServlet Debug ===");
        System.out.println("Method: " + request.getMethod());
        System.out.println("Content-Type: " + request.getContentType());
        
        // Print all parameter names and values
        java.util.Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            System.out.println("Parameter: " + paramName + " = " + paramValue);
        }
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("Error: Not logged in");
            response.getWriter().write("error: Not logged in");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        System.out.println("User ID: " + userId);
        
        String alarmSoundStr = request.getParameter("alarmSound");
        String notificationSoundStr = request.getParameter("notificationSound");
        
        System.out.println("Received alarmSound: " + alarmSoundStr);
        System.out.println("Received notificationSound: " + notificationSoundStr);
        
        if (alarmSoundStr == null || notificationSoundStr == null) {
            String errorMsg = "error: Missing parameters - alarmSound: " + alarmSoundStr + ", notificationSound: " + notificationSoundStr;
            System.out.println(errorMsg);
            response.getWriter().write(errorMsg);
            return;
        }
        
        // Check if parameters are empty
        if (alarmSoundStr.trim().isEmpty() || notificationSoundStr.trim().isEmpty()) {
            String errorMsg = "error: Empty parameters - alarmSound: '" + alarmSoundStr + "', notificationSound: '" + notificationSoundStr + "'";
            System.out.println(errorMsg);
            response.getWriter().write(errorMsg);
            return;
        }
        
        try {
            int alarmSound = Integer.parseInt(alarmSoundStr.trim());
            int notificationSound = Integer.parseInt(notificationSoundStr.trim());
            
            System.out.println("Parsed alarmSound: " + alarmSound);
            System.out.println("Parsed notificationSound: " + notificationSound);
            
            // Validate sound values (1-4)
            if (alarmSound < 1 || alarmSound > 4 || notificationSound < 1 || notificationSound > 4) {
                String errorMsg = "error: Invalid sound values - alarmSound: " + alarmSound + ", notificationSound: " + notificationSound + " (must be 1-4)";
                System.out.println(errorMsg);
                response.getWriter().write(errorMsg);
                return;
            }
            
            DB db = new DB();
            db.connect();
            
            try {
                // Check if alarm setting exists
                String checkAlarmQuery = "SELECT COUNT(*) as count FROM notification_settings WHERE user_id = " + userId + " AND type = 'Alarm'";
                System.out.println("Checking alarm query: " + checkAlarmQuery);
                
                var alarmRs = db.getData(checkAlarmQuery);
                boolean alarmExists = false;
                if (alarmRs != null && alarmRs.next()) {
                    alarmExists = alarmRs.getInt("count") > 0;
                }
                System.out.println("Alarm setting exists: " + alarmExists);
                
                // Update or insert alarm setting
                String alarmQuery;
                if (alarmExists) {
                    alarmQuery = "UPDATE notification_settings SET sound = " + alarmSound + 
                                " WHERE user_id = " + userId + " AND type = 'Alarm'";
                } else {
                    alarmQuery = "INSERT INTO notification_settings (user_id, type, sound) VALUES (" + 
                                userId + ", 'Alarm', " + alarmSound + ")";
                }
                System.out.println("Alarm query: " + alarmQuery);
                db.runQuery(alarmQuery);
                
                // Check if notification setting exists
                String checkNotifQuery = "SELECT COUNT(*) as count FROM notification_settings WHERE user_id = " + userId + " AND type = 'Notification'";
                System.out.println("Checking notification query: " + checkNotifQuery);
                
                var notifRs = db.getData(checkNotifQuery);
                boolean notifExists = false;
                if (notifRs != null && notifRs.next()) {
                    notifExists = notifRs.getInt("count") > 0;
                }
                System.out.println("Notification setting exists: " + notifExists);
                
                // Update or insert notification setting
                String notifQuery;
                if (notifExists) {
                    notifQuery = "UPDATE notification_settings SET sound = " + notificationSound + 
                                " WHERE user_id = " + userId + " AND type = 'Notification'";
                } else {
                    notifQuery = "INSERT INTO notification_settings (user_id, type, sound) VALUES (" + 
                                userId + ", 'Notification', " + notificationSound + ")";
                }
                System.out.println("Notification query: " + notifQuery);
                db.runQuery(notifQuery);
                
                System.out.println("Settings updated successfully");
                response.getWriter().write("success: Settings updated successfully");
                
            } catch (Exception e) {
                String errorMsg = "error: Database error - " + e.getMessage();
                System.err.println("Database error: " + e.getMessage());
                e.printStackTrace();
                response.getWriter().write(errorMsg);
            } finally {
                db.disconnect();
            }
            
        } catch (NumberFormatException e) {
            String errorMsg = "error: Invalid number format - alarmSound: '" + alarmSoundStr + "', notificationSound: '" + notificationSoundStr + "'";
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
}
