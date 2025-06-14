package UserServlet;

import config.DB;
import model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "EditUserServlet", urlPatterns = {"/EditUserServlet"})
public class EditUserServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login_page.jsp");
            return;
        }
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        
        if (username == null || username.trim().isEmpty() || email == null || email.trim().isEmpty()) {
            response.sendRedirect("UserServlet?error=Username and email are required");
            return;
        }
        
        DB db = new DB();
        db.connect();
        
        try {
            int userId = (Integer) session.getAttribute("userId");
            String sessionUsername = (String) session.getAttribute("username");
            
            // Verify current password if user wants to change password
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                if (currentPassword == null || currentPassword.trim().isEmpty()) {
                    response.sendRedirect("UserServlet?error=Current password is required to change password");
                    return;
                }
                
                User authenticatedUser = User.authenticate(sessionUsername, currentPassword, db);
                if (authenticatedUser == null) {
                    response.sendRedirect("UserServlet?error=Current password is incorrect");
                    return;
                }
            }
            
            // Check if new username already exists (if different from current)
            if (!username.equals(sessionUsername) && User.usernameExists(username, db)) {
                response.sendRedirect("UserServlet?error=Username already exists");
                return;
            }
            
            User user = new User(userId, username, "", email);
            
            // Update profile
            boolean profileSuccess = user.updateProfile(db);
            
            // Update password if provided
            boolean passwordSuccess = true;
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                passwordSuccess = user.updatePassword(newPassword, db);
            }
            
            if (profileSuccess && passwordSuccess) {
                // Update session attributes
                session.setAttribute("username", username);
                session.setAttribute("email", email);
                
                response.sendRedirect("UserServlet?success=Profile updated successfully");
            } else {
                response.sendRedirect("UserServlet?error=Failed to update profile");
            }
            
        } catch (Exception e) {
            response.sendRedirect("UserServlet?error=Error updating profile: " + e.getMessage());
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
        return "Edit User Profile servlet";
    }
}
