<%-- Alarm Content Only --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Alarm"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>

<!-- Page Header -->
<div class="page-header">
    <div class="page-title-section">
        <h1>
            <i class="fa-solid fa-clock-rotate-left"></i>
            Alarms
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
List<Alarm> alarmList = (List<Alarm>) request.getAttribute("alarmList");
if (alarmList != null && !alarmList.isEmpty()) {
%>
    <div class="alarm-grid">
    <%
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
        SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, dd MMM yyyy");
        for (Alarm alarm : alarmList) {
    %>
        <div class="alarm-card">
            <div class="action-buttons">
                <button class="action-btn edit-btn" onclick="editAlarm(<%= alarm.getId() %>, '<%= alarm.getTitle().replace("'", "\\'") %>', '<%= alarm.getTimeAsDateTime() %>', '<%= alarm.getStatus() %>')">
                    <i class="fas fa-edit"></i>
                </button>
                <button class="action-btn delete-btn" onclick="deleteAlarm(<%= alarm.getId() %>)">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
            <div class="alarm-title"><%= alarm.getTitle() %></div>
            <div class="alarm-time"><%= timeFormat.format(alarm.getTime()) %></div>
            <div class="alarm-date"><%= dateFormat.format(alarm.getTime()) %></div>
        </div>
    <%
        }
    %>
    </div>
<%
} else {
%>
    <div class="empty-state">
        <i class="fas fa-clock fa-3x mb-3"></i>
        <h3>No alarms set</h3>
        <p>Add your first alarm to get started!</p>
        <button class="btn btn-primary btn-lg" onclick="showAddAlarmModal()">
            <i class="fas fa-plus"></i> Add Your First Alarm
        </button>
    </div>
<%
}
%>

<!-- Floating Add Button -->
<button class="floating-add-btn" onclick="showAddAlarmModal()">
    <i class="fas fa-plus"></i>
</button>

<!-- Add Alarm Modal -->
<div class="modal fade" id="addAlarmModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-plus"></i> Add New Alarm
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="AddAlarmServlet" method="post">
                <div class="modal-body">
                    <div class="form-group">
                        <label for="addAlarmTitle" class="form-label">Title</label>
                        <input type="text" class="form-control" id="addAlarmTitle" name="title" placeholder="e.g. Wake up" required>
                    </div>
                    <div class="form-group">
                        <label for="addAlarmTime" class="form-label">Time</label>
                        <input type="datetime-local" class="form-control" id="addAlarmTime" name="time" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Add Alarm</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Alarm Modal -->
<div class="modal fade" id="editAlarmModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-edit"></i> Edit Alarm
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="EditAlarmServlet" method="post">
                <div class="modal-body">
                    <input type="hidden" id="editAlarmId" name="id">
                    <div class="form-group">
                        <label for="editAlarmTitle" class="form-label">Title</label>
                        <input type="text" class="form-control" id="editAlarmTitle" name="title" required>
                    </div>
                    <div class="form-group">
                        <label for="editAlarmTime" class="form-label">Time</label>
                        <input type="datetime-local" class="form-control" id="editAlarmTime" name="time" required>
                    </div>
                    <div class="form-group">
                        <label for="editAlarmStatus" class="form-label">Status</label>
                        <select class="form-control" id="editAlarmStatus" name="status" required>
                            <option value="active">Active</option>
                            <option value="inactive">Inactive</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function showAddAlarmModal() {
    // Set default time to current time
    const now = new Date();
    now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
    document.getElementById('addAlarmTime').value = now.toISOString().slice(0, 16);
    
    new bootstrap.Modal(document.getElementById('addAlarmModal')).show();
}

function editAlarm(id, title, time, status) {
    document.getElementById('editAlarmId').value = id;
    document.getElementById('editAlarmTitle').value = title;
    document.getElementById('editAlarmTime').value = time.replace(' ', 'T').substring(0, 16);
    document.getElementById('editAlarmStatus').value = status;
    new bootstrap.Modal(document.getElementById('editAlarmModal')).show();
}

function deleteAlarm(id) {
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
            window.location.href = 'DeleteAlarmServlet?id=' + id;
        }
    });
}
</script>
