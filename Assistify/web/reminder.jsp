<%-- Reminder Content Only --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Reminder"%>
<%@page import="model.ToDoItem"%>
<%@page import="model.Activity"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>

<!-- Page Header -->
<div class="page-header">
    <div class="page-title-section">
        <h1>
            <i class="fas fa-bell"></i>
            Reminders
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
List<Reminder> reminderList = (List<Reminder>) request.getAttribute("reminderList");
@SuppressWarnings("unchecked")
List<ToDoItem> todoItemList = (List<ToDoItem>) request.getAttribute("todoItemList");
@SuppressWarnings("unchecked")
List<Activity> activityList = (List<Activity>) request.getAttribute("activityList");

if (reminderList != null && !reminderList.isEmpty()) {
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
    SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, MMM dd, yyyy");
    SimpleDateFormat fullFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
    
    // Group reminders by date
    Calendar today = Calendar.getInstance();
    Calendar tomorrow = Calendar.getInstance();
    tomorrow.add(Calendar.DAY_OF_MONTH, 1);
    
    // Today's reminders
    boolean hasToday = false;
    for (Reminder reminder : reminderList) {
        Calendar reminderCal = Calendar.getInstance();
        reminderCal.setTime(reminder.getTime());
        if (reminderCal.get(Calendar.YEAR) == today.get(Calendar.YEAR) &&
            reminderCal.get(Calendar.DAY_OF_YEAR) == today.get(Calendar.DAY_OF_YEAR)) {
            if (!hasToday) {
%>
                <div class="section-title">
                    <i class="fas fa-sun section-icon" style="color: #28a745;"></i>
                    Today's Reminders
                </div>
                <div class="reminder-grid">
<%
                hasToday = true;
            }
%>
            <div class="reminder-card">
                <% if (reminder.getType() != null && !reminder.getType().isEmpty()) { %>
                    <div class="type-badge <%= "activity".equals(reminder.getType()) ? "activity" : "" %>">
                        <%= reminder.getType() %>
                    </div>
                <% } %>
                
                <div class="reminder-actions">
                    <button class="action-btn edit-btn" onclick="editReminder(<%= reminder.getId() %>, '<%= fullFormat.format(reminder.getTime()) %>', '<%= reminder.getMessage().replace("'", "\\'") %>', '<%= reminder.getType() != null ? reminder.getType() : "" %>', <%= reminder.getIdtask() %>)">
                        <i class="fas fa-pencil-alt"></i>
                    </button>
                    <button class="action-btn delete-btn" onclick="deleteReminder(<%= reminder.getId() %>)">
                        <i class="fas fa-trash-alt"></i>
                    </button>
                </div>
                
                <div class="reminder-title"><%= reminder.getMessage() %></div>
                <div class="reminder-time"><%= timeFormat.format(reminder.getTime()) %></div>
                
                <% if (reminder.getIdtask() > 0 && reminder.getType() != null) {
                    String linkedTaskTitle = "";
                    
                    if ("todoitem".equals(reminder.getType()) && todoItemList != null) {
                        for (ToDoItem todo : todoItemList) {
                            if (todo.getId() == reminder.getIdtask()) {
                                linkedTaskTitle = todo.getTitle();
                                break;
                            }
                        }
                    } else if ("activity".equals(reminder.getType()) && activityList != null) {
                        for (Activity activity : activityList) {
                            if (activity.getId() == reminder.getIdtask()) {
                                linkedTaskTitle = activity.getTitle();
                                break;
                            }
                        }
                    }
                    
                    if (!linkedTaskTitle.isEmpty()) {
                %>
                    <div class="task-link">Linked to: <%= linkedTaskTitle %></div>
                <% } } %>
            </div>
<%
        }
    }
    if (hasToday) {
%>
                </div>
<%
    }
    
    // Tomorrow's reminders
    boolean hasTomorrow = false;
    for (Reminder reminder : reminderList) {
        Calendar reminderCal = Calendar.getInstance();
        reminderCal.setTime(reminder.getTime());
        if (reminderCal.get(Calendar.YEAR) == tomorrow.get(Calendar.YEAR) &&
            reminderCal.get(Calendar.DAY_OF_YEAR) == tomorrow.get(Calendar.DAY_OF_YEAR)) {
            if (!hasTomorrow) {
%>
                <div class="section-title">
                    <i class="fas fa-calendar-day section-icon" style="color: #ffc107;"></i>
                    Tomorrow's Reminders
                </div>
                <div class="reminder-grid">
<%
                hasTomorrow = true;
            }
%>
            <div class="reminder-card">
                <% if (reminder.getType() != null && !reminder.getType().isEmpty()) { %>
                    <div class="type-badge <%= "activity".equals(reminder.getType()) ? "activity" : "" %>">
                        <%= reminder.getType() %>
                    </div>
                <% } %>
                
                <div class="reminder-actions">
                    <button class="action-btn edit-btn" onclick="editReminder(<%= reminder.getId() %>, '<%= fullFormat.format(reminder.getTime()) %>', '<%= reminder.getMessage().replace("'", "\\'") %>', '<%= reminder.getType() != null ? reminder.getType() : "" %>', <%= reminder.getIdtask() %>)">
                        <i class="fas fa-pencil-alt"></i>
                    </button>
                    <button class="action-btn delete-btn" onclick="deleteReminder(<%= reminder.getId() %>)">
                        <i class="fas fa-trash-alt"></i>
                    </button>
                </div>
                
                <div class="reminder-title"><%= reminder.getMessage() %></div>
                <div class="reminder-time"><%= timeFormat.format(reminder.getTime()) %></div>
                
                <% if (reminder.getIdtask() > 0 && reminder.getType() != null) {
                    String linkedTaskTitle = "";
                    
                    if ("todoitem".equals(reminder.getType()) && todoItemList != null) {
                        for (ToDoItem todo : todoItemList) {
                            if (todo.getId() == reminder.getIdtask()) {
                                linkedTaskTitle = todo.getTitle();
                                break;
                            }
                        }
                    } else if ("activity".equals(reminder.getType()) && activityList != null) {
                        for (Activity activity : activityList) {
                            if (activity.getId() == reminder.getIdtask()) {
                                linkedTaskTitle = activity.getTitle();
                                break;
                            }
                        }
                    }
                    
                    if (!linkedTaskTitle.isEmpty()) {
                %>
                    <div class="task-link">Linked to: <%= linkedTaskTitle %></div>
                <% } } %>
            </div>
<%
        }
    }
    if (hasTomorrow) {
%>
                </div>
<%
    }
    
    // Other reminders
    boolean hasOther = false;
    for (Reminder reminder : reminderList) {
        Calendar reminderCal = Calendar.getInstance();
        reminderCal.setTime(reminder.getTime());
        if ((reminderCal.get(Calendar.YEAR) != today.get(Calendar.YEAR) ||
            reminderCal.get(Calendar.DAY_OF_YEAR) != today.get(Calendar.DAY_OF_YEAR)) &&
            (reminderCal.get(Calendar.YEAR) != tomorrow.get(Calendar.YEAR) ||
            reminderCal.get(Calendar.DAY_OF_YEAR) != tomorrow.get(Calendar.DAY_OF_YEAR))) {
            if (!hasOther) {
%>
                <div class="section-title">
                    <i class="fas fa-calendar-alt section-icon" style="color: #6c757d;"></i>
                    Other Reminders
                </div>
                <div class="reminder-grid">
<%
                hasOther = true;
            }
%>
            <div class="reminder-card">
                <% if (reminder.getType() != null && !reminder.getType().isEmpty()) { %>
                    <div class="type-badge <%= "activity".equals(reminder.getType()) ? "activity" : "" %>">
                        <%= reminder.getType() %>
                    </div>
                <% } %>
                
                <div class="reminder-actions">
                    <button class="action-btn edit-btn" onclick="editReminder(<%= reminder.getId() %>, '<%= fullFormat.format(reminder.getTime()) %>', '<%= reminder.getMessage().replace("'", "\\'") %>', '<%= reminder.getType() != null ? reminder.getType() : "" %>', <%= reminder.getIdtask() %>)">
                        <i class="fas fa-pencil-alt"></i>
                    </button>
                    <button class="action-btn delete-btn" onclick="deleteReminder(<%= reminder.getId() %>)">
                        <i class="fas fa-trash-alt"></i>
                    </button>
                </div>
                
                <div class="reminder-title"><%= reminder.getMessage() %></div>
                <div class="reminder-time"><%= timeFormat.format(reminder.getTime()) %></div>
                <div class="reminder-date"><%= dateFormat.format(reminder.getTime()) %></div>
                
                <% if (reminder.getIdtask() > 0 && reminder.getType() != null) {
                    String linkedTaskTitle = "";
                    
                    if ("todoitem".equals(reminder.getType()) && todoItemList != null) {
                        for (ToDoItem todo : todoItemList) {
                            if (todo.getId() == reminder.getIdtask()) {
                                linkedTaskTitle = todo.getTitle();
                                break;
                            }
                        }
                    } else if ("activity".equals(reminder.getType()) && activityList != null) {
                        for (Activity activity : activityList) {
                            if (activity.getId() == reminder.getIdtask()) {
                                linkedTaskTitle = activity.getTitle();
                                break;
                            }
                        }
                    }
                    
                    if (!linkedTaskTitle.isEmpty()) {
                %>
                    <div class="task-link">Linked to: <%= linkedTaskTitle %></div>
                <% } } %>
            </div>
<%
        }
    }
    if (hasOther) {
%>
                </div>
<%
    }
} else {
%>
    <div class="empty-state">
        <i class="fas fa-bell fa-3x"></i>
        <h3>No Reminders Yet</h3>
        <p>Create reminders to stay on top of your tasks and activities</p>
        <button class="btn btn-primary mt-3" onclick="showAddModalReminder()">
            <i class="fas fa-plus"></i> Add Reminder
        </button>
    </div>
<%
}
%>

