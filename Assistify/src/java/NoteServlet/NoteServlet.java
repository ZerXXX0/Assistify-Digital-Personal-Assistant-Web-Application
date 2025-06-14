package NoteServlet;

import config.DB;
import model.TextNote;
import model.VoiceNote;
import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "NoteServlet", urlPatterns = {"/NoteServlet"})
public class NoteServlet extends HttpServlet {

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
    
        try {
            db.connect();
            
            // Get text notes
            List<TextNote> textNotes = TextNote.getAllTextNotes(db, userId);
            
            // Get voice notes
            List<VoiceNote> voiceNotes = VoiceNote.getAllVoiceNotes(db, userId);
            
            System.out.println("Text notes found: " + textNotes.size());
            System.out.println("Voice notes found: " + voiceNotes.size());
            
            // Set attributes for the request
            request.setAttribute("textNotes", textNotes);
            request.setAttribute("voiceNotes", voiceNotes);
        
            // Forward to HomeServlet with the appropriate page parameter
            RequestDispatcher dispatcher = request.getRequestDispatcher("HomeServlet?page=note");
            dispatcher.forward(request, response);
        
        } catch (Exception e) {
            System.err.println("Error in NoteServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error loading notes: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("HomeServlet?page=note");
            dispatcher.forward(request, response);
        } finally {
            if (db != null) {
                db.disconnect();
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
        return "Note management servlet";
    }
}
