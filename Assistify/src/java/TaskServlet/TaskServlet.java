package TaskServlet;

import config.DB;
import model.Task;
import model.ToDoItem;
import model.Activity;
import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "TaskServlet", urlPatterns = {"/TaskServlet"})
public class TaskServlet extends HttpServlet {

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
            // Get both ToDoItems and Activities
            List<ToDoItem> todoItems = ToDoItem.getAllToDoItems(db, userId);
            List<Activity> activities = Activity.getAllActivities(db, userId);
            
            request.setAttribute("todoItems", todoItems);
            request.setAttribute("activities", activities);
            
            // Forward to HomeServlet with the appropriate page parameter
            RequestDispatcher dispatcher = request.getRequestDispatcher("HomeServlet?page=task");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Error loading tasks: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("HomeServlet?page=task");
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
        return "Task management servlet";
    }
}
