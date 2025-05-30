/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package RegistationServlet;

import config.DB;
import model.User;
import java.io.IOException;
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
        
        // Validation
        if (username == null || password == null || confirmPassword == null || 
            username.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required");
            RequestDispatcher dispatcher = request.getRequestDispatcher("registration_page.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            RequestDispatcher dispatcher = request.getRequestDispatcher("registration_page.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        if (password.length() > 25) {
            request.setAttribute("error", "Password must be 25 characters or less");
            RequestDispatcher dispatcher = request.getRequestDispatcher("registration_page.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        if (username.length() > 25) {
            request.setAttribute("error", "Username must be 25 characters or less");
            RequestDispatcher dispatcher = request.getRequestDispatcher("registration_page.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        DB db = new DB();
        
        try {
            // Check if username already exists
            if (User.usernameExists(username, db)) {
                request.setAttribute("error", "Username already exists");
                RequestDispatcher dispatcher = request.getRequestDispatcher("registration_page.jsp");
                dispatcher.forward(request, response);
                return;
            }
            
            // Create new user
            User newUser = new User(username, password, email != null ? email : "");
            
            if (newUser.saveToDatabase(db)) {
                // Registration successful
                request.setAttribute("success", "Registration successful! Please login.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("login_page.jsp");
                dispatcher.forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("registration_page.jsp");
                dispatcher.forward(request, response);
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Database connection error: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("registration_page.jsp");
            dispatcher.forward(request, response);
        } finally {
            db.disconnect();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("registration_page.jsp");
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
