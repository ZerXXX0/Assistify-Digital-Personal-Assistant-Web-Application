<%-- Journal Content Only --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.JournalEntry"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>

<!-- Page Header -->
<div class="page-header">
    <div class="page-title-section">
        <h1>
            <i class="fas fa-book-open"></i>
            My Journal
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
List<JournalEntry> journalList = (List<JournalEntry>) request.getAttribute("journalList");

if (journalList != null && !journalList.isEmpty()) {
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
    SimpleDateFormat fullFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
    
    // Get today and yesterday dates for comparison
    Calendar today = Calendar.getInstance();
    today.set(Calendar.HOUR_OF_DAY, 0);
    today.set(Calendar.MINUTE, 0);
    today.set(Calendar.SECOND, 0);
    today.set(Calendar.MILLISECOND, 0);
    
    Calendar yesterday = (Calendar) today.clone();
    yesterday.add(Calendar.DAY_OF_MONTH, -1);
    
    // Counters for each section
    int todayCount = 0;
    int yesterdayCount = 0;
    int earlierCount = 0;
    
    // First pass: count entries for each section
    for (JournalEntry entry : journalList) {
        if (entry == null || entry.getEntrydate() == null) continue;
        
        Calendar entryDate = Calendar.getInstance();
        entryDate.setTime(entry.getEntrydate());
        entryDate.set(Calendar.HOUR_OF_DAY, 0);
        entryDate.set(Calendar.MINUTE, 0);
        entryDate.set(Calendar.SECOND, 0);
        entryDate.set(Calendar.MILLISECOND, 0);
        
        if (entryDate.equals(today)) {
            todayCount++;
        } else if (entryDate.equals(yesterday)) {
            yesterdayCount++;
        } else {
            earlierCount++;
        }
    }
    
    // Display today's entries
    if (todayCount > 0) {
%>
        <div class="section-title">
            <i class="fas fa-sun section-icon" style="color: #f39c12;"></i>
            Today's Entries
        </div>
        <div class="journal-grid">
<%
        for (JournalEntry entry : journalList) {
            if (entry == null || entry.getEntrydate() == null) continue;
            
            Calendar entryDate = Calendar.getInstance();
            entryDate.setTime(entry.getEntrydate());
            entryDate.set(Calendar.HOUR_OF_DAY, 0);
            entryDate.set(Calendar.MINUTE, 0);
            entryDate.set(Calendar.SECOND, 0);
            entryDate.set(Calendar.MILLISECOND, 0);
            
            if (entryDate.equals(today)) {
                // Safely escape content for JavaScript
                String safeTitle = "";
                String safeContent = "";
                if (entry.getTitle() != null) {
                    safeTitle = entry.getTitle()
                        .replace("\\", "\\\\")
                        .replace("'", "\\'")
                        .replace("\n", "\\n")
                        .replace("\r", "");
                }
                if (entry.getContent() != null) {
                    safeContent = entry.getContent()
                        .replace("\\", "\\\\")
                        .replace("'", "\\'")
                        .replace("\n", "\\n")
                        .replace("\r", "");
                }
%>
                <div class="journal-card">
                    <div class="journal-actions">
                        <button class="action-btn edit-btn" onclick="editJournal(<%= entry.getId() %>, '<%= safeTitle %>', '<%= safeContent %>', '<%= fullFormat.format(entry.getEntrydate()) %>')">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="action-btn delete-btn" onclick="deleteJournal(<%= entry.getId() %>)">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                    <div class="journal-card-title">
                        <i class="fas fa-feather-alt"></i> <%= entry.getTitle() != null ? entry.getTitle() : "Journal Entry" %>
                    </div>
                    <div class="journal-content"><%= entry.getContent() %></div>
                    <div class="journal-meta">
                        <span class="journal-date">
                            <i class="fas fa-clock"></i> Today, <%= timeFormat.format(entry.getEntrydate()) %>
                        </span>
                    </div>
                </div>
<%
            }
        }
%>
        </div>
<%
    }
    
    // Display yesterday's entries
    if (yesterdayCount > 0) {
%>
        <div class="section-title">
            <i class="fas fa-moon section-icon" style="color: #9b59b6;"></i>
            Yesterday's Entries
        </div>
        <div class="journal-grid">
<%
        for (JournalEntry entry : journalList) {
            if (entry == null || entry.getEntrydate() == null) continue;
            
            Calendar entryDate = Calendar.getInstance();
            entryDate.setTime(entry.getEntrydate());
            entryDate.set(Calendar.HOUR_OF_DAY, 0);
            entryDate.set(Calendar.MINUTE, 0);
            entryDate.set(Calendar.SECOND, 0);
            entryDate.set(Calendar.MILLISECOND, 0);
            
            if (entryDate.equals(yesterday)) {
                // Safely escape content for JavaScript
                String safeTitle = "";
                String safeContent = "";
                if (entry.getTitle() != null) {
                    safeTitle = entry.getTitle()
                        .replace("\\", "\\\\")
                        .replace("'", "\\'")
                        .replace("\n", "\\n")
                        .replace("\r", "");
                }
                if (entry.getContent() != null) {
                    safeContent = entry.getContent()
                        .replace("\\", "\\\\")
                        .replace("'", "\\'")
                        .replace("\n", "\\n")
                        .replace("\r", "");
                }
%>
                <div class="journal-card">
                    <div class="journal-actions">
                        <button class="action-btn edit-btn" onclick="editJournal(<%= entry.getId() %>, '<%= safeTitle %>', '<%= safeContent %>', '<%= fullFormat.format(entry.getEntrydate()) %>')">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="action-btn delete-btn" onclick="deleteJournal(<%= entry.getId() %>)">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                    <div class="journal-card-title">
                        <i class="fas fa-feather-alt"></i> <%= entry.getTitle() != null ? entry.getTitle() : "Journal Entry" %>
                    </div>
                    <div class="journal-content"><%= entry.getContent() %></div>
                    <div class="journal-meta">
                        <span class="journal-date">
                            <i class="fas fa-clock"></i> Yesterday, <%= timeFormat.format(entry.getEntrydate()) %>
                        </span>
                    </div>
                </div>
<%
            }
        }
%>
        </div>
<%
    }
    
    // Display earlier entries
    if (earlierCount > 0) {
%>
        <div class="section-title">
            <i class="fas fa-history section-icon" style="color: #95a5a6;"></i>
            Earlier Entries
        </div>
        <div class="journal-grid">
<%
        for (JournalEntry entry : journalList) {
            if (entry == null || entry.getEntrydate() == null) continue;
            
            Calendar entryDate = Calendar.getInstance();
            entryDate.setTime(entry.getEntrydate());
            entryDate.set(Calendar.HOUR_OF_DAY, 0);
            entryDate.set(Calendar.MINUTE, 0);
            entryDate.set(Calendar.SECOND, 0);
            entryDate.set(Calendar.MILLISECOND, 0);
            
            if (!entryDate.equals(today) && !entryDate.equals(yesterday)) {
                // Safely escape content for JavaScript
                String safeTitle = "";
                String safeContent = "";
                if (entry.getTitle() != null) {
                    safeTitle = entry.getTitle()
                        .replace("\\", "\\\\")
                        .replace("'", "\\'")
                        .replace("\n", "\\n")
                        .replace("\r", "");
                }
                if (entry.getContent() != null) {
                    safeContent = entry.getContent()
                        .replace("\\", "\\\\")
                        .replace("'", "\\'")
                        .replace("\n", "\\n")
                        .replace("\r", "");
                }
%>
                <div class="journal-card">
                    <div class="journal-actions">
                        <button class="action-btn edit-btn" onclick="editJournal(<%= entry.getId() %>, '<%= safeTitle %>', '<%= safeContent %>', '<%= fullFormat.format(entry.getEntrydate()) %>')">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="action-btn delete-btn" onclick="deleteJournal(<%= entry.getId() %>)">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                    <div class="journal-card-title">
                        <i class="fas fa-feather-alt"></i> <%= entry.getTitle() != null ? entry.getTitle() : "Journal Entry" %>
                    </div>
                    <div class="journal-content"><%= entry.getContent() %></div>
                    <div class="journal-meta">
                        <span class="journal-date">
                            <i class="fas fa-calendar"></i> <%= dateFormat.format(entry.getEntrydate()) %> at <%= timeFormat.format(entry.getEntrydate()) %>
                        </span>
                    </div>
                </div>
<%
            }
        }
%>
        </div>
<%
    }
} else {
%>
    <div class="empty-state">
        <i class="fas fa-book-open fa-4x"></i>
        <h3>No journal entries yet</h3>
        <p>Start documenting your thoughts and experiences!</p>
        <button class="btn btn-primary btn-lg" onclick="showAddJournalModal()">
            <i class="fas fa-plus"></i> Write Your First Entry
        </button>
    </div>
<%
}
%>

