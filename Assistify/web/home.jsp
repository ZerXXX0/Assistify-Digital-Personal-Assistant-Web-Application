<%-- Home Content Only --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>

<%
    // Get data from HomeServlet
    @SuppressWarnings("unchecked")
    List<ToDoItem> recentTodos = (List<ToDoItem>) request.getAttribute("recentTodos");
    @SuppressWarnings("unchecked")
    List<Activity> recentActivities = (List<Activity>) request.getAttribute("recentActivities");
    @SuppressWarnings("unchecked")
    List<Alarm> recentAlarms = (List<Alarm>) request.getAttribute("recentAlarms");
    @SuppressWarnings("unchecked")
    List<Reminder> recentReminders = (List<Reminder>) request.getAttribute("recentReminders");
    @SuppressWarnings("unchecked")
    List<TextNote> recentTextNotes = (List<TextNote>) request.getAttribute("recentTextNotes");
    @SuppressWarnings("unchecked")
    List<VoiceNote> recentVoiceNotes = (List<VoiceNote>) request.getAttribute("recentVoiceNotes");
    @SuppressWarnings("unchecked")
    List<JournalEntry> recentJournals = (List<JournalEntry>) request.getAttribute("recentJournals");
    @SuppressWarnings("unchecked")
    List<Reminder> activeReminders = (List<Reminder>) request.getAttribute("activeReminders");
    
    // Get current time for greeting
    Calendar cal = Calendar.getInstance();
    int hour = cal.get(Calendar.HOUR_OF_DAY);
    String greeting;
    if (hour < 12) {
        greeting = "Good Morning";
    } else if (hour < 17) {
        greeting = "Good Afternoon";
    } else {
        greeting = "Good Evening";
    }
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM dd, yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
    String currentDate = dateFormat.format(new Date());
%>

<!-- Page Header -->
<div class="page-header">
    <div class="page-title-section">
        <h1>
            <i class="fas fa-home"></i>
            <%= greeting %>, <%= session.getAttribute("username") != null ? session.getAttribute("username") : "Guest" %>!
        </h1>
        <p class="text-light">Welcome back to your digital assistant</p>
    </div>
    
    <div class="profile-section">
        <div class="profile-info">
            <span><%= session.getAttribute("username") != null ? session.getAttribute("username") : "Guest" %></span>
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
    
