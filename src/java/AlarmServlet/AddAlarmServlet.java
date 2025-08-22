package AlarmServlet;

import config.DB;
import model.Alarm;
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

@WebServlet(name = "AddAlarmServlet", urlPatterns = {"/AddAlarmServlet"})
public class AddAlarmServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login_page.jsp");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        
        String title = request.getParameter("title");
        String timeStr = request.getParameter("time");
        
        if (title == null || timeStr == null || title.trim().isEmpty() || timeStr.trim().isEmpty()) {
            response.sendRedirect("AlarmServlet?error=Title and time are required");
            return;
        }
        
        DB db = new DB();
        db.connect();
        
        try {
            LocalDateTime time = LocalDateTime.parse(timeStr, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
            Alarm alarm = new Alarm(title.trim(), Timestamp.valueOf(time), "active", userId);
            
            boolean success = alarm.saveToDatabase(db);
            
            if (success) {
                response.sendRedirect("AlarmServlet?success=Alarm added successfully");
            } else {
                response.sendRedirect("AlarmServlet?error=Failed to add alarm");
            }
            
        } catch (Exception e) {
            response.sendRedirect("AlarmServlet?error=Error adding alarm: " + e.getMessage());
        } finally {
            db.disconnect();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("add.jsp?type=alarm");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Add Alarm servlet";
    }
}
