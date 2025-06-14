package AlarmServlet;

import config.DB;
import model.Alarm;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "EditAlarmServlet", urlPatterns = {"/EditAlarmServlet"})
public class EditAlarmServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login_page.jsp");
            return;
        }
        
        String idStr = request.getParameter("id");
        String title = request.getParameter("title");
        String timeStr = request.getParameter("time");
        String status = request.getParameter("status");
        
        if (idStr == null || title == null || timeStr == null || title.trim().isEmpty() || timeStr.trim().isEmpty()) {
            response.sendRedirect("AlarmServlet?error=Invalid parameters");
            return;
        }
        
        DB db = new DB();
        db.connect();
        
        try {
            int id = Integer.parseInt(idStr);
            Alarm alarm = Alarm.getAlarmById(id, db);
            
            if (alarm == null) {
                response.sendRedirect("AlarmServlet?error=Alarm not found");
                return;
            }
            
            // Check if this alarm belongs to the current user
            if (alarm.getUserId() != (Integer) session.getAttribute("userId")) {
                response.sendRedirect("AlarmServlet?error=You don't have permission to edit this alarm");
                return;
            }
            
            LocalDateTime time = LocalDateTime.parse(timeStr, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
            alarm.setTitle(title.trim());
            alarm.setTime(time);
            alarm.setStatus(status != null ? status : "active");
            
            boolean success = alarm.updateAlarm(db);
            
            if (success) {
                response.sendRedirect("AlarmServlet?success=Alarm updated successfully");
            } else {
                response.sendRedirect("AlarmServlet?error=Failed to update alarm");
            }
            
        } catch (Exception e) {
            response.sendRedirect("AlarmServlet?error=Error updating alarm: " + e.getMessage());
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
        return "Edit Alarm servlet";
    }
}
