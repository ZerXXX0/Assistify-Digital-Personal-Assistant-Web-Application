package NoteServlet;

import config.DB;
import model.TextNote;
import model.VoiceNote;
import java.io.IOException;
import java.io.File;
import java.nio.file.Paths;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet(name = "EditNoteServlet", urlPatterns = {"/EditNoteServlet"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class EditNoteServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads/voice_notes";

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
        String title = request.getParameter("title");
        String noteType = request.getParameter("noteType");
        
        if (idStr == null || title == null || title.trim().isEmpty() || noteType == null) {
            response.sendRedirect("NoteServlet?error=Invalid parameters");
            return;
        }
        
        DB db = new DB();
        db.connect();
        
        try {
            int id = Integer.parseInt(idStr);
            boolean success = false;
            
            if ("text".equals(noteType)) {
                // Edit text note
                TextNote textNote = TextNote.getTextNoteById(id, db);
                
                if (textNote == null || textNote.getUserId() != userId) {
                    response.sendRedirect("NoteServlet?error=Note not found or access denied");
                    return;
                }
                
                String textContent = request.getParameter("textNote");
                if (textContent == null || textContent.trim().isEmpty()) {
                    response.sendRedirect("NoteServlet?error=Text content is required");
                    return;
                }
                
                textNote.setTitle(title);
                textNote.setTextNote(textContent);
                success = textNote.updateNote(db);
                
            } else if ("voice".equals(noteType)) {
                // Edit voice note
                VoiceNote voiceNote = VoiceNote.getVoiceNoteById(id, db);
                
                if (voiceNote == null || voiceNote.getUserId() != userId) {
                    response.sendRedirect("NoteServlet?error=Note not found or access denied");
                    return;
                }
                
                voiceNote.setTitle(title);
                
                // Check for new voice file
                String newVoiceFile = handleVoiceUpload(request);
                if (newVoiceFile != null) {
                    voiceNote.setVoiceNote(newVoiceFile);
                }
                
                success = voiceNote.updateNote(db);
            } else {
                response.sendRedirect("NoteServlet?error=Invalid note type");
                return;
            }
            
            if (success) {
                response.sendRedirect("NoteServlet?success=Note updated successfully");
            } else {
                response.sendRedirect("NoteServlet?error=Failed to update note");
            }
            
        } catch (Exception e) {
            response.sendRedirect("NoteServlet?error=Error updating note: " + e.getMessage());
        } finally {
            db.disconnect();
        }
    }
    
    private String handleVoiceUpload(HttpServletRequest request) throws IOException, ServletException {
        // Check if there's a file upload
        Part filePart = request.getPart("voiceNote");
        if (filePart != null && filePart.getSize() > 0) {
            return saveUploadedFile(filePart);
        }
        
        // Check if there's a URL provided
        String voiceUrl = request.getParameter("voiceUrl");
        if (voiceUrl != null && !voiceUrl.trim().isEmpty()) {
            return voiceUrl.trim();
        }
        
        return null; // No new voice content provided
    }
    
    private String saveUploadedFile(Part filePart) throws IOException {
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        
        // Generate unique filename
        String timestamp = String.valueOf(System.currentTimeMillis());
        String extension = "";
        int lastDot = fileName.lastIndexOf('.');
        if (lastDot > 0) {
            extension = fileName.substring(lastDot);
        }
        String uniqueFileName = "voice_" + timestamp + extension;
        
        // Create upload directory if it doesn't exist
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // Save file
        String filePath = uploadPath + File.separator + uniqueFileName;
        filePart.write(filePath);
        
        // Return relative path for database storage
        return UPLOAD_DIR + "/" + uniqueFileName;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("NoteServlet");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Edit Note servlet with file upload support";
    }
}