<!-- Floating Add Button -->
<button class="floating-add-btn" onclick="showAddJournalModal()">
    <i class="fas fa-plus"></i>
</button>

<!-- Add Journal Modal -->
<div class="modal fade" id="addJournalModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-feather-alt"></i> New Journal Entry
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="AddJournalEntryServlet" method="post">
                <div class="modal-body">
                    <div class="form-group mb-3">
                        <label for="addJournalTitle" class="form-label">Title</label>
                        <input type="text" class="form-control" id="addJournalTitle" name="title" 
                               placeholder="Give your entry a title..." maxlength="100">
                        <div class="form-text">Optional - leave blank for default title</div>
                    </div>
                    <div class="form-group mb-3">
                        <label for="addJournalContent" class="form-label">What's on your mind?</label>
                        <textarea class="form-control" id="addJournalContent" name="content" rows="10" 
                                  placeholder="Write your thoughts, experiences, or reflections here..." required></textarea>
                        <div class="form-text">Express yourself freely - this is your personal space.</div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Save Entry
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Journal Modal -->
<div class="modal fade" id="editJournalModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-edit"></i> Edit Journal Entry
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="EditJournalEntryServlet" method="post">
                <div class="modal-body">
                    <input type="hidden" id="editJournalId" name="id">
                    <div class="form-group mb-3">
                        <label for="editJournalTitle" class="form-label">Title</label>
                        <input type="text" class="form-control" id="editJournalTitle" name="title" 
                               placeholder="Give your entry a title..." maxlength="100">
                    </div>
                    <div class="form-group mb-3">
                        <label for="editJournalDate" class="form-label">Date & Time</label>
                        <input type="datetime-local" class="form-control" id="editJournalDate" name="entrydate" readonly>
                        <div class="form-text">Entry date cannot be changed</div>
                    </div>
                    <div class="form-group mb-3">
                        <label for="editJournalContent" class="form-label">Content</label>
                        <textarea class="form-control" id="editJournalContent" name="content" rows="10" required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Save Changes
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Include SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    // Show add modal
    function showAddJournalModal() {
        // Reset form
        document.getElementById('addJournalTitle').value = '';
        document.getElementById('addJournalContent').value = '';
        
        var addModal = new bootstrap.Modal(document.getElementById('addJournalModal'));
        addModal.show();
    }

    // Edit journal entry
    function editJournal(id, title, content, entrydate) {
        document.getElementById('editJournalId').value = id;
        document.getElementById('editJournalTitle').value = title;
        document.getElementById('editJournalContent').value = content.replace(/\\n/g, '\n');
        document.getElementById('editJournalDate').value = entrydate;
        
        var editModal = new bootstrap.Modal(document.getElementById('editJournalModal'));
        editModal.show();
    }

    // Delete journal entry with SweetAlert2
    function deleteJournal(id) {
        Swal.fire({
            title: 'Are you sure?',
            text: "You won't be able to revert this journal entry!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Yes, delete it!',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = 'DeleteJournalEntryServlet?id=' + id;
            }
        });
    }

    // Auto-resize textarea
    document.addEventListener('DOMContentLoaded', function() {
        const textareas = document.querySelectorAll('textarea');
        textareas.forEach(textarea => {
            textarea.addEventListener('input', function() {
                this.style.height = 'auto';
                this.style.height = this.scrollHeight + 'px';
            });
        });
    });
</script>
