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

@WebServlet(name = "DeleteUserServlet", urlPatterns = {"/DeleteUserServlet"})
public class DeleteUserServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login_page.jsp");
            return;
        }
        
        String password = request.getParameter("password");
        String confirmDelete = request.getParameter("confirmDelete");
        
        if (password == null || password.trim().isEmpty()) {
            response.sendRedirect("UserServlet?error=Password is required to delete account");
            return;
        }
        
        if (confirmDelete == null || !confirmDelete.equals("DELETE")) {
            response.sendRedirect("UserServlet?error=Please type DELETE to confirm account deletion");
            return;
        }
        
        DB db = new DB();
        db.connect();
        
        try {
            int userId = (Integer) session.getAttribute("userId");
            String username = (String) session.getAttribute("username");
            
            // Verify password before deletion
            User authenticatedUser = User.authenticate(username, password, db);
            if (authenticatedUser == null) {
                response.sendRedirect("UserServlet?error=Incorrect password");
                return;
            }
            
            // Create user object for deletion
            User user = new User();
            user.setId(userId);
            
            // Delete user account
            user.deleteUser(db);
            
            // Invalidate session
            session.invalidate();
            
            response.sendRedirect("login_page.jsp?message=Account deleted successfully");
            
        } catch (Exception e) {
            response.sendRedirect("UserServlet?error=Error deleting account: " + e.getMessage());
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
        return "Delete User Account servlet";
    }
}
