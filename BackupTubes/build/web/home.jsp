<%-- 
    Document   : home
    Created on : May 22, 2025, 8:39:17 PM
    Author     : Fathan Fardian Sanum
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home Page</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: url('assets/IMG_6703.jpg') no-repeat center center fixed;
            background-size: cover;
            color: white;
            position: relative;
        }
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100%;
            width: 80px;
            background-color: #FF3B65;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-top: 20px;
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
        
        .profile-section {
            position: absolute;
            top: 20px;
            right: 30px;
            display: flex;
            align-items: center;
            gap: 15px;
            z-index: 10;
        }
        
        .content {
            margin-left: 100px;
            padding: 40px;
        }
        .card {
            color: black;
            background-color: rgba(255, 255, 255, 0.8); /* White with slight transparency */
            border-radius: 10px;
            padding: 20px;
        }
        .card-header {
            background-color: transparent !important;
            border-bottom: none !important;
            padding: 0;
            padding-bottom: 15px;
            color: black;
            font-weight: bold;
        }
        .todo-list, .reminder-list, .alarm-list {
            list-style-type: none;
            padding-left: 0;
        }
        .todo-list li, .reminder-list li, .alarm-list li {
            margin-bottom: 10px;
            color: black;
        }
        .btn-danger {
            background-color: #FF3B65;
        }
        /* Profile, Add, and Settings Icons */
        .profile-container {
            position: absolute;
            top: 20px;
            right: 20px;
            display: flex;
            align-items: center;
            color: white;
        }
        .profile-name {
            margin-left: 15px;
            font-size: 18px;
        }
        
        .add-icon {
            position: absolute;
            top: 20px;
            left: 20px;
            font-size: 30px;
            color: white;
        }
        .settings-icon {
            position: absolute;
            bottom: 20px;
            left: 20px;
            font-size: 30px;
            color: white;
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
    </style>
</head>
<body>
    <div class="content">
        <!-- Header -->
         <div class="header-section">
            <div class="greeting">
                <h1>Hello, <%= session.getAttribute("username") != null ? session.getAttribute("username") : "FansaGantenk" %>!</h1>
                <p>What can I do for you today?</p>
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
        <div class="row">
            <h2>Today</h2> <!-- Added "Today" label here -->
            <!-- To-Do List Card -->
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        To-Do List
                    </div>
                    <ul class="todo-list">
                        <li>Not snitchin' on gang</li>
                        <li>Sell dope</li>
                        <li>Rob a nigga</li>
                        <li>Get money</li>
                        <li>Rep the set</li>
                        <li>Pop the opp</li>
                        <li>Buy some milk</li>
                        <li>Visit baby mama</li>
                    </ul>
                </div>
            </div>
            <!-- Alarm Card -->
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        Alarm
                    </div>
                    <ul class="alarm-list">
                        <li>08:00 Wake tf up</li>
                        <li>16:00 Wake tf up</li>
                        <li>23:00 Smoke weed errday</li>
                    </ul>
                </div>
            </div>
            <!-- Reminder Card -->
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        Reminder
                    </div>
                    <ul class="reminder-list">
                        <li>08:00 Get some help</li>
                        <li>16:00 Slide on opp</li>
                        <li>23:00 Smoke weed errday</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Notes and Voice Note -->
        <div class="row mt-4">
            <!-- Note Card -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        Note
                    </div>
                    <p>Got a top from a stripper bitch</p>
                    <p>She from Kankakee</p>
                </div>
            </div>
            <!-- Voice Note Card -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        Voice Note
                    </div>
                    <audio controls>
                        <source src="assets/TestVoice.mp3" type="audio/mpeg">
                        Your browser does not support the audio element.
                    </audio>
                </div>
            </div>
        </div>

        <!-- Tomorrow Section (Same structure as today) -->
        <div class="row mt-4">
            <h2>Tomorrow</h2> <!-- Added "Tomorrow" label here -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        Tomorrow's Alarm
                    </div>
                    <ul class="alarm-list">
                        <li>08:00 Wake tf up</li>
                        <li>16:00 Wake tf up</li>
                        <li>23:00 Smoke weed errday</li>
                    </ul>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        Tomorrow's Note
                    </div>
                    <p>Just got a top from a stripper bitch</p>
                    <p>She from Kankakee...</p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
