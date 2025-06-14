package HomeServlet;

import config.DB;
import model.*;
import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "HomeServlet", urlPatterns = {"/HomeServlet"})
public class HomeServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login_page.jsp");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        String page = request.getParameter("page");
        if (page == null) page = "home";
        
        DB db = new DB();
        db.connect();
        
        try {
            switch (page) {
                case "home":
                    loadDashboardData(request, db, userId);
                    request.setAttribute("content", "home");
                    break;
                case "alarm":
                    loadAlarmData(request, db, userId);
                    request.setAttribute("content", "alarm");
                    break;
                case "reminder":
                    loadReminderData(request, db, userId);
                    request.setAttribute("content", "reminder");
                    break;
                case "task":
                    loadTaskData(request, db, userId);
                    request.setAttribute("content", "task");
                    break;
                case "note":
                    loadNoteData(request, db, userId);
                    request.setAttribute("content", "note");
                    break;
                case "journal":
                    loadJournalData(request, db, userId);
                    request.setAttribute("content", "journal");
                    break;
                case "settings":
                    request.setAttribute("content", "settings");
                    break;
                case "edit_profile":
                    request.setAttribute("content", "edit_profile");
                    break;
                default:
                    loadDashboardData(request, db, userId);
                    request.setAttribute("content", "home");
                    break;
            }
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("home_page.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("home_page.jsp");
            dispatcher.forward(request, response);
        } finally {
            db.disconnect();
        }
    }
    
    private void loadDashboardData(HttpServletRequest request, DB db, int userId) {
        try {
            // Load recent tasks
            List<ToDoItem> recentTodos = ToDoItem.getAllToDoItems(db, userId);
            List<Activity> recentActivities = Activity.getAllActivities(db, userId);
            
            // Load recent alarms
            List<Alarm> recentAlarms = Alarm.getAlarmsByUser(db, userId);
            
            // Load recent reminders (limit to 5 most recent)
            List<Reminder> recentReminders = Reminder.getRemindersByUser(db, userId, 5);
            
            // Load recent notes
            List<TextNote> recentTextNotes = TextNote.getAllTextNotes(db, userId);
            List<VoiceNote> recentVoiceNotes = VoiceNote.getAllVoiceNotes(db, userId);
            
            // Load recent journal entries (limit to 5 most recent)
            List<JournalEntry> recentJournals = JournalEntry.getRecentEntriesByUser(db, userId, 5);
            
            // Load active reminders for notifications (reminders for today and tomorrow)
            List<Reminder> activeReminders = Reminder.getActiveReminders(db, userId);
            
            System.out.println("Dashboard - Loading data for user: " + userId);
            System.out.println("Recent reminders: " + recentReminders.size());
            System.out.println("Active reminders: " + activeReminders.size());
            
            request.setAttribute("recentTodos", recentTodos);
            request.setAttribute("recentActivities", recentActivities);
            request.setAttribute("recentAlarms", recentAlarms);
            request.setAttribute("recentReminders", recentReminders);
            request.setAttribute("recentTextNotes", recentTextNotes);
            request.setAttribute("recentVoiceNotes", recentVoiceNotes);
            request.setAttribute("recentJournals", recentJournals);
            request.setAttribute("activeReminders", activeReminders);
            
        } catch (Exception e) {
            System.err.println("Error loading dashboard data: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void loadAlarmData(HttpServletRequest request, DB db, int userId) {
        try {
            List<Alarm> alarmList = Alarm.getAlarmsByUser(db, userId);
            
            System.out.println("Loading alarms for user: " + userId);
            System.out.println("Alarms found: " + alarmList.size());
            
            request.setAttribute("alarmList", alarmList);
            
        } catch (Exception e) {
            System.err.println("Error loading alarm data: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void loadReminderData(HttpServletRequest request, DB db, int userId) {
        try {
            // Get all reminders for the user
            List<Reminder> reminderList = Reminder.getRemindersByUser(db, userId);
            
            // Get all tasks (ToDoItems and Activities) for dropdown in add/edit forms
            List<ToDoItem> todoList = ToDoItem.getAllToDoItems(db, userId);
            List<Activity> activityList = Activity.getAllActivities(db, userId);
            
            System.out.println("Loading reminders for user: " + userId);
            System.out.println("Reminders found: " + reminderList.size());
            System.out.println("ToDoItems available: " + todoList.size());
            System.out.println("Activities available: " + activityList.size());
            
            request.setAttribute("reminderList", reminderList);
            request.setAttribute("todoList", todoList);
            request.setAttribute("activityList", activityList);
            
        } catch (Exception e) {
            System.err.println("Error loading reminder data: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void loadTaskData(HttpServletRequest request, DB db, int userId) {
        try {
            List<ToDoItem> todoList = ToDoItem.getAllToDoItems(db, userId);
            List<Activity> activityList = Activity.getAllActivities(db, userId);
            
            System.out.println("Loading tasks for user: " + userId);
            System.out.println("ToDoItems found: " + todoList.size());
            System.out.println("Activities found: " + activityList.size());
            
            request.setAttribute("todoList", todoList);
            request.setAttribute("activityList", activityList);
            
        } catch (Exception e) {
            System.err.println("Error loading task data: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void loadNoteData(HttpServletRequest request, DB db, int userId) {
        try {
            // Get text notes and voice notes separately
            List<TextNote> textNotes = TextNote.getAllTextNotes(db, userId);
            List<VoiceNote> voiceNotes = VoiceNote.getAllVoiceNotes(db, userId);
            
            System.out.println("Loading notes for user: " + userId);
            System.out.println("Text notes found: " + textNotes.size());
            System.out.println("Voice notes found: " + voiceNotes.size());
            
            request.setAttribute("textNotes", textNotes);
            request.setAttribute("voiceNotes", voiceNotes);
            
        } catch (Exception e) {
            System.err.println("Error loading note data: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void loadJournalData(HttpServletRequest request, DB db, int userId) {
        try {
            List<JournalEntry> journalList = JournalEntry.getEntriesByUser(db, userId);
            
            System.out.println("Loading journal entries for user: " + userId);
            System.out.println("Journal entries found: " + journalList.size());
            
            request.setAttribute("journalList", journalList);
            
        } catch (Exception e) {
            System.err.println("Error loading journal data: " + e.getMessage());
            e.printStackTrace();
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
        return "Home page navigation servlet";
    }
}
