/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package ActivityServlet;

import config.DB;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ActivityServlet", urlPatterns = {"/ActivityServlet"})
public class ActivityServlet extends HttpServlet {
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setAttribute("content", "calendar");
        DB db = new DB();
        
        db.connect();
        if (db.isConnected()) {
            ResultSet rs = db.getDataS("SELECT * FROM task ORDER BY startTime ASC");
            request.setAttribute("activityList", rs);
            RequestDispatcher dispatcher = request.getRequestDispatcher("home_page.jsp");
            dispatcher.forward(request, response);
        } else {
            try (PrintWriter out = response.getWriter()) {
                out.println("<h1>Error Koneksi Database</h1>");
                out.println("<p>" + db.getMessage() + "</p>");
            }
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
        return "Servlet untuk menampilkan data aktivitas";
    }
}
