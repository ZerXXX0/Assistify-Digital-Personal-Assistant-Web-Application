<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="config.DB"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Calendar"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Digital Assistant</title>
    <!-- Bootstrap 5.0.2 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <!-- Google Fonts - Montserrat -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>   
    <%
    // Get user notification settings
    Integer userIdObj = (Integer) session.getAttribute("userId");
    if (userIdObj == null) {
        response.sendRedirect("login_page.jsp");
        return;
    }
    int userId = userIdObj.intValue();
    
    DB db = new DB();
    db.connect();
    
    int alarmSound = 1;
    int notificationSound = 1;
    
    try {
        // Get alarm sound setting
        String alarmQuery = "SELECT sound FROM notification_settings WHERE user_id = " + userId + " AND type = 'Alarm'";
        ResultSet alarmRs = db.getData(alarmQuery);
        if (alarmRs != null && alarmRs.next()) {
            alarmSound = alarmRs.getInt("sound");
        }
        
        // Get notification sound setting
        String notifQuery = "SELECT sound FROM notification_settings WHERE user_id = " + userId + " AND type = 'Notification'";
        ResultSet notifRs = db.getData(notifQuery);
        if (notifRs != null && notifRs.next()) {
            notificationSound = notifRs.getInt("sound");
        }
    } catch (Exception e) {
        System.err.println("Error getting notification settings: " + e.getMessage());
    } finally {
        db.disconnect();
    }
    %>
    
    <!-- Hidden data for JavaScript -->
    <div id="notificationData" 
         data-user-id="<%= userId %>"
         data-alarm-sound="<%= alarmSound %>"
         data-notification-sound="<%= notificationSound %>"
         style="display: none;"></div>
    
    <!-- Audio elements for notifications -->
    <audio id="alarmAudio" preload="none"></audio>
    <audio id="notificationAudio" preload="none"></audio>
    
    <!-- Sidebar -->
    <div class="sidebar">
        <!-- Add Button at the top -->
        <!-- <a href="#" class="nav-link" onclick="showAddModal()">
            <img src="assets/image/LogoAdd.png" alt="Add" class="sidebar-icon" id="add-icon">
        </a> -->
            
        <a href="HomeServlet" class="nav-link <%= (request.getParameter("page") == null || "home".equals(request.getParameter("page"))) ? "active" : "" %>">
            <img src="assets/image/LogoHome.png" alt="Home" class="sidebar-icon" id="home-icon">
        </a>
        
        <a href="AlarmServlet" class="nav-link <%= ("alarm".equals(request.getParameter("page"))) ? "active" : "" %>">
            <img src="assets/image/LogoAlarm.png" alt="Alarm" class="sidebar-icon" id="alarm-icon">
        </a>
        
        <a href="ReminderServlet" class="nav-link <%= ("reminder".equals(request.getParameter("page"))) ? "active" : "" %>">
            <img src="assets/image/LogoNotif.png" alt="Notification" class="sidebar-icon" id="notif-icon">
        </a>
        
        <a href="NoteServlet" class="nav-link <%= ("note".equals(request.getParameter("page"))) ? "active" : "" %>">
            <img src="assets/image/LogoNotes.png" alt="Notes" class="sidebar-icon" id="notes-icon">
        </a>
        
        <a href="TaskServlet" class="nav-link <%= ("task".equals(request.getParameter("page"))) ? "active" : "" %>">
            <img src="assets/image/LogoToDoList.png" alt="Tasks" class="sidebar-icon" id="task-icon">
        </a>
        
        <!-- JournalEntry button added below Tasks -->
        <a href="JournalEntryServlet" class="nav-link <%= ("journal".equals(request.getParameter("page"))) ? "active" : "" %>">
            <img src="assets/image/LogoJournal.png" alt="Journal" class="sidebar-icon" id="journal-icon">
        </a>
        
        <a href="HomeServlet?page=settings" class="settings-link">
            <img src="assets/image/LogoSetting.png" alt="Settings" class="sidebar-icon" id="settings-icon">
        </a>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Content Area -->
        <div class="content-area">
            <%
            String content = (String) request.getAttribute("content");
            String pageParam = request.getParameter("page");
            
            // Antisipasi
            if (content == null && pageParam != null) {
                content = pageParam;
            }
            %>
            <div class="form-container">
                <%
                if ("home".equals(content) || content == null){
                %>  
                <jsp:include page="home.jsp" flush="true"></jsp:include>
                <%
                } else if ("alarm".equals(content)){
                %>  
                <jsp:include page="alarm.jsp" flush="true"></jsp:include>
                <%
                } else if ("reminder".equals(content)){
                %>  
                <jsp:include page="reminder.jsp" flush="true"></jsp:include>
                <%
                } else if ("note".equals(content)){
                %>  
                <jsp:include page="note.jsp" flush="true"></jsp:include>
                <%
                } else if ("task".equals(content)){
                %>  
                <jsp:include page="task.jsp" flush="true"></jsp:include>
                <%
                } else if ("journal".equals(content)){
                %>  
                <jsp:include page="journal.jsp" flush="true"></jsp:include>
                <%
                } else if ("user".equals(content)){
                %>  
                <jsp:include page="user_profile.jsp" flush="true"></jsp:include>
                <%
                } else if ("settings".equals(content)){
                %>  
                <jsp:include page="settings.jsp" flush="true"></jsp:include>
                <%
                } else if ("edit_profile".equals(content)){
                %>  
                <jsp:include page="edit_profile.jsp" flush="true"></jsp:include>
                <%
                } else {
                %>  
                <jsp:include page="home.jsp" flush="true"></jsp:include>
                <%
                }
                %>  
            </div>
        </div>
    </div>

    <!-- Universal Add Modal -->
    <div class="modal fade" id="addModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-plus"></i> Add New Item
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <!-- Activity Card -->
                        <div class="col-md-6 mb-4">
                            <div class="add-card">
                                <h3 class="card-title">
                                    <i class="fas fa-calendar-check"></i> Add Activity
                                </h3>
                                <form action="AddTaskServlet" method="post">
                                    <input type="hidden" name="type" value="activity">
                                    <div class="form-group">
                                        <label for="activityTitle">Title</label>
                                        <input type="text" class="form-control" id="activityTitle" name="title" placeholder="Activity title" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="activityDescription">Description</label>
                                        <textarea class="form-control" id="activityDescription" name="description" placeholder="Activity description"></textarea>
                                    </div>
                                    <div class="form-group">
                                        <label for="activityStartTime">Start Time</label>
                                        <input type="datetime-local" class="form-control" id="activityStartTime" name="startTime" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="activityEndTime">End Time (Optional)</label>
                                        <input type="datetime-local" class="form-control" id="activityEndTime" name="endTime">
                                    </div>
                                    <button type="submit" class="btn btn-primary w-100">Add Activity</button>
                                </form>
                            </div>
                        </div>

                        <!-- To-Do Item Card -->
                        <div class="col-md-6 mb-4">
                            <div class="add-card">
                                <h3 class="card-title">
                                    <i class="fas fa-tasks"></i> Add To-Do Item
                                </h3>
                                <form action="AddTaskServlet" method="post">
                                    <input type="hidden" name="type" value="todoitem">
                                    <div class="form-group">
                                        <label for="todoTitle">Title</label>
                                        <input type="text" class="form-control" id="todoTitle" name="title" placeholder="Task title" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="todoTime">Due Date & Time</label>
                                        <input type="datetime-local" class="form-control" id="todoTime" name="dueDate" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="todoPriority">Priority (1-10)</label>
                                        <input type="number" class="form-control" id="todoPriority" name="priority" min="1" max="10" placeholder="5" required>
                                    </div>
                                    <button type="submit" class="btn btn-primary w-100">Add To-Do Item</button>
                                </form>
                            </div>
                        </div>

                        <!-- Alarm Card -->
                        <div class="col-md-6 mb-4">
                            <div class="add-card">
                                <h3 class="card-title">
                                    <i class="fa-solid fa-clock-rotate-left"></i> Add Alarm
                                </h3>
                                <form action="AddAlarmServlet" method="post">
                                    <div class="form-group">
                                        <label for="alarmTitle">Title</label>
                                        <input type="text" class="form-control" id="alarmTitle" name="title" placeholder="e.g. Wake up" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="alarmTime">Time</label>
                                        <input type="datetime-local" class="form-control" id="alarmTime" name="time" required>
                                    </div>
                                    <button type="submit" class="btn btn-primary w-100">Add Alarm</button>
                                </form>
                            </div>
                        </div>

                        <!-- Reminder Card -->
                        <div class="col-md-6 mb-4">
                            <div class="add-card">
                                <h3 class="card-title">
                                    <i class="fas fa-bell"></i> Add Reminder
                                </h3>
                                <form action="AddReminderServlet" method="post">
                                    <div class="form-group">
                                        <label for="reminderTime">Date & Time</label>
                                        <input type="datetime-local" class="form-control" id="reminderTime" name="time" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="reminderMessage">Message</label>
                                        <input type="text" class="form-control" id="reminderMessage" name="message" placeholder="Reminder message" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="reminderType">Link to Task (Optional)</label>
                                        <select class="form-control" id="reminderType" name="type">
                                            <option value="">No task linked</option>
                                            <option value="todoitem">To-Do Item</option>
                                            <option value="activity">Activity</option>
                                        </select>
                                    </div>
                                    <button type="submit" class="btn btn-primary w-100">Add Reminder</button>
                                </form>
                            </div>
                        </div>

                        <!-- Note Card -->
                        <div class="col-md-6 mb-4">
                            <div class="add-card">
                                <h3 class="card-title">
                                    <i class="fas fa-sticky-note"></i> Add Note
                                </h3>
                                <form action="AddNoteServlet" method="post">
                                    <input type="hidden" name="noteType" value="text">
                                    <div class="form-group">
                                        <label for="noteTitle">Title</label>
                                        <input type="text" class="form-control" id="noteTitle" name="title" placeholder="Note title" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="noteContent">Content</label>
                                        <textarea class="form-control" id="noteContent" name="textNote" rows="4" placeholder="Note content" required></textarea>
                                    </div>
                                    <button type="submit" class="btn btn-primary w-100">Add Note</button>
                                </form>
                            </div>
                        </div>

                        <!-- Journal Card -->
                        <div class="col-md-6 mb-4">
                            <div class="add-card">
                                <h3 class="card-title">
                                    <i class="fas fa-book"></i> Add Journal Entry
                                </h3>
                                <form action="AddJournalEntryServlet" method="post">
                                    <div class="form-group">
                                        <label for="journalTitle">Title (Optional)</label>
                                        <input type="text" class="form-control" id="journalTitle" name="title" placeholder="Journal title">
                                    </div>
                                    <div class="form-group">
                                        <label for="journalContent">Content</label>
                                        <textarea class="form-control" id="journalContent" name="content" rows="4" placeholder="What's on your mind?" required></textarea>
                                    </div>
                                    <button type="submit" class="btn btn-primary w-100">Add Journal Entry</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    <script>
        // Global variables for notification system
        let notificationData = {};
        let activeAlarms = [];
        let activeReminders = [];
        let checkInterval;
        
        // Initialize notification system
        document.addEventListener('DOMContentLoaded', function() {
            // Get notification settings from hidden div
            const dataDiv = document.getElementById('notificationData');
            if (dataDiv) {
                notificationData = {
                    userId: dataDiv.dataset.userId,
                    alarmSound: dataDiv.dataset.alarmSound,
                    notificationSound: dataDiv.dataset.notificationSound
                };
                
                console.log('Notification system initialized:', notificationData);
                
                // Start checking for active alarms and reminders
                startNotificationCheck();
            }
            
            // Handle success/error messages
            handleUrlMessages();
            
            // Add animation classes to cards
            animateCards();
        });
        
        // Start periodic checking for notifications
        function startNotificationCheck() {
            // Check immediately
            checkForNotifications();
            
            // Then check every 30 seconds
            checkInterval = setInterval(checkForNotifications, 30000);
        }
        
        // Check for active alarms and reminders
        function checkForNotifications() {
        const now = new Date();

        // Mengambil jam dan menit lokal
        const currentTime = now.getHours().toString().padStart(2, '0') + ':' +
                            now.getMinutes().toString().padStart(2, '0');

        // Mengambil tanggal lokal dengan metode Date yang lokal
        const year = now.getFullYear();
        const month = (now.getMonth() + 1).toString().padStart(2, '0');
        const day = now.getDate().toString().padStart(2, '0');

        // Log nilai individual sebelum penggabungan
        console.log("Year:", year);
        console.log("Month:", month);
        console.log("Day:", day);

        const currentDate = year + "-" + month + "-" + day;

        console.log('Checking notifications for:', currentDate, currentTime);
            
            // Check for alarms
            fetch('CheckActiveAlarmsServlet?userId=' + notificationData.userId + '&date=' + currentDate + '&time=' + currentTime)
                .then(response => response.json())
                .then(alarms => {
                    if (alarms && alarms.length > 0) {
                        alarms.forEach(alarm => {
                            if (!activeAlarms.includes(alarm.id)) {
                                showAlarmNotification(alarm);
                                activeAlarms.push(alarm.id);
                            }
                        });
                    }
                    console.log('CHECK:', alarms);
                    console.log('CHECK activeAlarms:', activeAlarms);
                    console.log('CheckActiveAlarmsServlet?userId=' + notificationData.userId + '&date=' + currentDate + '&time=' + currentTime);
                })
                .catch(error => console.error('Error checking alarms:', error));
            
            // Check for reminders
            fetch('CheckActiveRemindersServlet?userId=' + notificationData.userId + '&date=' + currentDate + '&time=' + currentTime)
                .then(response => response.json())
                .then(reminders => {
                    if (reminders && reminders.length > 0) {
                        reminders.forEach(reminder => {
                            if (!activeReminders.includes(reminder.id)) {
                                showReminderNotification(reminder);
                                activeReminders.push(reminder.id);
                            }
                        });
                    }
                    console.log('CHECK:', reminders);
                    console.log('CHECK activeReminders:', activeReminders);
                    console.log('CheckActiveRemindersServlet?userId=' + notificationData.userId + '&date=' + currentDate + '&time=' + currentTime);
                })
                .catch(error => console.error('Error checking reminders:', error));
        }
        
        // Show alarm notification with sound
        function showAlarmNotification(alarm) {
            console.log('Showing alarm notification:', alarm);
            
            // Play alarm sound
            playAlarmSound();
            
            Swal.fire({
                title: '⏰ Alarm!',
                html: '<div class="text-center">' +
                      '<i class="fas fa-alarm-clock fa-3x text-danger mb-3"></i>' +
                      '<h4>' + alarm.title + '</h4>' +
                      '<p class="text-muted">' + formatTime(alarm.time) + '</p>' +
                      '</div>',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Dismiss',
                cancelButtonText: 'Snooze (5 min)',
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                allowOutsideClick: false,
                allowEscapeKey: false,
                customClass: {
                    popup: 'alarm-popup'
                }
            }).then((result) => {
                stopAlarmSound();
                if (result.isDismissed && result.dismiss === Swal.DismissReason.cancel) {
                    // Snooze for 5 minutes
                    snoozeAlarm(alarm.id, 5);
                } else {
                    // Mark as dismissed
                    dismissAlarm(alarm.id);
                }
            });
        }
        
        // Show reminder notification with sound
        function showReminderNotification(reminder) {
            console.log('Showing reminder notification:', reminder);
            
            // Play notification sound
            playNotificationSound();
            
            Swal.fire({
                title: '🔔 Reminder',
                html: '<div class="text-center">' +
                      '<i class="fas fa-bell fa-3x text-primary mb-3"></i>' +
                      '<h4>' + reminder.message + '</h4>' +
                      '<p class="text-muted">' + formatTime(reminder.time) + '</p>' +
                      (reminder.type ? '<small class="badge bg-secondary">' + reminder.type + '</small>' : '') +
                      '</div>',
                icon: 'info',
                confirmButtonText: 'Got it!',
                confirmButtonColor: '#0d6efd',
                timer: 10000,
                timerProgressBar: true,
                customClass: {
                    popup: 'reminder-popup'
                }
            }).then(() => {
                stopNotificationSound();
                markReminderAsShown(reminder.id);
            });
        }
        
        // Play alarm sound
        function playAlarmSound() {
            const audio = document.getElementById('alarmAudio');
            audio.src = 'assets/sound/alarm/' + notificationData.alarmSound + '.mp3';
            audio.loop = true;
            audio.play().catch(e => console.error('Error playing alarm sound:', e));
        }
        
        // Play notification sound
        function playNotificationSound() {
            const audio = document.getElementById('notificationAudio');
            audio.src = 'assets/sound/notif/' + notificationData.notificationSound + '.mp3';
            audio.loop = false;
            audio.play().catch(e => console.error('Error playing notification sound:', e));
        }
        
        // Stop alarm sound
        function stopAlarmSound() {
            const audio = document.getElementById('alarmAudio');
            audio.pause();
            audio.currentTime = 0;
        }
        
        // Stop notification sound
        function stopNotificationSound() {
            const audio = document.getElementById('notificationAudio');
            audio.pause();
            audio.currentTime = 0;
        }
        
        // Snooze alarm
        function snoozeAlarm(alarmId, minutes) {
            fetch('SnoozeAlarmServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'alarmId=' + alarmId + '&minutes=' + minutes
            }).then(() => {
                // Remove from active alarms so it can trigger again
                activeAlarms = activeAlarms.filter(id => id !== alarmId);
                
                Swal.fire({
                    icon: 'success',
                    title: 'Alarm Snoozed',
                    text: 'Alarm will ring again in ' + minutes + ' minutes',
                    timer: 2000,
                    showConfirmButton: false
                });
            });
        }

        // Dismiss alarm
        function dismissAlarm(alarmId) {
            fetch('DismissAlarmServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'alarmId=' + alarmId
            }).then(() => {
                Swal.fire({
                    icon: 'success',
                    title: 'Alarm Dismissed',
                    text: 'The alarm has been successfully dismissed.',
                    timer: 2000,
                    showConfirmButton: false
                });
            });
        }

        // Mark reminder as shown
        function markReminderAsShown(reminderId) {
            fetch('MarkReminderShownServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'reminderId=' + reminderId
            }).then(() => {
                Swal.fire({
                    icon: 'success',
                    title: 'Reminder Marked',
                    text: 'The reminder has been marked as shown.',
                    timer: 2000,
                    showConfirmButton: false
                });
            });
        }
        
        // Format time for display
        function formatTime(timeString) {
            const date = new Date(timeString);
            return date.toLocaleTimeString('en-US', {
                hour: '2-digit',
                minute: '2-digit',
                hour12: true
            });
        }
        
        // Sidebar icon hover effects
        // document.getElementById("add-icon").onmouseover = function() {
        //     this.src = "assets/image/LogoAddHover.png";
        // };
        // document.getElementById("add-icon").onmouseout = function() {
        //     this.src = "assets/image/LogoAdd.png";
        // };
        
        document.getElementById("home-icon").onmouseover = function() {
            this.src = "assets/image/HomeHover.png";
        };
        document.getElementById("home-icon").onmouseout = function() {
            this.src = "assets/image/LogoHome.png";
        };
        
        document.getElementById("alarm-icon").onmouseover = function() {
            this.src = "assets/image/AlarmHover.png";
        };
        document.getElementById("alarm-icon").onmouseout = function() {
            this.src = "assets/image/LogoAlarm.png";
        };

        document.getElementById("notif-icon").onmouseover = function() {
            this.src = "assets/image/NotifHover.png";
        };
        document.getElementById("notif-icon").onmouseout = function() {
            this.src = "assets/image/LogoNotif.png";
        };
        
        document.getElementById("notes-icon").onmouseover = function() {
            this.src = "assets/image/NotesHover.png";
        };
        document.getElementById("notes-icon").onmouseout = function() {
            this.src = "assets/image/LogoNotes.png";
        };

        document.getElementById("task-icon").onmouseover = function() {
            this.src = "assets/image/ToDoListHover.png";
        };
        document.getElementById("task-icon").onmouseout = function() {
            this.src = "assets/image/LogoToDoList.png";
        };

        document.getElementById("journal-icon").onmouseover = function() {
            this.src = "assets/image/JournalHover.png";
        };
        document.getElementById("journal-icon").onmouseout = function() {
            this.src = "assets/image/LogoJournal.png";
        };

        document.getElementById("settings-icon").onmouseover = function() {
            this.src = "assets/image/SettingHover.png";
        };
        document.getElementById("settings-icon").onmouseout = function() {
            this.src = "assets/image/LogoSetting.png";
        };

        // Show add modal
        // function showAddModal() {
        //     // Set default times
        //     const now = new Date();
        //     now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
        //     const defaultTime = now.toISOString().slice(0, 16);
            
        //     document.getElementById('activityStartTime').value = defaultTime;
        //     document.getElementById('todoTime').value = defaultTime;
        //     document.getElementById('alarmTime').value = defaultTime;
        //     document.getElementById('reminderTime').value = defaultTime;
            
        //     var addModal = new bootstrap.Modal(document.getElementById('addModal'));
        //     addModal.show();
        // }

        // Handle success/error messages with SweetAlert2
        function handleUrlMessages() {
            const urlParams = new URLSearchParams(window.location.search);
            const success = urlParams.get('success');
            const error = urlParams.get('error');

            if (success) {
                Swal.fire({
                    icon: 'success',
                    title: 'Success!',
                    text: success,
                    timer: 3000,
                    showConfirmButton: false
                });
            }

            if (error) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error!',
                    text: error,
                    timer: 3000,
                    showConfirmButton: false
                });
            }
        }
        
        // Add animation classes to cards on load
        function animateCards() {
            const cards = document.querySelectorAll('.dashboard-card, .add-card');
            cards.forEach((card, index) => {
                setTimeout(() => {
                    card.classList.add('fade-in');
                }, index * 100);
            });
        }
        
        // Cleanup when page unloads
        window.addEventListener('beforeunload', function() {
            if (checkInterval) {
                clearInterval(checkInterval);
            }
            stopAlarmSound();
            stopNotificationSound();
        });
    </script>
    
    <style>
        .alarm-popup {
            animation: shake 0.5s ease-in-out infinite alternate;
        }
        
        @keyframes shake {
            0% { transform: translateX(0); }
            100% { transform: translateX(5px); }
        }
        
        .reminder-popup {
            animation: fadeInBounce 0.5s ease-out;
        }
        
        @keyframes fadeInBounce {
            0% { opacity: 0; transform: scale(0.3); }
            50% { opacity: 1; transform: scale(1.05); }
            100% { opacity: 1; transform: scale(1); }
        }
    </style>
</body>
</html>
