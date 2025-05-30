/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package HomeServlet;

import config.DB;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
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
        
        String page = request.getParameter("page");
        if (page == null) page = "home";
        
        DB db = new DB();
        db.connect();
        
        try {
            switch (page) {
                case "home":
                    loadDashboardData(request, db);
                    request.setAttribute("content", "home");
                    break;
                case "alarm":
                    loadAlarmData(request, db);
                    request.setAttribute("content", "alarm");
                    break;
                case "reminder":
                    loadReminderData(request, db);
                    request.setAttribute("content", "reminder");
                    break;
                case "calendar":
                    loadCalendarData(request, db);
                    request.setAttribute("content", "calendar");
                    break;
                case "todolist":
                    loadTaskData(request, db);
                    request.setAttribute("content", "todolist");
                    break;
                case "note":
                    loadNoteData(request, db);
                    request.setAttribute("content", "note");
                    break;
                default:
                    loadDashboardData(request, db);
                    request.setAttribute("content", "home");
                    break;
            }
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("home_page.jsp");
            dispatcher.forward(request, response);
            
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("home_page.jsp");
            dispatcher.forward(request, response);
        } finally {
            db.disconnect();
        }
    }
    
    private void loadDashboardData(HttpServletRequest request, DB db) throws SQLException {
        // Load today's tasks
        String taskQuery = "SELECT title, startTime, endTime, priority FROM task " +
                          "WHERE DATE(startTime) = CURDATE() " +
                          "ORDER BY priority DESC, startTime ASC LIMIT 5";
        ResultSet todayTasks = db.getDataS(taskQuery);
        request.setAttribute("todayTasks", todayTasks);
        
        // Load today's alarms
        String alarmQuery = "SELECT time, status FROM alarm " +
                           "WHERE DATE(time) = CURDATE() AND status = 'active' " +
                           "ORDER BY time ASC";
        ResultSet todayAlarms = db.getDataS(alarmQuery);
        request.setAttribute("todayAlarms", todayAlarms);
        
        // Load today's reminders
        String reminderQuery = "SELECT r.message, r.time, t.title as task_title FROM reminder r " +
                              "LEFT JOIN task t ON r.idtask = t.idtask " +
                              "WHERE DATE(r.time) = CURDATE() " +
                              "ORDER BY r.time ASC";
        ResultSet todayReminders = db.getDataS(reminderQuery);
        request.setAttribute("todayReminders", todayReminders);
        
        // Load recent notes
        String noteQuery = "SELECT title, textNote, voiceNote, createdDate FROM note " +
                          "ORDER BY createdDate DESC LIMIT 3";
        ResultSet recentNotes = db.getDataS(noteQuery);
        request.setAttribute("recentNotes", recentNotes);
    }
    
    private void loadAlarmData(HttpServletRequest request, DB db) throws SQLException {
        String query = "SELECT * FROM alarm ORDER BY time ASC";
        ResultSet rs = db.getDataS(query);
        request.setAttribute("alarmList", rs);
    }
    
    private void loadReminderData(HttpServletRequest request, DB db) throws SQLException {
        String query = "SELECT r.*, t.title as task_title FROM reminder r " +
                      "LEFT JOIN task t ON r.idtask = t.idtask " +
                      "WHERE r.time >= NOW() ORDER BY r.time ASC";
        ResultSet rs = db.getDataS(query);
        request.setAttribute("reminderList", rs);
        
        // Also get list of tasks for the dropdown
        String taskQuery = "SELECT idtask, title FROM task ORDER BY title";
        ResultSet taskRs = db.getDataS(taskQuery);
        request.setAttribute("taskList", taskRs);
    }
    
    private void loadCalendarData(HttpServletRequest request, DB db) throws SQLException {
        String query = "SELECT * FROM task WHERE startTime >= NOW() ORDER BY startTime ASC";
        ResultSet rs = db.getDataS(query);
        request.setAttribute("taskList", rs);
    }
    
    private void loadTaskData(HttpServletRequest request, DB db) throws SQLException {
        String query = "SELECT * FROM task ORDER BY startTime ASC";
        ResultSet rs = db.getDataS(query);
        request.setAttribute("taskList", rs);
    }
    
    private void loadNoteData(HttpServletRequest request, DB db) throws SQLException {
        String query = "SELECT * FROM note ORDER BY createdDate DESC";
        ResultSet rs = db.getDataS(query);
        request.setAttribute("noteList", rs);
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
