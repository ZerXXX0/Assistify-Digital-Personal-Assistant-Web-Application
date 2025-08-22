package TaskServlet;

import config.DB;
import model.ToDoItem;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ToggleTaskServlet", urlPatterns = {"/ToggleTaskServlet"})
public class ToggleTaskServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login_page.jsp");
            return;
        }
        
        String idStr = request.getParameter("id");
        String completedStr = request.getParameter("completed");
        
        if (idStr == null || completedStr == null) {
            response.sendRedirect("TaskServlet?error=Invalid parameters");
            return;
        }
        
        DB db = new DB();
        db.connect();
        
        try {
            int id = Integer.parseInt(idStr);
            boolean completed = Boolean.parseBoolean(completedStr);
            
            ToDoItem todoItem = ToDoItem.getToDoItemById(id, db);
            if (todoItem != null) {
                todoItem.setCompleted(completed);
                boolean success = todoItem.updateTask(db);
                
                if (success) {
                    response.sendRedirect("TaskServlet?success=Task status updated");
                } else {
                    response.sendRedirect("TaskServlet?error=Failed to update task status");
                }
            } else {
                response.sendRedirect("TaskServlet?error=Task not found");
            }
            
        } catch (Exception e) {
            response.sendRedirect("TaskServlet?error=Error updating task: " + e.getMessage());
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
        return "Toggle Task completion servlet";
    }
}
