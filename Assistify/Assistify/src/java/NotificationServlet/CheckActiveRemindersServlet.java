package servlet;

import config.DB;
import model.Reminder;
import java.io.IOException;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "CheckActiveRemindersServlet", urlPatterns = {"/CheckActiveRemindersServlet"})
public class CheckActiveRemindersServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        String userId = request.getParameter("userId");
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        
        List<Reminder> activeReminders = new ArrayList<>();
        
        if (userId != null && date != null && time != null) {
            DB db = new DB();
            db.connect();
            
            try {
                // Query for reminders that should be active now
                String query = "SELECT * FROM reminder WHERE user_id = " + userId +
                                " AND DATE(time) = '" + date + "'" +
                                " AND TIME(time) = '" + time + ":00'" +
                                " AND message NOT LIKE '%[SHOWN]%'";
                
                ResultSet rs = db.getData(query);
                
                while (rs != null && rs.next()) {
                    Reminder reminder = new Reminder();
                    reminder.setId(rs.getInt("id"));
                    reminder.setTime(rs.getTimestamp("time"));
                    reminder.setMessage(rs.getString("message"));
                    reminder.setIdtask(rs.getObject("idtask") != null ? rs.getInt("idtask") : 0);
                    reminder.setType(rs.getString("type"));
                    reminder.setUserId(rs.getInt("user_id"));
                    activeReminders.add(reminder);
                }
                
            } catch (Exception e) {
                System.err.println("Error checking active reminders: " + e.getMessage());
            } finally {
                db.disconnect();
            }
        }
        
        // Manual JSON building
        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.append("[");
        
        for (int i = 0; i < activeReminders.size(); i++) {
            Reminder reminder = activeReminders.get(i);
            jsonBuilder.append("{");
            jsonBuilder.append("\"id\":").append(reminder.getId()).append(",");
            jsonBuilder.append("\"time\":\"").append(reminder.getTime().toString()).append("\",");
            jsonBuilder.append("\"message\":\"").append(escapeJson(reminder.getMessage())).append("\",");
            jsonBuilder.append("\"idtask\":").append(reminder.getIdtask()).append(",");
            jsonBuilder.append("\"type\":\"").append(escapeJson(reminder.getType())).append("\",");
            jsonBuilder.append("\"userId\":").append(reminder.getUserId());
            jsonBuilder.append("}");
            
            if (i < activeReminders.size() - 1) {
                jsonBuilder.append(",");
            }
        }
        
        jsonBuilder.append("]");
        
        response.getWriter().write(jsonBuilder.toString());
    }
    
    // Helper method to escape JSON strings
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
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
