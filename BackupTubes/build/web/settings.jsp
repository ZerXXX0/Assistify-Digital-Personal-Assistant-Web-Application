<%-- 
    Document   : settings
    Created on : May 30, 2025, 9:43:32 AM
    Author     : Fathan Fardian Sanum
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings - Digital Assistant</title>
    <!-- Bootstrap 5.0.2 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <!-- Google Fonts - Montserrat -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: url('assets/IMG_6703.jpg') no-repeat center center fixed;
            background-size: cover;
            color: white;
            position: relative;
            margin: 0;
            font-family: 'Montserrat', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            width: 80px;
            background-color: #FF3B65;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-top: 20px;
            z-index: 1000;
        }
        
        .sidebar .nav-link {
            color: white;
            margin-bottom: 20px;
            font-size: 18px;
            text-align: center;
        }
        
        .sidebar .nav-link:hover {
            color: #000;
            background-color: white;
            border-radius: 5px;
        }
        
        .settings-link {
            position: absolute;
            padding: .5rem 1rem;
            bottom: 20px;
            font-size: 18px;
            color: white;
        }
        
        .settings-link:hover {
            color: #000;
            transition: color .15s ease-in-out, background-color .15s ease-in-out, border-color .15s ease-in-out;
            background-color: white;
            border-radius: 5px;    
        }
        
        .main-content {
            margin-left: 80px;
            padding: 40px;
            min-height: 100vh;
        }
        
        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
        }
        
        .page-title {
            font-size: 3rem;
            font-weight: 300;
            margin-bottom: 0;
        }
        
        .profile-section {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .profile-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .profile-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: rgba(255, 255, 255, 0.3);
        }
        
        .settings-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .settings-card {
            background-color: rgba(255, 255, 255, 0.85);
            border-radius: 15px;
            padding: 25px;
            color: #333;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .settings-card.full-width {
            grid-column: 1 / -1;
        }
        
        .card-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
            font-size: 1.3rem;
            font-weight: 600;
            color: #333;
        }
        
        .card-icon {
            width: 30px;
            height: 30px;
            background-color: #333;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }
        
        .profile-picture-section {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .profile-picture {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, #87CEEB, #4682B4);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }
        
        .profile-picture i {
            font-size: 2rem;
            color: white;
        }
        
        .edit-icon {
            position: absolute;
            bottom: 0;
            right: 0;
            width: 25px;
            height: 25px;
            background-color: #333;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 0.8rem;
            cursor: pointer;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #333;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 0.9rem;
            background-color: rgba(255, 255, 255, 0.9);
        }
        
        .form-control:focus {
            outline: none;
            border-color: #FF3B65;
            box-shadow: 0 0 0 2px rgba(255, 59, 101, 0.2);
        }
        
        .btn-primary {
            background-color: #FF3B65;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            color: white;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        
        .btn-primary:hover {
            background-color: #e6335a;
        }
        
        .btn-danger {
            background-color: #FF3B65;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            color: white;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s ease;
            width: 100%;
            margin-bottom: 10px;
        }
        
        .btn-danger:hover {
            background-color: #e6335a;
        }
        
        .dropdown-menu {
            background-color: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 10px;
        }
        
        @media (max-width: 768px) {
            .settings-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <!-- Add Button at the top -->
        <a href="home_page.jsp?page=add" class="nav-link">
            <img src="assets/LogoAdd.png" alt="Add" style="width: 40px; height: 40px;" class="sidebar-icon" id="add-icon">
        </a>
        
        <a href="home_page.jsp?page=home" class="nav-link">
            <img src="assets/LogoHome.png" alt="Home" style="width: 40px; height: 40px;" class="sidebar-icon" id="home-icon">
        </a>
        
        <a href="home_page.jsp?page=alarm" class="nav-link">
            <img src="assets/LogoAlarm.png" alt="Alarm" style="width: 40px; height: 40px;" class="sidebar-icon" id="alarm-icon">
        </a>
        
        <a href="home_page.jsp?page=reminder" class="nav-link">
            <img src="assets/LogoNotif.png" alt="Notification" style="width: 40px; height: 40px;" class="sidebar-icon" id="notif-icon">
        </a>
        
        <a href="NoteServlet" class="nav-link">
            <img src="assets/LogoNotes.png" alt="Notes" style="width: 40px; height: 40px;" class="sidebar-icon" id="notes-icon">
        </a>
        
        <a href="home_page.jsp?page=calendar" class="nav-link">
            <img src="assets/LogoCalendar.png" alt="Calendar" style="width: 40px; height: 40px;" class="sidebar-icon" id="calendar-icon">
        </a>
        
        <a href="home_page.jsp?page=todolist" class="nav-link">
            <img src="assets/LogoToDoList.png" alt="To-Do" style="width: 40px; height: 40px;" class="sidebar-icon" id="todo-icon">
        </a>
        
        <a href="home_page.jsp?page=journal" class="nav-link">
            <img src="assets/LogoJournal.png" alt="Journal" style="width: 40px; height: 40px;" class="sidebar-icon" id="journal-icon">
        </a>
        
        <a href="settings.jsp" class="settings-link">
            <img src="assets/LogoSetting.png" alt="Settings" style="width: 40px; height: 40px;" class="sidebar-icon" id="settings-icon">
        </a>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Header Section -->
        <div class="header-section">
            <h1 class="page-title">Settings</h1>
            
            <div class="profile-section">
                <div class="profile-info">
                    <span><%= session.getAttribute("username") != null ? session.getAttribute("username") : "FansaGantenk" %></span>
                    <div class="dropdown">
                        <img src="assets/Avatar.png" alt="Profile" class="profile-avatar dropdown-toggle" data-bs-toggle="dropdown" style="cursor: pointer;">
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="profile.jsp">Profile</a></li>
                            <li><a class="dropdown-item" href="logout">Logout</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- Settings Grid -->
        <div class="settings-grid">
            <!-- Profile Setting Card -->
            <div class="settings-card">
                <div class="card-header">
                    <div class="card-icon">
                        <i class="fas fa-user"></i>
                    </div>
                    Profile Setting
                </div>
                
                <div class="profile-picture-section">
                    <div class="profile-picture">
                        <i class="fas fa-user"></i>
                        <div class="edit-icon">
                            <i class="fas fa-pen"></i>
                        </div>
                    </div>
                </div>
                
                <form action="updateProfile" method="post">
                    <div class="form-group">
                        <label class="form-label">Username</label>
                        <input type="text" class="form-control" name="username" value="<%= session.getAttribute("username") %>" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" name="email" value="<%= session.getAttribute("email") %>" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Password</label>
                        <input type="password" class="form-control" name="newPassword" placeholder="••••••••••" readonly>
                    </div>
                    <a href="editProfile.jsp" class="btn btn-primary">Edit</a>

                </form>
            </div>

            <!-- Notification Setting Card -->
            <div class="settings-card">
                <div class="card-header">
                    <div class="card-icon">
                        <i class="fas fa-bell"></i>
                    </div>
                    Notification Setting
                </div>
                
                <form action="updateNotifications" method="post">
                    <div class="form-group">
                        <label class="form-label">Notification Ringtone</label>
                        <select class="form-control" name="notificationRingtone">
                            <option value="HidupJokowi3Jam.mp3" selected>HidupJokowi3Jam.mp3</option>
                            <option value="default.mp3">Default.mp3</option>
                            <option value="chime.mp3">Chime.mp3</option>
                            <option value="bell.mp3">Bell.mp3</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Alarm Ringtone</label>
                        <select class="form-control" name="alarmRingtone">
                            <option value="HidupJokowi3Jam.mp3" selected>HidupJokowi3Jam.mp3</option>
                            <option value="default.mp3">Default.mp3</option>
                            <option value="morning.mp3">Morning.mp3</option>
                            <option value="rooster.mp3">Rooster.mp3</option>
                        </select>
                    </div>
                </form>
            </div>

            <!-- Danger Zone Card - Now full width -->
            <div class="settings-card full-width">
                <div class="card-header">
                    <div class="card-icon" style="background-color: #FF3B65;">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    Danger Zone
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <button type="button" class="btn-danger" onclick="confirmLogout()">
                            Logout
                        </button>
                    </div>
                    <div class="col-md-6">
                        <button type="button" class="btn-danger" onclick="confirmDeleteAccount()">
                            Delete Account
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka9H3GMh7dQssI40c5n8O11Fpb0pSQZxQSTH5tf9QmjAcqfOgnMw2uZxtFsiqgdF" crossorigin="anonymous"></script>

    <script>
        document.getElementById("add-icon").onmouseover = function() {
            this.src = "assets/LogoAddHover.png";
        };
        document.getElementById("add-icon").onmouseout = function() {
            this.src = "assets/LogoAdd.png";
        };
        
        document.getElementById("home-icon").onmouseover = function() {
            this.src = "assets/HomeHover.png";
        };
        document.getElementById("home-icon").onmouseout = function() {
            this.src = "assets/LogoHome.png";
        };
        
        document.getElementById("alarm-icon").onmouseover = function() {
            this.src = "assets/AlarmHover.png";
        };
        document.getElementById("alarm-icon").onmouseout = function() {
            this.src = "assets/LogoAlarm.png";
        };

        document.getElementById("notif-icon").onmouseover = function() {
            this.src = "assets/NotifHover.png";
        };
        document.getElementById("notif-icon").onmouseout = function() {
            this.src = "assets/LogoNotif.png";
        };
        
        document.getElementById("notes-icon").onmouseover = function() {
            this.src = "assets/NotesHover.png";
        };
        document.getElementById("notes-icon").onmouseout = function() {
            this.src = "assets/LogoNotes.png";
        };

        document.getElementById("calendar-icon").onmouseover = function() {
            this.src = "assets/CalendarHover.png";
        };
        document.getElementById("calendar-icon").onmouseout = function() {
            this.src = "assets/LogoCalendar.png";
        };

        document.getElementById("todo-icon").onmouseover = function() {
            this.src = "assets/ToDoListHover.png";
        };
        document.getElementById("todo-icon").onmouseout = function() {
            this.src = "assets/LogoToDoList.png";
        };

        document.getElementById("journal-icon").onmouseover = function() {
            this.src = "assets/JournalHover.png";
        };
        document.getElementById("journal-icon").onmouseout = function() {
            this.src = "assets/LogoJournal.png";
        };

        document.getElementById("settings-icon").onmouseover = function() {
            this.src = "assets/SettingHover.png";
        };
        document.getElementById("settings-icon").onmouseout = function() {
            this.src = "assets/LogoSetting.png";
        };

        // Profile picture edit functionality
        document.querySelector('.edit-icon').addEventListener('click', function() {
            // Create file input
            const fileInput = document.createElement('input');
            fileInput.type = 'file';
            fileInput.accept = 'image/*';
            fileInput.style.display = 'none';
            
            fileInput.addEventListener('change', function(e) {
                const file = e.target.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        // Here you would typically upload the image to server
                        alert('Profile picture updated! (This would normally upload to server)');
                    };
                    reader.readAsDataURL(file);
                }
            });
            
            document.body.appendChild(fileInput);
            fileInput.click();
            document.body.removeChild(fileInput);
        });

        // Confirmation functions
        function confirmLogout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = 'logout';
            }
        }

        function confirmDeleteAccount() {
            if (confirm('Are you sure you want to delete your account? This action cannot be undone.')) {
                if (confirm('This will permanently delete all your data. Are you absolutely sure?')) {
                    // Here you would call the delete account servlet
                    alert('Account deletion would be processed here');
                    // window.location.href = 'deleteAccount';
                }
            }
        }

        // Form validation
        document.querySelector('form[action="updateProfile"]').addEventListener('submit', function(e) {
            const newPassword = document.querySelector('input[name="newPassword"]').value;
            const confirmPassword = document.querySelector('input[name="confirmPassword"]').value;
            
            if (newPassword && newPassword !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
            }
        });
    </script>
</body>
</html>