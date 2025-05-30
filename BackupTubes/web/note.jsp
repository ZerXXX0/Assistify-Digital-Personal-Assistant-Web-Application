<%-- 
    Document   : note
    Created on : May 22, 2025, 8:07:54 PM
    Author     : Fathan Fardian Sanum
--%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notes - Digital Assistant</title>
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
        
        .card {
            color: black;
            background-color: rgba(255, 255, 255, 0.8);
            border-radius: 10px;
            padding: 20px;
            margin-top: 70px;
        }
        .card-header {
            background-color: transparent !important;
            border-bottom: none !important;
            padding: 0;
            padding-bottom: 15px;
            color: black;
            font-weight: bold;
        }
        .notes-header {
            flex: 1;
        }
        .note-list {
            margin-top: 20px;
        }
        .note-item {
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            margin-bottom: 15px;
        }
        .note-title {
            font-size: 20px;
            font-weight: bold;
        }
        .note-text {
            font-size: 16px;
            color: #555;
        }
        .note-footer {
            font-size: 12px;
            color: #888;
            text-align: right;
        }
    </style>
</head>
<body>
    <!-- Main Content -->
    <div class="main-content">
        <!-- Header Section -->
        <div class="header-section">
            <div class="notes-header">
                <h1>Notes</h1>
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
    <% 
        ResultSet rs = (ResultSet) request.getAttribute("listNote");
        try {
            if (rs != null) {
    %>
    <div class="container">
        <!-- Container untuk Text Notes -->
        <div class="card">
            <div class="card-header">
                Text Notes
            </div>
            <div class="card-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>Title</th>
                            <th>Text Note</th>
                            <th>Created Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            while (rs.next()) {
                                if (rs.getString("textNote") != null) { 
                        %>
                        <tr>
                            <td><%= rs.getString("title") %></td>
                            <td><%= rs.getString("textNote") %></td>
                            <td><%= rs.getString("createdDate") %></td>
                        </tr>
                        <% 
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Container untuk Voice Notes -->
        <div class="card">
            <div class="card-header">
                Voice Notes
            </div>
            <div class="card-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>Title</th>
                            <th>Voice Note</th>
                            <th>Created Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            // Reset ResultSet pointer untuk mengecek voice notes
                            rs.beforeFirst();
                            while (rs.next()) {
                                if (rs.getString("voiceNote") != null) {
                        %>
                        <tr>
                            <td><%= rs.getString("title") %></td>
                            <td>
                                <audio controls>
                                    <source src="<%= rs.getString("voiceNote") %>" type="audio/mpeg">
                                    Your browser does not support the audio element.
                                </audio>
                            </td>
                            <td><%= rs.getString("createdDate") %></td>
                        </tr>
                        <% 
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <% 
            } else {
    %>
    <div class="alert alert-warning">No notes available.</div>
    <% 
            }
        } catch (SQLException e) {
    %>
        <div class="alert alert-danger">Error: <%= e.getMessage() %></div>
    <% 
        }
    %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka9H3GMh7dQssI40c5n8O11Fpb0pSQZxQSTH5tf9QmjAcqfOgnMw2uZxtFsiqgdF" crossorigin="anonymous"></script>
    </div>
</body>
</html>