<button class="floating-add-btn" onclick="showAddModalReminder()">
    <i class="fas fa-plus"></i>
</button>

<!-- Add Reminder Modal -->
<div class="modal fade" id="addReminderModal" tabindex="-1" aria-labelledby="addReminderModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addReminderModalLabel">
                    <i class="fas fa-plus"></i> Add New Reminder
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="AddReminderServlet" method="post">
                <div class="modal-body">
                    <div class="form-group mb-3">
                        <label for="message" class="form-label">Reminder Message</label>
                        <input type="text" class="form-control" id="message" name="message" placeholder="Enter reminder message" required>
                    </div>
                    
                    <div class="form-group mb-3">
                        <label for="time" class="form-label">Date & Time</label>
                        <input type="datetime-local" class="form-control" id="time" name="time" required>
                    </div>
                    
                    <div class="form-group mb-3">
                        <label for="type" class="form-label">Link to Task (Optional)</label>
                        <select class="form-control" id="type" name="type" onchange="updateTaskOptions()">
                            <option value="">No task linked</option>
                            <option value="todoitem">To-Do Item</option>
                            <option value="activity">Activity</option>
                        </select>
                    </div>
                    
                    <div class="form-group mb-3" id="taskSelectGroup" style="display: none;">
                        <label for="idtask" class="form-label">Select Task</label>
                        <select class="form-control" id="idtask" name="idtask">
                            <option value="0">Select a task</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Save Reminder
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Reminder Modal -->
<div class="modal fade" id="editReminderModal" tabindex="-1" aria-labelledby="editReminderModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editReminderModalLabel">
                    <i class="fas fa-edit"></i> Edit Reminder
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="EditReminderServlet" method="post">
                <input type="hidden" id="editId" name="id">
                <div class="modal-body">
                    <div class="form-group mb-3">
                        <label for="editMessage" class="form-label">Reminder Message</label>
                        <input type="text" class="form-control" id="editMessage" name="message" required>
                    </div>
                    
                    <div class="form-group mb-3">
                        <label for="editTime" class="form-label">Date & Time</label>
                        <input type="datetime-local" class="form-control" id="editTime" name="time" required>
                    </div>
                    
                    <div class="form-group mb-3">
                        <label for="editType" class="form-label">Link to Task (Optional)</label>
                        <select class="form-control" id="editType" name="type" onchange="updateEditTaskOptions()">
                            <option value="">No task linked</option>
                            <option value="todoitem">To-Do Item</option>
                            <option value="activity">Activity</option>
                        </select>
                    </div>
                    
                    <div class="form-group mb-3" id="editTaskSelectGroup" style="display: none;">
                        <label for="editIdtask" class="form-label">Select Task</label>
                        <select class="form-control" id="editIdtask" name="idtask">
                            <option value="0">Select a task</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Update Reminder
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Task data for JavaScript
    const todoItems = [
        <%
        if (todoItemList != null) {
            for (int i = 0; i < todoItemList.size(); i++) {
                ToDoItem todo = todoItemList.get(i);
        %>
            {id: <%= todo.getId() %>, title: "<%= todo.getTitle().replace("\"", "\\\"") %>"}
            <%= i < todoItemList.size() - 1 ? "," : "" %>
        <%
            }
        }
        %>
    ];
    
    const activities = [
        <%
        if (activityList != null) {
            for (int i = 0; i < activityList.size(); i++) {
                Activity activity = activityList.get(i);
        %>
            {id: <%= activity.getId() %>, title: "<%= activity.getTitle().replace("\"", "\\\"") %>"}
            <%= i < activityList.size() - 1 ? "," : "" %>
        <%
            }
        }
        %>
    ];

    // Set default time to now + 1 hour
    document.addEventListener('DOMContentLoaded', function() {
        // SweetAlert2 is now available for delete confirmations
        console.log('Reminder page loaded successfully');
    });
    
    function showAddModalReminder() {
        // Reset form
        document.getElementById('message').value = '';
        document.getElementById('type').value = '';
        document.getElementById('idtask').value = '0';
        document.getElementById('taskSelectGroup').style.display = 'none';
        
        // Set default time to now + 1 hour
        const now = new Date();
        now.setHours(now.getHours() + 1);
        const formattedDate = now.toISOString().slice(0, 16);
        document.getElementById('time').value = formattedDate;
        
        const modal = new bootstrap.Modal(document.getElementById('addReminderModal'));
        modal.show();
    }
    
    function deleteReminder(id) {
        Swal.fire({
            title: 'Are you sure?',
            text: "You won't be able to revert this!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Yes, delete it!',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = 'DeleteReminderServlet?id=' + id;
            }
        });
    }
    
    function editReminder(id, time, message, type, idtask) {
        document.getElementById('editId').value = id;
        document.getElementById('editTime').value = time;
        document.getElementById('editMessage').value = message;
        document.getElementById('editType').value = type || '';
        
        // Update task options based on type
        updateEditTaskOptions();
        
        // Set selected task if exists
        if (idtask > 0) {
            setTimeout(() => {
                document.getElementById('editIdtask').value = idtask;
            }, 100);
        }
        
        const modal = new bootstrap.Modal(document.getElementById('editReminderModal'));
        modal.show();
    }
    
    function updateTaskOptions() {
        const typeSelect = document.getElementById('type');
        const taskSelect = document.getElementById('idtask');
        const taskSelectGroup = document.getElementById('taskSelectGroup');
        const selectedType = typeSelect.value;
        
        if (!selectedType) {
            taskSelectGroup.style.display = 'none';
            taskSelect.value = '0';
            return;
        }
        
        taskSelectGroup.style.display = 'block';
        taskSelect.innerHTML = '<option value="0">Select a task</option>';
        
        if (selectedType === 'todoitem') {
            todoItems.forEach(todo => {
                const optionElement = document.createElement('option');
                optionElement.value = todo.id;
                optionElement.textContent = todo.title;
                taskSelect.appendChild(optionElement);
            });
        } else if (selectedType === 'activity') {
            activities.forEach(activity => {
                const optionElement = document.createElement('option');
                optionElement.value = activity.id;
                optionElement.textContent = activity.title;
                taskSelect.appendChild(optionElement);
            });
        }
    }
    
    function updateEditTaskOptions() {
        const typeSelect = document.getElementById('editType');
        const taskSelect = document.getElementById('editIdtask');
        const taskSelectGroup = document.getElementById('editTaskSelectGroup');
        const selectedType = typeSelect.value;
        
        if (!selectedType) {
            taskSelectGroup.style.display = 'none';
            return;
        }
        
        taskSelectGroup.style.display = 'block';
        taskSelect.innerHTML = '<option value="0">Select a task</option>';
        
        if (selectedType === 'todoitem') {
            todoItems.forEach(todo => {
                const optionElement = document.createElement('option');
                optionElement.value = todo.id;
                optionElement.textContent = todo.title;
                taskSelect.appendChild(optionElement);
            });
        } else if (selectedType === 'activity') {
            activities.forEach(activity => {
                const optionElement = document.createElement('option');
                optionElement.value = activity.id;
                optionElement.textContent = activity.title;
                taskSelect.appendChild(optionElement);
            });
        }
    }
</script>
