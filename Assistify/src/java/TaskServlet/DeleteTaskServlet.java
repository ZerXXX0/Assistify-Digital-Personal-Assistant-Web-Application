package TaskServlet;

import config.DB;
import model.ToDoItem;
import model.Activity;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "DeleteTaskServlet", urlPatterns = {"/DeleteTaskServlet"})
public class DeleteTaskServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login_page.jsp");
            return;
        }
        
        String idStr = request.getParameter("id");
        String type = request.getParameter("type");
        
        if (idStr == null || type == null) {
            response.sendRedirect("TaskServlet?error=Invalid parameters");
            return;
        }
        
        DB db = new DB();
        db.connect();
        
        try {
            int id = Integer.parseInt(idStr);
            boolean success = false;
            
            if ("activity".equals(type)) {
                Activity activity = Activity.getActivityById(id, db);
                if (activity != null) {
                    success = activity.deleteTask(db);
                }
            } else {
                ToDoItem todoItem = ToDoItem.getToDoItemById(id, db);
                if (todoItem != null) {
                    success = todoItem.deleteTask(db);
                }
            }
            
            if (success) {
                response.sendRedirect("TaskServlet?success=Task deleted successfully");
            } else {
                response.sendRedirect("TaskServlet?error=Failed to delete task");
            }
            
        } catch (Exception e) {
            response.sendRedirect("TaskServlet?error=Error deleting task: " + e.getMessage());
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
        return "Delete Task servlet";
    }
}
