<%-- Note Content Only --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.TextNote"%>
<%@page import="model.VoiceNote"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>

<!-- Page Header -->
<div class="page-header">
    <div class="page-title-section">
        <h1>
            <i class="fas fa-sticky-note"></i>
            Notes
        </h1>
    </div>
    
    <div class="profile-section">
        <div class="profile-info">
            <span><%= session.getAttribute("username") != null ? session.getAttribute("username") : "User" %></span>
            <div class="dropdown">
                <img src="assets/image/Avatar.png" alt="Profile" class="profile-avatar dropdown-toggle" data-bs-toggle="dropdown" style="cursor: pointer;">
                <ul class="dropdown-menu">
                    <li><a class="dropdown-item" href="UserServlet">Profile</a></li>
                    <li><a class="dropdown-item" href="logout">Logout</a></li>
                </ul>
            </div>
        </div>
    </div>
</div>

<%
@SuppressWarnings("unchecked")
List<TextNote> textNotes = (List<TextNote>) request.getAttribute("textNotes");
@SuppressWarnings("unchecked")
List<VoiceNote> voiceNotes = (List<VoiceNote>) request.getAttribute("voiceNotes");

SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
%>

<!-- Notes Container with Two Columns -->
<div class="notes-container">
    <!-- Text Notes Column -->
    <div class="notes-column">
        <div class="section-title">
            <i class="fas fa-file-alt section-icon"></i>
            Text Notes
        </div>
        
        <% if (textNotes != null && !textNotes.isEmpty()) { %>
            <div class="notes-grid">
                <% for (TextNote note : textNotes) { 
                    if (note != null && note.getTitle() != null) {
                        // Safely escape content for JavaScript
                        String safeTitle = note.getTitle().replace("\\", "\\\\").replace("'", "\\'");
                        String safeContent = "";
                        if (note.getTextNote() != null) {
                            safeContent = note.getTextNote()
                                .replace("\\", "\\\\")
                                .replace("'", "\\'")
                                .replace("\n", "\\n")
                                .replace("\r", "");
                        }
                %>
                    <div class="note-card">
                        <div class="note-actions">
                            <button class="action-btn edit-btn" onclick="editTextNote(<%= note.getId() %>, '<%= safeTitle %>', '<%= safeContent %>')">
                                <i class="fas fa-pencil-alt"></i>
                            </button>
                            <button class="action-btn delete-btn" onclick="deleteNote(<%= note.getId() %>, 'text')">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </div>
                        <div class="note-title"><%= note.getTitle() %></div>
                        <% if (note.getTextNote() != null && !note.getTextNote().trim().isEmpty()) { %>
                            <div class="note-content"><%= note.getTextNote() %></div>
                        <% } %>
                        <div class="note-meta">
                            <div class="note-date">
                                <i class="fas fa-calendar-alt"></i>
                                <% if (note.getCreatedDate() != null) { %>
                                    <%= dateFormat.format(note.getCreatedDate()) %>
                                <% } else { %>
                                    No date
                                <% } %>
                            </div>
                        </div>
                    </div>
                <% } } %>
            </div>
        <% } else { %>
            <div class="empty-state">
                <i class="fas fa-file-alt fa-3x"></i>
                <h3>No Text Notes Yet</h3>
                <p>Create your first text note to get started</p>
                <button class="btn btn-primary mt-3" onclick="showAddModalNote('text')">
                    <i class="fas fa-plus"></i> Add Text Note
                </button>
            </div>
        <% } %>
    </div>
    
    <!-- Voice Notes Column -->
    <div class="notes-column">
        <div class="section-title">
            <i class="fas fa-microphone section-icon"></i>
            Voice Notes
        </div>
        
        <% if (voiceNotes != null && !voiceNotes.isEmpty()) { %>
            <div class="notes-grid">
                <% for (VoiceNote note : voiceNotes) { 
                    if (note != null && note.getTitle() != null) {
                        // Safely escape content for JavaScript
                        String safeTitle = note.getTitle().replace("\\", "\\\\").replace("'", "\\'");
                        String safeVoiceUrl = "";
                        if (note.getVoiceNote() != null) {
                            safeVoiceUrl = note.getVoiceNote().replace("'", "\\'");
                        }
                %>
                    <div class="note-card">
                        <div class="note-actions">
                            <button class="action-btn edit-btn" onclick="editVoiceNote(<%= note.getId() %>, '<%= safeTitle %>', '<%= safeVoiceUrl %>')">
                                <i class="fas fa-pencil-alt"></i>
                            </button>
                            <button class="action-btn delete-btn" onclick="deleteNote(<%= note.getId() %>, 'voice')">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </div>
                        <div class="note-title"><%= note.getTitle() %></div>
                        <div class="note-content">
                            <% if (note.getVoiceNote() != null && !note.getVoiceNote().isEmpty()) { %>
                                <audio controls class="audio-player">
                                    <source src="<%= note.getVoiceNote() %>" type="audio/mpeg">
                                    <source src="<%= note.getVoiceNote() %>" type="audio/wav">
                                    <source src="<%= note.getVoiceNote() %>" type="audio/ogg">
                                    Your browser does not support the audio element.
                                </audio>
                            <% } else { %>
                                <p class="text-muted">No audio recording available</p>
                            <% } %>
                        </div>
                        <div class="note-meta">
                            <div class="note-date">
                                <i class="fas fa-calendar-alt"></i>
                                <% if (note.getCreatedDate() != null) { %>
                                    <%= dateFormat.format(note.getCreatedDate()) %>
                                <% } else { %>
                                    No date
                                <% } %>
                            </div>
                        </div>
                    </div>
                <% } } %>
            </div>
        <% } else { %>
            <div class="empty-state">
                <i class="fas fa-microphone fa-3x"></i>
                <h3>No Voice Notes Yet</h3>
                <p>Record your first voice note to get started</p>
                <button class="btn btn-primary mt-3" onclick="showAddModalNote('voice')">
                    <i class="fas fa-plus"></i> Add Voice Note
                </button>
            </div>
        <% } %>
    </div>
