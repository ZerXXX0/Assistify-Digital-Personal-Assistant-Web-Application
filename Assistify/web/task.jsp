<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.ToDoItem"%>
<%@page import="model.Activity"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>

<!-- Page Header -->
<div class="page-header">
    <div class="page-title-section">
        <h1>
            <i class="fas fa-tasks"></i>
            Tasks & Activities
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
List<ToDoItem> todoItems = (List<ToDoItem>) request.getAttribute("todoItems");
@SuppressWarnings("unchecked")
List<Activity> activities = (List<Activity>) request.getAttribute("activities");
SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd");

// Get today and tomorrow dates
Calendar cal = Calendar.getInstance();
Date today = cal.getTime();
cal.add(Calendar.DAY_OF_MONTH, 1);
Date tomorrow = cal.getTime();

// Helper method to check if date is today
java.util.function.Function<Date, Boolean> isToday = (date) -> {
    Calendar dateCal = Calendar.getInstance();
    dateCal.setTime(date);
    Calendar todayCal = Calendar.getInstance();
    todayCal.setTime(today);
    return dateCal.get(Calendar.YEAR) == todayCal.get(Calendar.YEAR) &&
           dateCal.get(Calendar.DAY_OF_YEAR) == todayCal.get(Calendar.DAY_OF_YEAR);
};

// Helper method to check if date is tomorrow
java.util.function.Function<Date, Boolean> isTomorrow = (date) -> {
    Calendar dateCal = Calendar.getInstance();
    dateCal.setTime(date);
    Calendar tomorrowCal = Calendar.getInstance();
    tomorrowCal.setTime(tomorrow);
    return dateCal.get(Calendar.YEAR) == tomorrowCal.get(Calendar.YEAR) &&
           dateCal.get(Calendar.DAY_OF_YEAR) == tomorrowCal.get(Calendar.DAY_OF_YEAR);
};

// Separate todos by time
List<ToDoItem> todayTodos = new ArrayList<>();
List<ToDoItem> tomorrowTodos = new ArrayList<>();
List<ToDoItem> otherTodos = new ArrayList<>();

if (todoItems != null) {
    for (ToDoItem todo : todoItems) {
        if (isToday.apply(todo.getDueDate())) {
            todayTodos.add(todo);
        } else if (isTomorrow.apply(todo.getDueDate())) {
            tomorrowTodos.add(todo);
        } else {
            otherTodos.add(todo);
        }
    }
}

// Separate activities by time
List<Activity> todayActivities = new ArrayList<>();
List<Activity> tomorrowActivities = new ArrayList<>();
List<Activity> otherActivities = new ArrayList<>();

if (activities != null) {
    for (Activity activity : activities) {
        if (isToday.apply(activity.getStartTime())) {
            todayActivities.add(activity);
        } else if (isTomorrow.apply(activity.getStartTime())) {
            tomorrowActivities.add(activity);
        } else {
            otherActivities.add(activity);
        }
    }
}
%>

