package NoteServlet;

import config.DB;
import model.TextNote;
import model.VoiceNote;
import java.io.IOException;
import java.io.File;
import java.io.FileOutputStream;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.util.Base64;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet(name = "AddNoteServlet", urlPatterns = {"/AddNoteServlet"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AddNoteServlet extends HttpServlet {

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
        String title = request.getParameter("title");
        String noteType = request.getParameter("noteType");
        
        if (title == null || title.trim().isEmpty()) {
            response.sendRedirect("NoteServlet?error=Title is required");
            return;
        }
        
        DB db = new DB();
        db.connect();
        
        try {
            boolean success = false;
            
            // Current timestamp for both note types
            Timestamp now = new Timestamp(System.currentTimeMillis());
            
            if ("text".equals(noteType)) {
                // Handle text note
                String textContent = request.getParameter("textNote");
                if (textContent == null || textContent.trim().isEmpty()) {
                    response.sendRedirect("NoteServlet?error=Text content is required");
                    return;
                }
                
                TextNote textNote = new TextNote(title, textContent, now);
                textNote.setUserId(userId);
                success = textNote.saveToDatabase(db);
                
            } else if ("voice".equals(noteType)) {
                // Handle voice note
                String voiceNote = null;
                
                // Priority 1: Check for base64 recorded audio
                String voiceRecordBase64 = request.getParameter("voicerecord");
                if (voiceRecordBase64 != null && !voiceRecordBase64.trim().isEmpty()) {
                    voiceNote = saveBase64AudioFile(voiceRecordBase64);
                } else {
                    // Priority 2: Check for file upload
                    Part filePart = request.getPart("voiceNote");
                    if (filePart != null && filePart.getSize() > 0) {
                        voiceNote = saveUploadedFile(filePart);
                    } else {
                        // Priority 3: Check for voice URL
                        String voiceUrl = request.getParameter("voiceUrl");
                        if (voiceUrl != null && !voiceUrl.trim().isEmpty()) {
                            voiceNote = voiceUrl.trim();
                        }
                    }
                }
                
                if (voiceNote == null || voiceNote.trim().isEmpty()) {
                    response.sendRedirect("NoteServlet?error=Voice file is required");
                    return;
                }
                
                VoiceNote voice = new VoiceNote(title, voiceNote, now);
                voice.setUserId(userId);
                success = voice.saveToDatabase(db);
                
            } else {
                response.sendRedirect("NoteServlet?error=Invalid note type");
                return;
            }
            
            if (success) {
                response.sendRedirect("NoteServlet?success=Note added successfully");
            } else {
                response.sendRedirect("NoteServlet?error=Failed to add note");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("NoteServlet?error=Error adding note: " + e.getMessage());
        } finally {
            db.disconnect();
        }
    }
    
    /**
     * Save base64 encoded audio data as a file
     */
    private String saveBase64AudioFile(String base64Data) throws IOException {
        try {
            // Remove data URL prefix if present (e.g., "data:audio/webm;base64,")
            String cleanBase64 = base64Data;
            if (base64Data.contains(",")) {
                cleanBase64 = base64Data.substring(base64Data.indexOf(",") + 1);
            }
            
            // Decode base64 to bytes
            byte[] audioBytes = Base64.getDecoder().decode(cleanBase64);
            
            // Generate unique filename with .mp3 extension
            String timestamp = String.valueOf(System.currentTimeMillis());
            String uniqueFileName = "recorded_" + timestamp + ".mp3";
            
            // Create upload directory if it doesn't exist
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Save file
            String filePath = uploadPath + File.separator + uniqueFileName;
            try (FileOutputStream fos = new FileOutputStream(filePath)) {
                fos.write(audioBytes);
                fos.flush();
            }
            
            // Return relative path for database storage
            return UPLOAD_DIR + "/" + uniqueFileName;
            
        } catch (IllegalArgumentException e) {
            throw new IOException("Invalid base64 audio data", e);
        } catch (Exception e) {
            throw new IOException("Error saving recorded audio file", e);
        }
    }
    
    /**
     * Save uploaded file
     */
    private String saveUploadedFile(Part filePart) throws IOException {
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        
        // Generate unique filename
        String timestamp = String.valueOf(System.currentTimeMillis());
        String extension = "";
        int lastDot = fileName.lastIndexOf('.');
        if (lastDot > 0) {
            extension = fileName.substring(lastDot);
        }
        // Default to .mp3 if no extension
        if (extension.isEmpty()) {
            extension = ".mp3";
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
        return "Add Note servlet with file upload and base64 audio recording support";
    }
}
