<%-- 
    Document   : journal
    Created on : May 30, 2025, 10:22:22 AM
    Author     : Fathan Fardian Sanum
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Journal - Digital Assistant</title>
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
        
        .journal-header {
            flex: 1;
        }
        
        .journal-header h1 {
            font-size: 3rem;
            font-weight: 300;
            margin-bottom: 5px;
        }
        
        .journal-header p {
            font-size: 1.2rem;
            opacity: 0.9;
            margin-bottom: 0;
        }
        
        .profile-section {
            position: absolute;
            top: 20px;
            right: 30px;
            display: flex;
            align-items: center;
            gap: 15px;
            z-index: 10;
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
        
        .section-title {
            font-size: 1.5rem;
            font-weight: 500;
            margin-bottom: 20px;
            margin-top: 40px;
        }
        
        .section-title:first-of-type {
            margin-top: 0;
        }
        
        .journal-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .journal-card {
            background-color: rgba(255, 255, 255, 0.85);
            border-radius: 15px;
            padding: 20px;
            color: #333;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .journal-card-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 15px;
            color: #333;
        }
        
        .journal-content {
            font-size: 0.9rem;
            line-height: 1.5;
            color: #555;
        }
        
        .journal-meta {
            display: flex;
            justify-content: flex-start;
            align-items: center;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid rgba(0, 0, 0, 0.1);
        }
        
        .journal-date {
            font-size: 0.8rem;
            color: #666;
        }
        
        .dropdown-menu {
            background-color: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 10px;
        }
        
        @media (max-width: 768px) {
            .journal-grid {
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
        
        <a href="home_page.jsp?page=journal" class="nav-link active">
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
            <div class="journal-header">
                <h1>Journal</h1>
                <p>Today</p>
            </div>
            
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

        <!-- Today Section -->
        <h2 class="section-title">Today</h2>
        <div class="journal-grid">
            <!-- Daily Journal Card -->
            <div class="journal-card">
                <div class="journal-card-title">Daily</div>
                <div class="journal-content">
                    Dear diary,<br><br>
                    I finna pop some n*gga man damn. I aint gon let ts slide man, dis nigga don pop my gang man. fuck the 63rd man. damn cuz i see them hoe at 63rd i finna hit. she got dat superbass niki minaj lookin ass girl.
                </div>
                <div class="journal-meta">
                    <span class="journal-date">Today, 2:30 PM</span>
                </div>
            </div>

            <!-- Sleep Journal Card -->
            <div class="journal-card">
                <div class="journal-card-title">Sleep Journal</div>
                <div class="journal-content">
                    Man i be dreamin bout my opps today, i be dreamin of poppin them off man. Dafuq ts man i wanna wet dream cuz damn.
                </div>
                <div class="journal-meta">
                    <span class="journal-date">Today, 8:00 AM</span>
                </div>
            </div>

            <!-- Drugs Journal Card -->
            <div class="journal-card">
                <div class="journal-card-title">Drugs</div>
                <div class="journal-content">
                    i be smokin weed, sippin lean and injectin fent today cuh dat shit hard son
                </div>
                <div class="journal-meta">
                    <span class="journal-date">Today, 11:45 PM</span>
                </div>
            </div>
        </div>

        <!-- Yesterday Section -->
        <h2 class="section-title">Yesterday</h2>
        <div class="journal-grid">
            <!-- Daily Journal Card -->
            <div class="journal-card">
                <div class="journal-card-title">Daily</div>
                <div class="journal-content">
                    Dear diary,<br><br>
                    I finna pop some n*gga man damn. I aint gon let ts slide man, dis nigga don pop my gang.
                </div>
                <div class="journal-meta">
                    <span class="journal-date">Yesterday, 6:15 PM</span>
                </div>
            </div>

            <!-- Sleep Journal Card -->
            <div class="journal-card">
                <div class="journal-card-title">Sleep Journal</div>
                <div class="journal-content">
                    Man i be dreamin bout my opps today, i be dreamin of poppin them off man. Dafuq ts man i wanna wet dream cuz damn.
                </div>
                <div class="journal-meta">
                    <span class="journal-date">Yesterday, 7:30 AM</span>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka9H3GMh7dQssI40c5n8O11Fpb0pSQZxQSTH5tf9QmjAcqfOgnMw2uZxtFsiqgdF" crossorigin="anonymous"></script>

    <script>
        // Sidebar icon hover effects
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
    </script>
</body>
</html>