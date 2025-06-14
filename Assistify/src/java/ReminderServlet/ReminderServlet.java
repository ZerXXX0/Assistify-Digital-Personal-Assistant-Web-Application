package ReminderServlet;

import config.DB;
import model.Reminder;
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

@WebServlet(name = "ReminderServlet", urlPatterns = {"/ReminderServlet"})
public class ReminderServlet extends HttpServlet {

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
            // Get reminders for this user
            List<Reminder> reminderList = Reminder.getRemindersByUser(db, userId);
            System.out.println("Loaded " + reminderList.size() + " reminders");
            
            // Get todoitems and activities for linking - using correct method names
            List<ToDoItem> todoItemList = ToDoItem.getAllToDoItems(db, userId);
            System.out.println("Loaded " + todoItemList.size() + " todo items");
            
            // Debug output for todoitems
            for (ToDoItem item : todoItemList) {
                System.out.println("TodoItem: ID=" + item.getId() + ", Title=" + item.getTitle());
            }
            
            List<Activity> activityList = Activity.getAllActivities(db, userId);
            System.out.println("Loaded " + activityList.size() + " activities");
            
            // Debug output for reminders
            for (Reminder reminder : reminderList) {
                System.out.println("Reminder: ID=" + reminder.getId() + ", Type=" + reminder.getType() + 
                                  ", TaskID=" + reminder.getIdtask() + ", Message=" + reminder.getMessage());
            }
            
            request.setAttribute("reminderList", reminderList);
            request.setAttribute("todoItemList", todoItemList);
            request.setAttribute("activityList", activityList);
            
            // Forward to HomeServlet with the appropriate page parameter
            RequestDispatcher dispatcher = request.getRequestDispatcher("HomeServlet?page=reminder");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading reminders: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("HomeServlet?page=reminder");
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
        return "Reminder management servlet";
    }
}
