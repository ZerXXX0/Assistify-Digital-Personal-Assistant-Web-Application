/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;

import config.DB;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Fathan Fardian Sanum
 */
@WebServlet(name = "TestServlet", urlPatterns = {"/TestServlet"})
public class TestServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
protected void processRequest(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    response.setContentType("text/html;charset=UTF-8");
    
    DB db = new DB();
    db.connect();
    try (PrintWriter out = response.getWriter()) {
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<link href='https://fonts.googleapis.com/css?family=Space+Grotesk' rel='stylesheet'>");
        out.println("<title>Tes Servlet JDBC</title>");
        out.println("<style>" +
                    "body { font-family: 'Space Grotesk'; font-size: 22px; margin: 20px; background-color: #f9f9f9; color: #333; }" +
                    "h1 { color: #FF3B65; }" +
                    "h2 { color: #FF3B65; }" +
                    ".container { background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }" +
                    ".message { padding: 10px; margin-bottom:15px; border-radius: 4px; }" +
                    ".success { background-color: #007bff; color: #155724; border: 1px solid #c3e6cb; }" +
                    ".error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }" +
                    "table { width: 100%; border-collapse: collapse; margin-top: 15px; }" +
                    "th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }" +
                    "th { background-color: #FF3B65; color: white; }" +
                    "tr:nth-child(even) { background-color: #f2f2f2; }" +
                    "</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='container'>");
        out.println("<center>");
        out.println("<h1>Pengujian koneksi JDBC pada data mahasiswa</h1>");
        out.println("</center>");
        if (db.isConnected()) {
            out.println("<p class='message success'>Status Koneksi: " + db.getMessage() + "</p>");
            out.println("<center>");
            out.println("<h2>Tabel Data</h2>");
            out.println("<center>");
            // Modify the query to match the database schema from the image
            ResultSet rs = db.getData("SELECT * FROM note");
            if (rs != null) {
                out.println("<table>");
                out.println("<tr><th>ID</th><th>Title</th><th>Text Note</th><th>Voice Note</th><th>Created Date</th></tr>");
                try {
                    if (!rs.isBeforeFirst()) {
                        out.println("<tr><td colspan='5'>Tidak ada data di tabel user.</td></tr>");
                    } else {
                        while (rs.next()) {
                            out.println("<tr>");
                            out.println("<td>" + rs.getInt("id") + "</td>");
                            out.println("<td>" + rs.getString("title") + "</td>");
                            out.println("<td>" + rs.getString("textNote") + "</td>");
                            out.println("<td>" + rs.getString("voiceNote") + "</td>");
                            out.println("<td>" + rs.getString("createdDate") + "</td>");
                            out.println("</tr>");
                        }
                    }
                } catch (SQLException e) {
                    out.println("<tr><td colspan='5' class='message error'>Error saat mengambil data: " + e.getMessage() + "</td></tr>");
                } finally {
                    try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
                out.println("</table>");
            } else {
                out.println("<p class='message error'>Gagal mengambil data: " + db.getMessage() + "</p>");
            }
        } else {
            out.println("<p class='message error'>Status Koneksi: " + db.getMessage() + "</p>");
            out.println("<p class='message error'>Pastikan XAMPP (MySQL) berjalan dan database 'TP13_Praktikan' dengan tabel 'user' sudah dibuat.</p>");
            out.println("<p class='message error'>Periksa juga konfigurasi DB_URL, DB_USER, DB_PASSWORD di kelas JDBC.java.</p>");
            out.println("<p class='message error'>Pastikan file mysql-connector-java.jar sudah ditambahkan ke Libraries proyek.</p>");
        }

        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
    } finally {
        db.disconnect();
    }
}

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
