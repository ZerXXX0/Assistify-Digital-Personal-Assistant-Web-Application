package NoteServlet;

import config.DB;
import model.TextNote;
import model.VoiceNote;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "DeleteNoteServlet", urlPatterns = {"/DeleteNoteServlet"})
public class DeleteNoteServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login_page.jsp");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        String idStr = request.getParameter("id");
        String noteType = request.getParameter("noteType");
        
        if (idStr == null || noteType == null) {
            response.sendRedirect("NoteServlet?error=Invalid parameters");
            return;
        }
        
        DB db = new DB();
        db.connect();
        
        try {
            int id = Integer.parseInt(idStr);
            boolean success = false;
            
            if ("text".equals(noteType)) {
                // Delete text note
                TextNote textNote = TextNote.getTextNoteById(id, db);
                
                if (textNote == null || textNote.getUserId() != userId) {
                    response.sendRedirect("NoteServlet?error=Note not found or access denied");
                    return;
                }
                
                success = textNote.deleteNote(db);
                
            } else if ("voice".equals(noteType)) {
                // Delete voice note
                VoiceNote voiceNote = VoiceNote.getVoiceNoteById(id, db);
                
                if (voiceNote == null || voiceNote.getUserId() != userId) {
                    response.sendRedirect("NoteServlet?error=Note not found or access denied");
                    return;
                }
                
                success = voiceNote.deleteNote(db);
                
            } else {
                response.sendRedirect("NoteServlet?error=Invalid note type");
                return;
            }
            
            if (success) {
                response.sendRedirect("NoteServlet?success=Note deleted successfully");
            } else {
                response.sendRedirect("NoteServlet?error=Failed to delete note");
            }
            
        } catch (Exception e) {
            response.sendRedirect("NoteServlet?error=Error deleting note: " + e.getMessage());
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
        return "Delete Note servlet";
    }
}
