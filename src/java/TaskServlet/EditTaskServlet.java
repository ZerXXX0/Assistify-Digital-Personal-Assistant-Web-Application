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

@WebServlet(name = "EditTaskServlet", urlPatterns = {"/EditTaskServlet"})
public class EditTaskServlet extends HttpServlet {

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
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String dueDateStr = request.getParameter("dueDate"); // untuk todoitem
        String startTimeStr = request.getParameter("startTime"); // untuk activity
        String endTimeStr = request.getParameter("endTime");
        String priorityStr = request.getParameter("priority");
        String completedStr = request.getParameter("completed");
        
        if (idStr == null || type == null || title == null || title.trim().isEmpty()) {
            response.sendRedirect("TaskServlet?error=Invalid parameters");
            return;
        }
        
        DB db = new DB();
        db.connect();
        
        try {
            int id = Integer.parseInt(idStr);
            boolean success = false;
            
            if ("activity".equals(type)) {
                // Activity editing - tetap menggunakan startTime
                Activity activity = Activity.getActivityById(id, db);
                if (activity == null) {
                    response.sendRedirect("TaskServlet?error=Activity not found");
                    return;
                }
                
                activity.setTitle(title);
                activity.setDescription(description);
                
                if (startTimeStr != null && !startTimeStr.isEmpty()) {
                    LocalDateTime startDateTime = LocalDateTime.parse(startTimeStr, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
                    activity.setStartTime(Timestamp.valueOf(startDateTime));
                }
                
                if (endTimeStr != null && !endTimeStr.isEmpty()) {
                    LocalDateTime endDateTime = LocalDateTime.parse(endTimeStr, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
                    activity.setEndTime(Timestamp.valueOf(endDateTime));
                }
                
                success = activity.updateTask(db);
                
            } else {
                // ToDoItem editing - menggunakan dueDate
                ToDoItem todoItem = ToDoItem.getToDoItemById(id, db);
                if (todoItem == null) {
                    response.sendRedirect("TaskServlet?error=Todo item not found");
                    return;
                }
                
                todoItem.setTitle(title);
                
                if (dueDateStr != null && !dueDateStr.isEmpty()) {
                    LocalDateTime dueDatetime = LocalDateTime.parse(dueDateStr, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
                    todoItem.setDueDate(Timestamp.valueOf(dueDatetime));
                }
                
                if (priorityStr != null && !priorityStr.isEmpty()) {
                    todoItem.setPriority(Integer.parseInt(priorityStr));
                }
                
                if (completedStr != null) {
                    todoItem.setCompleted(Boolean.parseBoolean(completedStr));
                }
                
                success = todoItem.updateTask(db);
            }
            
            if (success) {
                response.sendRedirect("TaskServlet?success=Task updated successfully");
            } else {
                response.sendRedirect("TaskServlet?error=Failed to update task");
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
        return "Edit Task servlet";
    }
}
