<%-- 
    Document   : home_page
    Created on : May 22, 2025, 5:11:35 PM
    Author     : Fathan Fardian Sanum
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Digital Assistant</title>
    <!-- Bootstrap 5.0.2 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: url('assets/IMG_6703.jpg') no-repeat center center fixed;
            background-size: cover;
            color: white;
            position: relative;
            margin: 0;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
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
        
        .add-button {
            background: none;
            border: none;
            color: white;
            font-size: 2rem;
            cursor: pointer;
            margin-bottom: 20px;
            padding: 10px;
            border-radius: 5px;
            text-align: center;
        }

        .add-button:hover {
            color: #000;
            background-color: white;
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
        
        .greeting {
            flex: 1;
        }
        
        .greeting h1 {
            font-size: 3rem;
            font-weight: 300;
            margin-bottom: 10px;
        }
        
        .greeting p {
            font-size: 1.2rem;
            opacity: 0.9;
        }
        
        .profile-section {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .flag-icon {
            width: 30px;
            height: 20px;
            background: linear-gradient(to bottom, #012169 33%, white 33%, white 66%, #C8102E 66%);
            position: relative;
        }
        
        .flag-icon::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: 
                linear-gradient(45deg, transparent 40%, white 40%, white 60%, transparent 60%),
                linear-gradient(-45deg, transparent 40%, white 40%, white 60%, transparent 60%),
                linear-gradient(45deg, transparent 45%, #C8102E 45%, #C8102E 55%, transparent 55%),
                linear-gradient(-45deg, transparent 45%, #C8102E 45%, #C8102E 55%, transparent 55%);
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
        
        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .dashboard-card {
            background-color: rgba(255, 255, 255, 0.85);
            border-radius: 15px;
            padding: 20px;
            color: #333;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .card-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 15px;
            color: #333;
        }
        
        .todo-item {
            display: flex;
            align-items: center;
            margin-bottom: 8px;
            font-size: 0.9rem;
        }
        
        .todo-item input[type="checkbox"] {
            margin-right: 10px;
            transform: scale(1.2);
        }
        
        .todo-item.completed {
            text-decoration: line-through;
            opacity: 0.7;
        }
        
        .alarm-item, .reminder-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            font-size: 0.9rem;
        }
        
        .time {
            font-weight: 600;
            color: #666;
        }
        
        .note-content {
            font-size: 0.9rem;
            line-height: 1.4;
            color: #555;
        }
        
        .voice-note {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .play-button {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #333;
            border: none;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }
        
        .waveform {
            flex: 1;
            height: 30px;
            background: repeating-linear-gradient(
                90deg,
                #333 0px,
                #333 2px,
                transparent 2px,
                transparent 4px
            );
            border-radius: 15px;
            opacity: 0.7;
        }
        
        .dropdown-menu {
            background-color: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 10px;
        }
    </style>
</head>
<body>   
    <!-- Sidebar -->
    <div class="sidebar">
        <!-- Add Button at the top -->
        <a href="home_page.jsp?page=add" class="nav-link <%= request.getParameter("page") == null || request.getParameter("page").equals("home") ? "active" : "" %>">
            <img src="assets/LogoAdd.png" alt="Add" style="width: 40px; height: 40px;" class="sidebar-icon" id="add-icon">
        </a>
            
        <a href="home_page.jsp?page=home" class="nav-link <%= request.getParameter("page") == null || request.getParameter("page").equals("home") ? "active" : "" %>">
            <img src="assets/LogoHome.png" alt="Home" style="width: 40px; height: 40px;" class="sidebar-icon" id="home-icon">
        </a>
        
        <a href="home_page.jsp?page=alarm" class="nav-link <%= request.getParameter("page") != null && request.getParameter("page").equals("alarm") ? "active" : "" %>">
            <img src="assets/LogoAlarm.png" alt="Alarm" style="width: 40px; height: 40px;" class="sidebar-icon" id="alarm-icon">
        </a>
        
        <a href="home_page.jsp?page=reminder" class="nav-link <%= request.getParameter("page") != null && request.getParameter("page").equals("reminder") ? "active" : "" %>">
            <img src="assets/LogoNotif.png" alt="Notification" style="width: 40px; height: 40px;" class="sidebar-icon" id="notif-icon">
        </a>
        
        <a href="NoteServlet" class="nav-link <%= request.getParameter("page") != null && request.getParameter("page").equals("note") ? "active" : "" %>">
            <img src="assets/LogoNotes.png" alt="Notes" style="width: 40px; height: 40px;" class="sidebar-icon" id="notes-icon">
        </a>
        
        <a href="home_page.jsp?page=calendar" class="nav-link <%= request.getParameter("page") != null && request.getParameter("page").equals("calendar") ? "active" : "" %>">
            <img src="assets/LogoCalendar.png" alt="Calendar" style="width: 40px; height: 40px;" class="sidebar-icon" id="calendar-icon">
        </a>
        
        <a href="home_page.jsp?page=todolist" class="nav-link <%= request.getParameter("page") != null && request.getParameter("page").equals("todolist") ? "active" : "" %>">
            <img src="assets/LogoToDoList.png" alt="To-Do" style="width: 40px; height: 40px;" class="sidebar-icon" id="todo-icon">
        </a>
        
        <!-- JournalEntry button added below ToDoList -->
        <a href="JournalEntryServlet" class="nav-link <%= request.getParameter("page") != null && request.getParameter("page").equals("journal") ? "active" : "" %>">
            <img src="assets/LogoJournal.png" alt="Journal" style="width: 40px; height: 40px;" class="sidebar-icon" id="journal-icon">
        </a>
        
        <a href="settings.jsp" class="settings-link">
            <img src="assets/LogoSetting.png" alt="Settings" style="width: 40px; height: 40px;" class="sidebar-icon" id="settings-icon">
        </a>
    </div>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka9H3GMh7dQssI40c5n8O11Fpb0pSQZxQSTH5tf9QmjAcqfOgnMw2uZxtFsiqgdF" crossorigin="anonymous"></script>

            <%
        String content = (String) request.getAttribute("content");
        
        %>
        <div class="form-container">
        <%
        if ("home".equals(content)){
            %>  
            <jsp:include page="home.jsp" flush="true"></jsp:include>
            <%
        } else if ("alarm".equals(content)){
            %>  
            <jsp:include page="alarm.jsp" flush="true"></jsp:include>
            <%
        } else if ("note".equals(content)){
            %>  
            <jsp:include page="note.jsp" flush="true"></jsp:include>
            <%
        } else if ("calendar".equals(content)){
            %>  
            <jsp:include page="calendar.jsp" flush="true"></jsp:include>
            <%
        } else if ("todolist".equals(content)){
            %>  
            <jsp:include page="todolist.jsp" flush="false"></jsp:include>
            <%
        } else if ("journal".equals(content)){
            %>  
            <jsp:include page="journal.jsp" flush="true"></jsp:include>
            <%
        } else if ("settings".equals(content)){
            %>  
            <jsp:include page="settings.jsp" flush="true"></jsp:include>
            <%
        }else {
            %>  
            <jsp:include page="home.jsp" flush="true"></jsp:include>
            <%
            }

        %>  
        </div>

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

        // Todo item interactions
        document.querySelectorAll('.todo-item input[type="checkbox"]').forEach(checkbox => {
            checkbox.addEventListener('change', function() {
                const todoItem = this.closest('.todo-item');
                if (this.checked) {
                    todoItem.classList.add('completed');
                } else {
                    todoItem.classList.remove('completed');
                }
            });
        });

        // Voice note play button
        document.querySelector('.play-button').addEventListener('click', function() {
            const icon = this.querySelector('i');
            if (icon.classList.contains('fa-play')) {
                icon.classList.remove('fa-play');
                icon.classList.add('fa-pause');
            } else {
                icon.classList.remove('fa-pause');
                icon.classList.add('fa-play');
            }
        });
    </script>
</body>
</html>