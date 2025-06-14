package UserServlet;

import config.DB;
import model.User;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "UserServlet", urlPatterns = {"/UserServlet"})
public class UserServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login_page.jsp");
            return;
        }
        
        try {
            // Get current user info from session
            int userId = (Integer) session.getAttribute("userId");
            String username = (String) session.getAttribute("username");
            String email = (String) session.getAttribute("email");
            
            request.setAttribute("userId", userId);
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            
            // Forward to HomeServlet with the appropriate page parameter
            RequestDispatcher dispatcher = request.getRequestDispatcher("HomeServlet?page=settings");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Error loading user profile: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("HomeServlet?page=settings");
            dispatcher.forward(request, response);
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
        return "User profile management servlet";
    }
}