</div>

<button class="floating-add-btn" onclick="showAddModalNote()">
    <i class="fas fa-plus"></i>
</button>

<!-- Add Note Modal -->
<div class="modal fade" id="modaladd" tabindex="-1" aria-labelledby="modaladdLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modaladdLabel">
                    <i class="fas fa-plus"></i> Add New Note
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <ul class="nav nav-tabs" id="noteTypeTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="text-tab" data-bs-toggle="tab" data-bs-target="#text-note" type="button" role="tab">
                            <i class="fas fa-file-alt me-2"></i>Text Note
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="voice-tab" data-bs-toggle="tab" data-bs-target="#voice-note" type="button" role="tab">
                            <i class="fas fa-microphone me-2"></i>Voice Note
                        </button>
                    </li>
                </ul>
                <div class="tab-content mt-3" id="noteTypeContent">
                    <!-- Text Note Form -->
                    <div class="tab-pane fade show active" id="text-note" role="tabpanel">
                        <form action="AddNoteServlet" method="post">
                                <input type="hidden" name="noteType" value="text">
                            <div class="mb-3">
                                <label for="textNoteTitle" class="form-label">Title</label>
                                <input type="text" class="form-control" id="textNoteTitle" name="title" placeholder="Enter note title" required>
                            </div>
                            <div class="mb-3">
                                <label for="textNoteContent" class="form-label">Content</label>
                                <textarea class="form-control" id="textNoteContent" name="textNote" rows="8" placeholder="Enter your note content here..." required></textarea>
                            </div>
                            <div class="text-end">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-2"></i>Save Text Note
                                </button>
                            </div>
                        </form>
                    </div>
                    
                    <!-- Voice Note Form -->
                    <div class="tab-pane fade" id="voice-note" role="tabpanel">
                        <form action="AddNoteServlet" method="post" enctype="multipart/form-data">
                                <input type="hidden" name="noteType" value="voice">
                            <div class="mb-3">
                                <label for="voiceNoteTitle" class="form-label">Title</label>
                                <input type="text" class="form-control" id="voiceNoteTitle" name="title" placeholder="Enter voice note title" required>
                            </div>
                            
                            <!-- Recording Section -->
                            <div class="mb-3">
                                <label class="form-label">Record Audio</label>
                                <div class="recording-controls text-center mb-3">
                                    <button type="button" class="btn btn-outline-danger me-2" id="recordButton">
                                        <i class="fas fa-microphone"></i> Record
                                    </button>
                                    <button type="button" class="btn btn-outline-secondary me-2" id="stopButton" disabled>
                                        <i class="fas fa-stop"></i> Stop
                                    </button>
                                    <button type="button" class="btn btn-outline-primary" id="playButton" disabled>
                                        <i class="fas fa-play"></i> Play
                                    </button>
                                </div>
                                <div id="recordingStatus" class="text-center mb-2"></div>
                                <audio id="recordedAudio" controls style="width: 100%; display: none;"></audio>
                                <input type="hidden" id="recordedAudioData" name="voicerecord">
                            </div>
                            
                            <!-- File Upload Section -->
                            <div class="mb-3">
                                <label for="voiceNoteFile" class="form-label">Or Upload Audio File</label>
                                <input type="file" class="form-control" id="voiceNoteFile" name="voiceNote" accept="audio/*">
                                <small class="form-text text-muted">Supported formats: MP3, WAV, OGG</small>
                            </div>
                            
                            <!-- URL Section -->
                            <div class="mb-3">
                                <label for="voiceNoteUrl" class="form-label">Or Enter Audio URL</label>
                                <input type="text" class="form-control" id="voiceNoteUrl" name="voiceUrl" placeholder="https://example.com/audio.mp3">
                                <small class="form-text text-muted">Leave empty if recording or uploading a file</small>
                            </div>
                            
                            <div class="text-end">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-2"></i>Save Voice Note
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Edit Text Note Modal -->
<div class="modal fade" id="editTextNoteModal" tabindex="-1" aria-labelledby="editTextNoteModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editTextNoteModalLabel">
                    <i class="fas fa-edit"></i> Edit Text Note
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="EditNoteServlet" method="post">
                <input type="hidden" id="editTextNoteId" name="id">
                <input type="hidden" name="noteType" value="text">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="editTextNoteTitle" class="form-label">Title</label>
                        <input type="text" class="form-control" id="editTextNoteTitle" name="title" required>
                    </div>
                    <div class="mb-3">
                        <label for="editTextNoteContent" class="form-label">Content</label>
                        <textarea class="form-control" id="editTextNoteContent" name="textNote" rows="8" required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i>Update Note
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Voice Note Modal -->
<div class="modal fade" id="editVoiceNoteModal" tabindex="-1" aria-labelledby="editVoiceNoteModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editVoiceNoteModalLabel">
                    <i class="fas fa-edit"></i> Edit Voice Note
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="EditNoteServlet" method="post" enctype="multipart/form-data">
                <input type="hidden" id="editVoiceNoteId" name="id">
                <input type="hidden" name="noteType" value="voice">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="editVoiceNoteTitle" class="form-label">Title</label>
                        <input type="text" class="form-control" id="editVoiceNoteTitle" name="title" required>
                    </div>
                    
                    <!-- Current Voice File Info -->
                    <div class="mb-3">
                        <label class="form-label">Current Audio</label>
                        <div class="current-file-info p-3 bg-light rounded">
                            <audio controls class="audio-player mb-2" id="currentVoicePlayer" style="width: 100%;">
                                <source id="currentVoiceSource" src="assets/image/placeholder.svg" type="audio/mpeg">
                                Your browser does not support the audio element.
                            </audio>
                            <small class="text-muted">Current file: <span id="currentFileName">No file</span></small>
                        </div>
                    </div>
                    
                    <!-- Upload New Voice File -->
                    <div class="mb-3">
                        <label for="editVoiceFile" class="form-label">Upload New Audio File (Optional)</label>
                        <input type="file" class="form-control" id="editVoiceFile" name="voiceNote" accept="audio/*">
                        <small class="form-text text-muted">Leave empty to keep current audio</small>
                    </div>
                    
                    <!-- Alternative: Voice URL -->
                    <div class="mb-3">
                        <label for="editVoiceUrl" class="form-label">Or Enter New Audio URL</label>
                        <input type="text" class="form-control" id="editVoiceUrl" name="voiceUrl" placeholder="https://example.com/audio.mp3">
                        <small class="form-text text-muted">Leave empty if uploading a file above</small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i>Update Voice Note
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Include SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    let mediaRecorder;
    let audioChunks = [];
    let audioBlob;
    let audioUrl;
    
    function showAddModalNote(type = null) {
        const modal = new bootstrap.Modal(document.getElementById('modaladd'));
        modal.show();
        
        // Reset forms
        document.getElementById('textNoteTitle').value = '';
        document.getElementById('textNoteContent').value = '';
        document.getElementById('voiceNoteTitle').value = '';
        document.getElementById('voiceNoteFile').value = '';
        document.getElementById('voiceNoteUrl').value = '';
        document.getElementById('recordedAudioData').value = '';
        
        // Reset recording UI
        resetRecordingUI();
        
        // Switch to specific tab if type is specified
        if (type === 'text') {
            document.getElementById('text-tab').click();
        } else if (type === 'voice') {
            document.getElementById('voice-tab').click();
        }
    }
    
    function editTextNote(id, title, content) {
        try {
            document.getElementById('editTextNoteId').value = id;
            document.getElementById('editTextNoteTitle').value = title || '';
            document.getElementById('editTextNoteContent').value = content.replace(/\\n/g, '\n') || '';
            
            const modal = new bootstrap.Modal(document.getElementById('editTextNoteModal'));
            modal.show();
        } catch (error) {
            console.error('Error opening text note edit modal:', error);
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Error opening edit form. Please try again.'
            });
        }
    }
    
    function editVoiceNote(id, title, voiceUrl) {
        try {
            document.getElementById('editVoiceNoteId').value = id;
            document.getElementById('editVoiceNoteTitle').value = title || '';
            
            // Set current voice file info
            if (voiceUrl) {
                document.getElementById('currentVoiceSource').src = voiceUrl;
                document.getElementById('currentVoicePlayer').load();
                document.getElementById('currentFileName').textContent = voiceUrl.split('/').pop();
                document.getElementById('editVoiceUrl').value = voiceUrl;
            } else {
                document.getElementById('currentFileName').textContent = 'No file';
                document.getElementById('editVoiceUrl').value = '';
            }
            
            const modal = new bootstrap.Modal(document.getElementById('editVoiceNoteModal'));
            modal.show();
        } catch (error) {
            console.error('Error opening voice note edit modal:', error);
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Error opening edit form. Please try again.'
            });
        }
    }
    
    function deleteNote(id, type) {
        Swal.fire({
            title: 'Are you sure?',
            text: "You won't be able to revert this!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Yes, delete it!'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = 'DeleteNoteServlet?id=' + id + '&noteType=' + type;
            }
        });
    }
    
    function resetRecordingUI() {
        document.getElementById('recordButton').disabled = false;
        document.getElementById('stopButton').disabled = true;
        document.getElementById('playButton').disabled = true;
        document.getElementById('recordingStatus').textContent = '';
        document.getElementById('recordedAudio').style.display = 'none';
    }
    
    // Voice recording functionality
    document.addEventListener('DOMContentLoaded', function() {
        const recordButton = document.getElementById('recordButton');
        const stopButton = document.getElementById('stopButton');
        const playButton = document.getElementById('playButton');
        const recordingStatus = document.getElementById('recordingStatus');
        const recordedAudio = document.getElementById('recordedAudio');
        const recordedAudioData = document.getElementById('recordedAudioData');
        
        if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
            recordButton.addEventListener('click', startRecording);
            stopButton.addEventListener('click', stopRecording);
            playButton.addEventListener('click', playRecording);
        } else {
            recordButton.disabled = true;
            recordingStatus.textContent = 'Recording not supported in this browser';
        }
        
        function startRecording() {
            recordingStatus.innerHTML = '<i class="fas fa-circle text-danger"></i> Recording...';
            recordButton.disabled = true;
            stopButton.disabled = false;
            playButton.disabled = true;
            recordedAudio.style.display = 'none';
            
            navigator.mediaDevices.getUserMedia({ audio: true })
                .then(stream => {
                    mediaRecorder = new MediaRecorder(stream);
                    audioChunks = [];
                    
                    mediaRecorder.addEventListener('dataavailable', event => {
                        audioChunks.push(event.data);
                    });
                    
                    mediaRecorder.addEventListener('stop', () => {
                        audioBlob = new Blob(audioChunks, { type: 'audio/mpeg' });
                        audioUrl = URL.createObjectURL(audioBlob);
                        recordedAudio.src = audioUrl;
                        recordedAudio.style.display = 'block';
                        
                        // Convert to base64 for form submission
                        const reader = new FileReader();
                        reader.onloadend = function() {
                            recordedAudioData.value = reader.result;
                        };
                        reader.readAsDataURL(audioBlob);
                        
                        recordingStatus.innerHTML = '<i class="fas fa-check text-success"></i> Recording saved';
                    });
                    
                    mediaRecorder.start();
                })
                .catch(error => {
                    console.error('Error accessing microphone:', error);
                    recordingStatus.innerHTML = '<i class="fas fa-exclamation-triangle text-warning"></i> Error accessing microphone';
                    recordButton.disabled = false;
                });
        }
        
        function stopRecording() {
            mediaRecorder.stop();
            recordButton.disabled = false;
            stopButton.disabled = true;
            playButton.disabled = false;
            
            // Stop all audio tracks
            mediaRecorder.stream.getTracks().forEach(track => track.stop());
        }
        
        function playRecording() {
            recordedAudio.play();
        }
        
        // Handle audio loading errors
        const audioElements = document.querySelectorAll('audio');
        audioElements.forEach(function(audio) {
            audio.addEventListener('error', function() {
                const errorMsg = document.createElement('div');
                errorMsg.className = 'alert alert-warning mt-2';
                errorMsg.innerHTML = '<small><i class="fas fa-exclamation-triangle"></i> Audio file could not be loaded</small>';
                audio.parentNode.insertBefore(errorMsg, audio.nextSibling);
                audio.style.display = 'none';
            });
        });
    });
</script>