<!-- Tasks Container with Two Columns -->
<div class="notes-container">
    <!-- To-Do Items Column -->
    <div class="notes-column">
        <div class="section-title">
            <i class="fas fa-check-circle section-icon"></i>
            To-Do Items
        </div>
        
        <!-- Today's Todos -->
        <% if (!todayTodos.isEmpty()) { %>
            <div class="time-section-header">
                <i class="fas fa-sun"></i> Today
            </div>
            <div class="task-grid">
                <% for (ToDoItem todo : todayTodos) { %>
                    <div class="task-card <%= todo.isCompleted() ? "completed" : "" %>">
                        <div class="task-actions">
                            <button class="action-btn edit-btn" onclick="editTodoItem(<%= todo.getId() %>, '<%= todo.getTitle().replace("'", "\\'") %>', '<%= todo.getDueDate() %>', <%= todo.getPriority() %>, <%= todo.isCompleted() %>)">
                                <i class="fas fa-pencil-alt"></i>
                            </button>
                            <button class="action-btn delete-btn" onclick="deleteTask(<%= todo.getId() %>, 'todoitem')">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </div>
                        <div class="task-header">
                            <input type="checkbox" class="task-checkbox" <%= todo.isCompleted() ? "checked" : "" %> onchange="toggleComplete(<%= todo.getId() %>, this.checked)">
                            <div class="task-title <%= todo.isCompleted() ? "completed" : "" %>"><%= todo.getTitle() %></div>
                        </div>
                        <div class="task-meta">
                            <div class="task-time">
                                <i class="fas fa-clock"></i> <%= timeFormat.format(todo.getDueDate()) %>
                            </div>
                            <div class="task-priority <%= todo.getPriority() >= 8 ? "priority-high" : todo.getPriority() >= 5 ? "priority-medium" : "priority-low" %>">
                                P<%= todo.getPriority() %>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
        
        <!-- Tomorrow's Todos -->
        <% if (!tomorrowTodos.isEmpty()) { %>
            <div class="time-section-header">
                <i class="fas fa-calendar-day"></i> Tomorrow
            </div>
            <div class="task-grid">
                <% for (ToDoItem todo : tomorrowTodos) { %>
                    <div class="task-card <%= todo.isCompleted() ? "completed" : "" %>">
                        <div class="task-actions">
                            <button class="action-btn edit-btn" onclick="editTodoItem(<%= todo.getId() %>, '<%= todo.getTitle().replace("'", "\\'") %>', '<%= todo.getDueDate() %>', <%= todo.getPriority() %>, <%= todo.isCompleted() %>)">
                                <i class="fas fa-pencil-alt"></i>
                            </button>
                            <button class="action-btn delete-btn" onclick="deleteTask(<%= todo.getId() %>, 'todoitem')">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </div>
                        <div class="task-header">
                            <input type="checkbox" class="task-checkbox" <%= todo.isCompleted() ? "checked" : "" %> onchange="toggleComplete(<%= todo.getId() %>, this.checked)">
                            <div class="task-title <%= todo.isCompleted() ? "completed" : "" %>"><%= todo.getTitle() %></div>
                        </div>
                        <div class="task-meta">
                            <div class="task-time">
                                <i class="fas fa-clock"></i> <%= timeFormat.format(todo.getDueDate()) %>
                            </div>
                            <div class="task-priority <%= todo.getPriority() >= 8 ? "priority-high" : todo.getPriority() >= 5 ? "priority-medium" : "priority-low" %>">
                                P<%= todo.getPriority() %>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
        
        <!-- Other Todos -->
        <% if (!otherTodos.isEmpty()) { %>
            <div class="time-section-header">
                <i class="fas fa-calendar-alt"></i> Other
            </div>
            <div class="task-grid">
                <% for (ToDoItem todo : otherTodos) { %>
                    <div class="task-card <%= todo.isCompleted() ? "completed" : "" %>">
                        <div class="task-actions">
                            <button class="action-btn edit-btn" onclick="editTodoItem(<%= todo.getId() %>, '<%= todo.getTitle().replace("'", "\\'") %>', '<%= todo.getDueDate() %>', <%= todo.getPriority() %>, <%= todo.isCompleted() %>)">
                                <i class="fas fa-pencil-alt"></i>
                            </button>
                            <button class="action-btn delete-btn" onclick="deleteTask(<%= todo.getId() %>, 'todoitem')">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </div>
                        <div class="task-header">
                            <input type="checkbox" class="task-checkbox" <%= todo.isCompleted() ? "checked" : "" %> onchange="toggleComplete(<%= todo.getId() %>, this.checked)">
                            <div class="task-title <%= todo.isCompleted() ? "completed" : "" %>"><%= todo.getTitle() %></div>
                        </div>
                        <div class="task-meta">
                            <div class="task-time">
                                <i class="fas fa-calendar"></i> <%= dateFormat.format(todo.getDueDate()) %> <%= timeFormat.format(todo.getDueDate()) %>
                            </div>
                            <div class="task-priority <%= todo.getPriority() >= 8 ? "priority-high" : todo.getPriority() >= 5 ? "priority-medium" : "priority-low" %>">
                                P<%= todo.getPriority() %>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
        
        <!-- Empty State for Todos -->
        <% if (todoItems == null || todoItems.isEmpty()) { %>
            <div class="empty-state">
                <i class="fas fa-tasks fa-3x"></i>
                <h3>No To-Do Items Yet</h3>
                <p>Create your first task to get started</p>
                <button class="btn btn-primary mt-3" onclick="showAddModalType('todo')">
                    <i class="fas fa-plus"></i> Add To-Do Item
                </button>
            </div>
        <% } %>
    </div>
    
    <!-- Activities Column -->
    <div class="notes-column">
        <div class="section-title">
            <i class="fas fa-calendar-check section-icon"></i>
            Activities
        </div>
        
        <!-- Today's Activities -->
        <% if (!todayActivities.isEmpty()) { %>
            <div class="time-section-header">
                <i class="fas fa-sun"></i> Today
            </div>
            <div class="task-grid">
                <% for (Activity activity : todayActivities) { %>
                    <div class="task-card activity-card">
                        <div class="task-actions">
                            <button class="action-btn edit-btn" onclick="editActivity(<%= activity.getId() %>, '<%= activity.getTitle().replace("'", "\\'") %>', '<%= activity.getDescription() != null ? activity.getDescription().replace("'", "\\'") : "" %>', '<%= activity.getStartTime() %>', '<%= activity.getEndTime() != null ? activity.getEndTime() : "" %>')">
                                <i class="fas fa-pencil-alt"></i>
                            </button>
                            <button class="action-btn delete-btn" onclick="deleteTask(<%= activity.getId() %>, 'activity')">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </div>
                        <div class="task-title"><%= activity.getTitle() %></div>
                        <% if (activity.getDescription() != null && !activity.getDescription().trim().isEmpty()) { %>
                            <div class="task-description"><%= activity.getDescription() %></div>
                        <% } %>
                        <div class="task-meta">
                            <div class="task-time">
                                <i class="fas fa-play"></i> <%= timeFormat.format(activity.getStartTime()) %>
                                <% if (activity.getEndTime() != null) { %>
                                    - <%= timeFormat.format(activity.getEndTime()) %>
                                <% } %>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
        
        <!-- Tomorrow's Activities -->
        <% if (!tomorrowActivities.isEmpty()) { %>
            <div class="time-section-header">
                <i class="fas fa-calendar-day"></i> Tomorrow
            </div>
            <div class="task-grid">
                <% for (Activity activity : tomorrowActivities) { %>
                    <div class="task-card activity-card">
                        <div class="task-actions">
                            <button class="action-btn edit-btn" onclick="editActivity(<%= activity.getId() %>, '<%= activity.getTitle().replace("'", "\\'") %>', '<%= activity.getDescription() != null ? activity.getDescription().replace("'", "\\'") : "" %>', '<%= activity.getStartTime() %>', '<%= activity.getEndTime() != null ? activity.getEndTime() : "" %>')">
                                <i class="fas fa-pencil-alt"></i>
                            </button>
                            <button class="action-btn delete-btn" onclick="deleteTask(<%= activity.getId() %>, 'activity')">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </div>
                        <div class="task-title"><%= activity.getTitle() %></div>
                        <% if (activity.getDescription() != null && !activity.getDescription().trim().isEmpty()) { %>
                            <div class="task-description"><%= activity.getDescription() %></div>
                        <% } %>
                        <div class="task-meta">
                            <div class="task-time">
                                <i class="fas fa-play"></i> <%= timeFormat.format(activity.getStartTime()) %>
                                <% if (activity.getEndTime() != null) { %>
                                    - <%= timeFormat.format(activity.getEndTime()) %>
                                <% } %>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
        
        <!-- Other Activities -->
        <% if (!otherActivities.isEmpty()) { %>
            <div class="time-section-header">
                <i class="fas fa-calendar-alt"></i> Other
            </div>
            <div class="task-grid">
                <% for (Activity activity : otherActivities) { %>
                    <div class="task-card activity-card">
                        <div class="task-actions">
                            <button class="action-btn edit-btn" onclick="editActivity(<%= activity.getId() %>, '<%= activity.getTitle().replace("'", "\\'") %>', '<%= activity.getDescription() != null ? activity.getDescription().replace("'", "\\'") : "" %>', '<%= activity.getStartTime() %>', '<%= activity.getEndTime() != null ? activity.getEndTime() : "" %>')">
                                <i class="fas fa-pencil-alt"></i>
                            </button>
                            <button class="action-btn delete-btn" onclick="deleteTask(<%= activity.getId() %>, 'activity')">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </div>
                        <div class="task-title"><%= activity.getTitle() %></div>
                        <% if (activity.getDescription() != null && !activity.getDescription().trim().isEmpty()) { %>
                            <div class="task-description"><%= activity.getDescription() %></div>
                        <% } %>
                        <div class="task-meta">
                            <div class="task-time">
                                <i class="fas fa-calendar"></i> <%= dateFormat.format(activity.getStartTime()) %> <%= timeFormat.format(activity.getStartTime()) %>
                                <% if (activity.getEndTime() != null) { %>
                                    - <%= timeFormat.format(activity.getEndTime()) %>
                                <% } %>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
        
        <!-- Empty State for Activities -->
        <% if (activities == null || activities.isEmpty()) { %>
            <div class="empty-state">
                <i class="fas fa-calendar-check fa-3x"></i>
                <h3>No Activities Yet</h3>
                <p>Schedule your first activity to get started</p>
                <button class="btn btn-primary mt-3" onclick="showAddModalType('activity')">
                    <i class="fas fa-plus"></i> Add Activity
                </button>
            </div>
        <% } %>
    </div>
</div>

<!-- Floating Add Button -->
<button class="floating-add-btn" onclick="showAddTaskModal()">
    <i class="fas fa-plus"></i>
</button>

<!-- Add Task Modal -->
<div class="modal fade" id="addTaskModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-plus"></i> Add New Task
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-6">
                        <button class="btn btn-primary w-100 mb-3" onclick="showAddTodoModal()">
                            <i class="fas fa-tasks d-block mb-2"></i>
                            To-Do Item
                        </button>
                    </div>
                    <div class="col-6">
                        <button class="btn btn-primary w-100 mb-3" onclick="showAddActivityModal()">
                            <i class="fas fa-calendar-check d-block mb-2"></i>
                            Activity
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add Todo Modal -->
<div class="modal fade" id="addTodoModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-plus"></i> Add To-Do Item
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="AddTaskServlet" method="post">
                <div class="modal-body">
                    <input type="hidden" name="type" value="todoitem">
                    <div class="form-group">
                        <label for="addTodoTitle" class="form-label">Title</label>
                        <input type="text" class="form-control" id="addTodoTitle" name="title" placeholder="Task title" required>
                    </div>
                    <div class="form-group">
                        <label for="addTodoTime" class="form-label">Due Date & Time</label>
                        <input type="datetime-local" class="form-control" id="addTodoTime" name="dueDate" required>
                    </div>
                    <div class="form-group">
                        <label for="addTodoPriority" class="form-label">Priority (1-10)</label>
                        <input type="number" class="form-control" id="addTodoPriority" name="priority" min="1" max="10" placeholder="5" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Add To-Do Item</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Add Activity Modal -->
<div class="modal fade" id="addActivityModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-plus"></i> Add Activity
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="AddTaskServlet" method="post">
                <div class="modal-body">
                    <input type="hidden" name="type" value="activity">
                    <div class="form-group">
                        <label for="addActivityTitle" class="form-label">Title</label>
                        <input type="text" class="form-control" id="addActivityTitle" name="title" placeholder="Activity title" required>
                    </div>
                    <div class="form-group">
                        <label for="addActivityDescription" class="form-label">Description</label>
                        <textarea class="form-control" id="addActivityDescription" name="description" placeholder="Activity description"></textarea>
                    </div>
                    <div class="form-group">
                        <label for="addActivityStartTime" class="form-label">Start Time</label>
                        <input type="datetime-local" class="form-control" id="addActivityStartTime" name="startTime" required>
                    </div>
                    <div class="form-group">
                        <label for="addActivityEndTime" class="form-label">End Time (Optional)</label>
                        <input type="datetime-local" class="form-control" id="addActivityEndTime" name="endTime">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Add Activity</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Todo Item Modal -->
<div class="modal fade" id="editTodoModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-edit me-2"></i>Edit To-Do Item
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="EditTaskServlet" method="post">
                <div class="modal-body">
                    <input type="hidden" id="editTodoId" name="id">
                    <input type="hidden" name="type" value="todoitem">
                    <div class="form-group">
                        <label for="editTodoTitle" class="form-label">Title</label>
                        <input type="text" class="form-control" id="editTodoTitle" name="title" required>
                    </div>
                    <div class="form-group">
                        <label for="editTodoDueDate" class="form-label">Due Date</label>
                        <input type="datetime-local" class="form-control" id="editTodoDueDate" name="dueDate" required>
                    </div>
                    <div class="form-group">
                        <label for="editTodoPriority" class="form-label">Priority (1-10)</label>
                        <input type="number" class="form-control" id="editTodoPriority" name="priority" min="1" max="10" required>
                    </div>
                    <div class="form-group">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="editTodoCompleted" name="completed" value="true">
                            <label class="form-check-label" for="editTodoCompleted">
                                Mark as completed
                            </label>
                        </div>
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

<!-- Edit Activity Modal -->
<div class="modal fade" id="editActivityModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-edit me-2"></i>Edit Activity
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="EditTaskServlet" method="post">
                <div class="modal-body">
                    <input type="hidden" id="editActivityId" name="id">
                    <input type="hidden" name="type" value="activity">
                    <div class="form-group">
                        <label for="editActivityTitle" class="form-label">Title</label>
                        <input type="text" class="form-control" id="editActivityTitle" name="title" required>
                    </div>
                    <div class="form-group">
                        <label for="editActivityDescription" class="form-label">Description</label>
                        <textarea class="form-control" id="editActivityDescription" name="description" rows="3"></textarea>
                    </div>
                    <div class="form-group">
                        <label for="editActivityStartTime" class="form-label">Start Time</label>
                        <input type="datetime-local" class="form-control" id="editActivityStartTime" name="startTime" required>
                    </div>
                    <div class="form-group">
                        <label for="editActivityEndTime" class="form-label">End Time</label>
                        <input type="datetime-local" class="form-control" id="editActivityEndTime" name="endTime">
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

<!-- Include SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
function showAddTaskModal() {
    new bootstrap.Modal(document.getElementById('addTaskModal')).show();
}

function showAddModalType(type) {
    if (type === 'todo') {
        showAddTodoModal();
    } else if (type === 'activity') {
        showAddActivityModal();
    } else {
        showAddTaskModal();
    }
}

function showAddTodoModal() {
    // Close the main add task modal if open
    const addTaskModal = bootstrap.Modal.getInstance(document.getElementById('addTaskModal'));
    if (addTaskModal) {
        addTaskModal.hide();
    }
    
    // Set default time
    const now = new Date();
    now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
    document.getElementById('addTodoTime').value = now.toISOString().slice(0, 16);
    
    new bootstrap.Modal(document.getElementById('addTodoModal')).show();
}

function showAddActivityModal() {
    // Close the main add task modal if open
    const addTaskModal = bootstrap.Modal.getInstance(document.getElementById('addTaskModal'));
    if (addTaskModal) {
        addTaskModal.hide();
    }
    
    // Set default time
    const now = new Date();
    now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
    document.getElementById('addActivityStartTime').value = now.toISOString().slice(0, 16);
    
    new bootstrap.Modal(document.getElementById('addActivityModal')).show();
}

function editTodoItem(id, title, dueDate, priority, completed) {
    document.getElementById('editTodoId').value = id;
    document.getElementById('editTodoTitle').value = title;
    document.getElementById('editTodoDueDate').value = dueDate.replace(' ', 'T').substring(0, 16);
    document.getElementById('editTodoPriority').value = priority;
    document.getElementById('editTodoCompleted').checked = completed;
    
    new bootstrap.Modal(document.getElementById('editTodoModal')).show();
}

function editActivity(id, title, description, startTime, endTime) {
    document.getElementById('editActivityId').value = id;
    document.getElementById('editActivityTitle').value = title;
    document.getElementById('editActivityDescription').value = description;
    document.getElementById('editActivityStartTime').value = startTime.replace(' ', 'T').substring(0, 16);
    if (endTime && endTime !== 'null') {
        document.getElementById('editActivityEndTime').value = endTime.replace(' ', 'T').substring(0, 16);
    }
    
    new bootstrap.Modal(document.getElementById('editActivityModal')).show();
}

function deleteTask(id, type) {
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
            window.location.href = 'DeleteTaskServlet?id=' + id + '&type=' + type;
        }
    });
}

function toggleComplete(id, isCompleted) {
    window.location.href = 'ToggleTaskServlet?id=' + id + '&completed=' + isCompleted;
}
</script>
