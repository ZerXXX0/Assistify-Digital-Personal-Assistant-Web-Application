package TaskServlet;

import config.DB;
import model.ToDoItem;
import model.Activity;
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

@WebServlet(name = "AddTaskServlet", urlPatterns = {"/AddTaskServlet"})
public class AddTaskServlet extends HttpServlet {

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
        String description = request.getParameter("description");
        String dueDateStr = request.getParameter("dueDate");
        String startTimeStr = request.getParameter("startTime");
        String endTimeStr = request.getParameter("endTime");
        String priorityStr = request.getParameter("priority");
        String type = request.getParameter("type"); // "todoitem" or "activity"
        
        if (title == null || title.trim().isEmpty()) {
            response.sendRedirect("add.jsp?error=Title is required");
            return;
        }
        
        DB db = new DB();
        db.connect();
        
        try {
            Timestamp startTime = null;
            
            int priority = 5; // default priority
            if (priorityStr != null && !priorityStr.isEmpty()) {
                priority = Integer.parseInt(priorityStr);
            }
            
            boolean success = false;
            
            if ("activity".equals(type)) {
                
                if (startTimeStr != null && !startTimeStr.isEmpty()) {
                    LocalDateTime startDateTime = LocalDateTime.parse(startTimeStr, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
                    startTime = Timestamp.valueOf(startDateTime);
                }
                
                Timestamp endTime = null;
                if (endTimeStr != null && !endTimeStr.isEmpty()) {
                    LocalDateTime endDateTime = LocalDateTime.parse(endTimeStr, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
                    endTime = Timestamp.valueOf(endDateTime);
                }
                
                Activity activity = new Activity(title, description, startTime, endTime);
                activity.setUserId(userId);
                success = activity.saveToDatabase(db);
                
            } else {
                // Create ToDoItem - menggunakan dueDate
                if (dueDateStr == null || dueDateStr.isEmpty()) {
                    response.sendRedirect("add.jsp?error=Due date is required for todo items");
                    return;
                }
                
                Timestamp dueDate = null;
                if (dueDateStr != null && !dueDateStr.isEmpty()) {
                    LocalDateTime dueDatetime = LocalDateTime.parse(dueDateStr, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
                    dueDate = Timestamp.valueOf(dueDatetime);
                }
                
                ToDoItem todoItem = new ToDoItem(title, dueDate, priority);
                todoItem.setUserId(userId);
                success = todoItem.saveToDatabase(db);
            }
            
            if (success) {
                response.sendRedirect("TaskServlet?success=Task added successfully");
            } else {
                response.sendRedirect("add.jsp?error=Failed to add task");
            }
            
        } catch (Exception e) {
            response.sendRedirect("add.jsp?error=Error adding task: " + e.getMessage());
        } finally {
            db.disconnect();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("add.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Add Task servlet";
    }
}
