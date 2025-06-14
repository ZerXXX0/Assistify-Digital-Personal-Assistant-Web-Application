package AlarmServlet;

import config.DB;
import model.Alarm;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "DeleteAlarmServlet", urlPatterns = {"/DeleteAlarmServlet"})
public class DeleteAlarmServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login_page.jsp");
            return;
        }
        
        String idStr = request.getParameter("id");
        
        if (idStr == null) {
            response.sendRedirect("AlarmServlet?error=Invalid alarm ID");
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
                response.sendRedirect("AlarmServlet?error=You don't have permission to delete this alarm");
                return;
            }
            
            boolean success = alarm.deleteAlarm(db);
            
            if (success) {
                response.sendRedirect("AlarmServlet?success=Alarm deleted successfully");
            } else {
                response.sendRedirect("AlarmServlet?error=Failed to delete alarm");
            }
            
        } catch (Exception e) {
            response.sendRedirect("AlarmServlet?error=Error deleting alarm: " + e.getMessage());
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
        return "Delete Alarm servlet";
    }
}
