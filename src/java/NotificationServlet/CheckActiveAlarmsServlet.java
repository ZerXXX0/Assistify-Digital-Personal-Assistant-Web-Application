package servlet;

import config.DB;
import model.Alarm;
import java.io.IOException;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "CheckActiveAlarmsServlet", urlPatterns = {"/CheckActiveAlarmsServlet"})
public class CheckActiveAlarmsServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        String userId = request.getParameter("userId");
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        
        List<Alarm> activeAlarms = new ArrayList<>();
        
        if (userId != null && date != null && time != null) {
            DB db = new DB();
            db.connect();
            
            try {
                // Query for alarms that should be active now
                String query = "SELECT * FROM alarm WHERE user_id = " + userId + 
                             " AND DATE(time) = '" + date + "'" +
                             " AND TIME(time) = '" + time + ":00'" +
                             " AND status = 'active'";
                
                ResultSet rs = db.getData(query);
                
                while (rs != null && rs.next()) {
                    Alarm alarm = new Alarm();
                    alarm.setId(rs.getInt("id"));
                    alarm.setTitle(rs.getString("title"));
                    alarm.setTime(rs.getTimestamp("time"));
                    alarm.setStatus(rs.getString("status"));
                    alarm.setUserId(rs.getInt("user_id"));
                    activeAlarms.add(alarm);
                }
                
            } catch (Exception e) {
                System.err.println("Error checking active alarms: " + e.getMessage());
            } finally {
                db.disconnect();
            }
        }
        
        // Manual JSON building
        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.append("[");
        
        for (int i = 0; i < activeAlarms.size(); i++) {
            Alarm alarm = activeAlarms.get(i);
            jsonBuilder.append("{");
            jsonBuilder.append("\"id\":").append(alarm.getId()).append(",");
            jsonBuilder.append("\"title\":\"").append(escapeJson(alarm.getTitle())).append("\",");
            jsonBuilder.append("\"time\":\"").append(alarm.getTime().toString()).append("\",");
            jsonBuilder.append("\"status\":\"").append(escapeJson(alarm.getStatus())).append("\",");
            jsonBuilder.append("\"userId\":").append(alarm.getUserId());
            jsonBuilder.append("}");
            
            if (i < activeAlarms.size() - 1) {
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
