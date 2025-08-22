package AlarmServlet;

import config.DB;
import model.Alarm;
import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AlarmServlet", urlPatterns = {"/AlarmServlet"})
public class AlarmServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login_page.jsp");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        
        DB db = new DB();
        db.connect();
        
        try {
            List<Alarm> alarmList = Alarm.getAlarmsByUser(db, userId);
            request.setAttribute("alarmList", alarmList);
            
            // Check for success or error messages
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            
            if (success != null) {
                request.setAttribute("success", success);
            }
            
            if (error != null) {
                request.setAttribute("error", error);
            }
            
            // Forward to HomeServlet with the appropriate page parameter
            RequestDispatcher dispatcher = request.getRequestDispatcher("HomeServlet?page=alarm");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Error loading alarms: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("HomeServlet?page=alarm");
            dispatcher.forward(request, response);
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
        return "Alarm management servlet";
    }
}
