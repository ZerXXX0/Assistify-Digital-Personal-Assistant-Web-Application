package RegistrationServlet;

import config.DB;
import model.User;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "RegistrationServlet", urlPatterns = {"/register"})
public class RegistrationServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm-password");
        String email = request.getParameter("email");
        
        // Enhanced validation
        if (username == null || password == null || confirmPassword == null || email == null ||
            username.trim().isEmpty() || password.trim().isEmpty() || email.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            RequestDispatcher dispatcher = request.getRequestDispatcher("registration_page.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        // Trim inputs
        username = username.trim();
        password = password.trim();
        confirmPassword = confirmPassword.trim();
        email = email.trim();
        
        // Password validation
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            RequestDispatcher dispatcher = request.getRequestDispatcher("registration_page.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        // Length validation
        if (password.length() > 25) {
            request.setAttribute("error", "Password must be 25 characters or less");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            RequestDispatcher dispatcher = request.getRequestDispatcher("registration_page.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        if (username.length() > 25) {
            request.setAttribute("error", "Username must be 25 characters or less");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            RequestDispatcher dispatcher = request.getRequestDispatcher("registration_page.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        if (email.length() > 100) {
            request.setAttribute("error", "Email must be 100 characters or less");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            RequestDispatcher dispatcher = request.getRequestDispatcher("registration_page.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        // Password strength validation
        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters long");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            RequestDispatcher dispatcher = request.getRequestDispatcher("registration_page.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        // Basic email format validation
        if (!email.contains("@") || !email.contains(".")) {
            request.setAttribute("error", "Please enter a valid email address");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            RequestDispatcher dispatcher = request.getRequestDispatcher("registration_page.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        DB db = new DB();
        
        try {
            db.connect();
            
            // Check if username already exists
            if (User.usernameExists(username, db)) {
                request.setAttribute("error", "Username already exists. Please choose a different username.");
                request.setAttribute("username", ""); // Clear username field
                request.setAttribute("email", email);
                RequestDispatcher dispatcher = request.getRequestDispatcher("registration_page.jsp");
                dispatcher.forward(request, response);
                return;
            }
            
            // Create new user
            User newUser = new User(username, password, email);
            
            if (newUser.saveToDatabase(db)) {
                // Get the user ID of the newly created user
                int userId = User.getIdByUsername(username, db);
                
                // Insert default notification settings for the new user
                if (userId > 0) {
                    insertDefaultNotificationSettings(userId, db);
                }
                
                // Registration successful - redirect to login page with success message
                response.sendRedirect("login_page.jsp?success=Registration successful! Please login with your credentials.");
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                request.setAttribute("username", username);
                request.setAttribute("email", email);
                RequestDispatcher dispatcher = request.getRequestDispatcher("registration_page.jsp");
                dispatcher.forward(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("Registration error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "System error occurred. Please try again later.");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            RequestDispatcher dispatcher = request.getRequestDispatcher("registration_page.jsp");
            dispatcher.forward(request, response);
        } finally {
            db.disconnect();
        }
    }
    
    private void insertDefaultNotificationSettings(int userId, DB db) {
        String sql = "INSERT INTO notification_settings (user_id, alarm_sound, reminder_sound) VALUES (" + userId + ", 1, 1)";
        db.runQuery(sql);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to registration page for GET requests
        RequestDispatcher dispatcher = request.getRequestDispatcher("registration_page.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Registration Servlet for new user registration";
    }
}