<!-- Statistics Overview -->
<div class="dashboard-grid">
    <div class="dashboard-card">
        <div class="card-header">
            <h3 class="card-title">
                <i class="fas fa-chart-line"></i>
                Overview
            </h3>
        </div>
        <div class="row text-center">
            <div class="col-6 mb-3">
                <h2 class="text-primary"><%= (recentTodos != null ? recentTodos.size() : 0) + (recentActivities != null ? recentActivities.size() : 0) %></h2>
                <small>Total Tasks</small>
            </div>
            <div class="col-6 mb-3">
                <h2 class="text-success"><%= recentAlarms != null ? recentAlarms.size() : 0 %></h2>
                <small>Active Alarms</small>
            </div>
            <div class="col-6">
                <h2 class="text-warning"><%= activeReminders != null ? activeReminders.size() : 0 %></h2>
                <small>Pending Reminders</small>
            </div>
            <div class="col-6">
                <h2 class="text-info"><%= recentJournals != null ? recentJournals.size() : 0 %></h2>
                <small>Journal Entries</small>
            </div>
        </div>
    </div>

    <!-- To-Do Items Card -->
    <div class="dashboard-card">
        <div class="card-header">
            <h3 class="card-title">
                <i class="fas fa-tasks"></i>
                Recent To-Do Items
            </h3>
            <a href="TaskServlet" class="btn btn-primary btn-sm">
                View All <i class="fas fa-arrow-right"></i>
            </a>
        </div>
        <div class="card-content">
            <% if (recentTodos != null && !recentTodos.isEmpty()) { %>
                <% for (int i = 0; i < Math.min(5, recentTodos.size()); i++) { 
                    ToDoItem todo = recentTodos.get(i);
                    String statusClass = todo.isCompleted() ? "status-completed" : 
                                       (todo.getDueDate() != null && todo.getDueDate().before(new Date()) ? "status-overdue" : "status-pending");
                    String statusText = todo.isCompleted() ? "Completed" : 
                                      (todo.getDueDate() != null && todo.getDueDate().before(new Date()) ? "Overdue" : "Pending");
                %>
                    <div class="item-row">
                        <div class="item-info">
                            <div class="item-title"><%= todo.getTitle() %></div>
                            <div class="item-subtitle">
                                <% if (todo.getDueDate() != null) { %>
                                    Due: <%= new SimpleDateFormat("MMM dd, yyyy").format(todo.getDueDate()) %>
                                <% } else { %>
                                    No due date
                                <% } %>
                            </div>
                        </div>
                        <div class="item-status">
                            <span class="status-badge <%= statusClass %>"><%= statusText %></span>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <div class="empty-section">
                    <i class="fas fa-tasks fa-2x"></i>
                    <p>No to-do items yet</p>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Activities Card -->
    <div class="dashboard-card">
        <div class="card-header">
            <h3 class="card-title">
                <i class="fas fa-calendar-check"></i>
                Recent Activities
            </h3>
            <a href="TaskServlet" class="btn btn-primary btn-sm">
                View All <i class="fas fa-arrow-right"></i>
            </a>
        </div>
        <div class="card-content">
            <% if (recentActivities != null && !recentActivities.isEmpty()) { %>
                <% for (int i = 0; i < Math.min(5, recentActivities.size()); i++) { 
                    Activity activity = recentActivities.get(i);
                %>
                    <div class="item-row">
                        <div class="item-info">
                            <div class="item-title"><%= activity.getTitle() %></div>
                            <div class="item-subtitle">
                                <% if (activity.getStartTime() != null) { %>
                                    Started: <%= new SimpleDateFormat("MMM dd, HH:mm").format(activity.getStartTime()) %>
                                <% } else { %>
                                    No start time
                                <% } %>
                            </div>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <div class="empty-section">
                    <i class="fas fa-running fa-2x"></i>
                    <p>No activities yet</p>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Alarms Card -->
    <div class="dashboard-card">
        <div class="card-header">
            <h3 class="card-title">
                <i class="fa-solid fa-clock-rotate-left"></i>
                Recent Alarms
            </h3>
            <a href="AlarmServlet" class="btn btn-primary btn-sm">
                View All <i class="fas fa-arrow-right"></i>
            </a>
        </div>
        <div class="card-content">
            <% if (recentAlarms != null && !recentAlarms.isEmpty()) { %>
                <% for (int i = 0; i < Math.min(5, recentAlarms.size()); i++) { 
                    Alarm alarm = recentAlarms.get(i);
                    String alarmStatus = alarm.getStatus();
                    String statusClass = alarmStatus.equalsIgnoreCase("active") ? "status-active" : "status-pending";
                    String statusText = alarmStatus.equalsIgnoreCase("active") ? "Active" : "Inactive";
                %>
                    <div class="item-row">
                        <div class="item-info">
                            <div class="item-title">
                                <%= alarm.getTitle() != null ? alarm.getTitle() : "Alarm" %>
                            </div>
                            <div class="item-subtitle">
                                <%= new SimpleDateFormat("HH:mm").format(alarm.getTime()) %>
                            </div>
                        </div>
                        <div class="item-status">
                            <span class="status-badge <%= statusClass %>"><%= statusText %></span>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <div class="empty-section">
                    <i class="fa-solid fa-clock-rotate-left fa-2x"></i>
                    <p>No alarms set</p>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Text Notes Card -->
    <div class="dashboard-card">
        <div class="card-header">
            <h3 class="card-title">
                <i class="fas fa-sticky-note"></i>
                Recent Text Notes
            </h3>
            <a href="NoteServlet" class="btn btn-primary btn-sm">
                View All <i class="fas fa-arrow-right"></i>
            </a>
        </div>
        <div class="card-content">
            <% if (recentTextNotes != null && !recentTextNotes.isEmpty()) { %>
                <% for (int i = 0; i < Math.min(5, recentTextNotes.size()); i++) { 
                    TextNote note = recentTextNotes.get(i);
                %>
                    <div class="item-row">
                        <div class="item-info">
                            <div class="item-title"><%= note.getTitle() %></div>
                            <div class="item-subtitle">
                                <%= note.getTextNote().length() > 50 ? 
                                    note.getTextNote().substring(0, 50) + "..." : 
                                    note.getTextNote() %>
                            </div>
                        </div>
                        <div class="item-status">
                            <div class="time-info">
                                <%= new SimpleDateFormat("MMM dd").format(note.getCreatedDate()) %>
                            </div>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <div class="empty-section">
                    <i class="fas fa-sticky-note fa-2x"></i>
                    <p>No text notes yet</p>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Voice Notes Card -->
    <div class="dashboard-card">
        <div class="card-header">
            <h3 class="card-title">
                <i class="fas fa-microphone"></i>
                Recent Voice Notes
            </h3>
            <a href="NoteServlet" class="btn btn-primary btn-sm">
                View All <i class="fas fa-arrow-right"></i>
            </a>
        </div>
        <div class="card-content">
            <% if (recentVoiceNotes != null && !recentVoiceNotes.isEmpty()) { %>
                <% for (int i = 0; i < Math.min(5, recentVoiceNotes.size()); i++) { 
                    VoiceNote note = recentVoiceNotes.get(i);
                %>
                    <div class="item-row">
                        <div class="item-info">
                            <div class="item-title"><%= note.getTitle() %></div>
                            <div class="item-subtitle">
                                <i class="fas fa-volume-up"></i> Voice recording
                                <% if (note.getVoiceNote() != null && !note.getVoiceNote().isEmpty()) { %>
                                    <audio controls class="audio-player mt-2" style="width: 100%; height: 30px;">
                                        <source src="<%= note.getVoiceNote() %>" type="audio/mpeg">
                                        Your browser does not support the audio element.
                                    </audio>
                                <% } %>
                            </div>
                        </div>
                        <div class="item-status">
                            <div class="time-info">
                                <%= new SimpleDateFormat("MMM dd").format(note.getCreatedDate()) %>
                            </div>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <div class="empty-section">
                    <i class="fas fa-microphone fa-2x"></i>
                    <p>No voice notes yet</p>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Journal Entries Card -->
    <div class="dashboard-card">
        <div class="card-header">
            <h3 class="card-title">
                <i class="fas fa-book"></i>
                Recent Journal Entries
            </h3>
            <a href="JournalEntryServlet" class="btn btn-primary btn-sm">
                View All <i class="fas fa-arrow-right"></i>
            </a>
        </div>
        <div class="card-content">
            <% if (recentJournals != null && !recentJournals.isEmpty()) { %>
                <% for (int i = 0; i < Math.min(5, recentJournals.size()); i++) { 
                    JournalEntry journal = recentJournals.get(i);
                %>
                    <div class="item-row">
                        <div class="item-info">
                            <div class="item-title"><%= journal.getTitle() != null ? journal.getTitle() : "Journal Entry" %></div>
                            <div class="item-subtitle">
                                <%= journal.getContent().length() > 60 ? 
                                    journal.getContent().substring(0, 60) + "..." : 
                                    journal.getContent() %>
                            </div>
                        </div>
                        <div class="item-status">
                            <div class="time-info">
                                <%= new SimpleDateFormat("MMM dd").format(journal.getEntrydate()) %>
                            </div>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <div class="empty-section">
                    <i class="fas fa-book fa-2x"></i>
                    <p>No journal entries yet</p>
                </div>
            <% } %>
        </div>
    </div>
</div>

<!-- Quick Actions -->
<div class="dashboard-card">
    <div class="card-header">
        <h3 class="card-title">
            <i class="fas fa-bolt"></i>
            Quick Actions
        </h3>
    </div>
    <div class="row">
        <div class="col-md-2 col-6 mb-3">
            <a href="TaskServlet" class="btn btn-primary w-100">
                <i class="fas fa-tasks d-block mb-2"></i>
                Tasks
            </a>
        </div>
        <div class="col-md-2 col-6 mb-3">
            <a href="AlarmServlet" class="btn btn-primary w-100">
                <i class="fa-solid fa-clock-rotate-left d-block mb-2"></i>
                Alarms
            </a>
        </div>
        <div class="col-md-2 col-6 mb-3">
            <a href="NoteServlet" class="btn btn-primary w-100">
                <i class="fas fa-sticky-note d-block mb-2"></i>
                Notes
            </a>
        </div>
        <div class="col-md-2 col-6 mb-3">
            <a href="JournalEntryServlet" class="btn btn-primary w-100">
                <i class="fas fa-book d-block mb-2"></i>
                Journal
            </a>
        </div>
        <div class="col-md-2 col-6 mb-3">
            <a href="ReminderServlet" class="btn btn-primary w-100">
                <i class="fas fa-bell d-block mb-2"></i>
                Reminders
            </a>
        </div>
        <div class="col-md-2 col-6 mb-3">
            <a href="HomeServlet?page=settings" class="btn btn-primary w-100">
                <i class="fas fa-cog d-block mb-2"></i>
                Settings
            </a>
        </div>
    </div>
</div>



<script>
// Update current time every second
function updateTime() {
    const now = new Date();
    const timeString = now.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
    const timeElement = document.getElementById('currentTime');
    if (timeElement) {
        timeElement.textContent = timeString;
    }
}

// Update time immediately and then every second
updateTime();
setInterval(updateTime, 1000);

// Add smooth animations to cards
document.addEventListener('DOMContentLoaded', function() {
    const cards = document.querySelectorAll('.dashboard-card');
    cards.forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            card.style.transition = 'all 0.6s ease';
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, index * 100);
    });
});
</script>
