<%-- 
    Document   : index
    Created on : May 12, 2025, 1:37:10 PM
    Author     : Fathan Fardian Sanum
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ASSISTIFY - Digital Personal Assistant</title>
    <!-- Bootstrap 5.0.2 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link href='https://fonts.googleapis.com/css?family=Space+Grotesk' rel='stylesheet'>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header class="container-fluid bg-white py-3 border-bottom">
        <div class="d-flex justify-content-between align-items-center">
            <div class="logo">
                <a href="index.jsp">
                    <img src="assets/Logo.png" alt="ASSISTIFY Logo" class="img-fluid" style="width: 150px;">
                </a>
            </div>
            <nav class="ms-auto">
                <ul class="nav">
                    <li class="nav-item"><a href="#" class="nav-link text-danger">About us</a></li>
                    <li class="nav-item"><a href="#" class="nav-link text-danger">Services</a></li>
                    <li class="nav-item"><a href="#" class="nav-link text-danger">Use Cases</a></li>
                    <li class="nav-item"><a href="#" class="nav-link text-danger">Feature</a></li>
                    <li class="nav-item"><a href="login_page.jsp" class="nav-link text-danger border border-danger rounded-3 px-4">Log In</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <section class="hero bg-white py-5">
        <div class="container d-flex justify-content-between align-items-center">
            <div class="hero-text" style="max-width: 50%;">
                <h1 class="text-danger fs-1">Manage your day with your very own digital personal assistant</h1>
                <p class="fs-4 text-dark mt-4">Our application helps people grow and succeed with their lives through digital personal assistant. We help people manage their daily, works, schedule, etc.</p>
                <a href="registration_page.jsp" class="btn btn-danger btn-lg mt-4">Get Started Now</a>
            </div>
            <div class="hero-icons">
                <img src="assets/DashboardImage.png" alt="Icons Set" class="img-fluid" style="max-width: 500px;">
            </div>
        </div>
    </section>

    <section class="features py-5">
    <div class="container">
        <h2 class="text-center text-white bg-danger p-2 rounded-3">Features</h2>
        <div class="feature-boxes mt-4">
            <div class="feature-box1">
                <div class="feature-content text-center">
                    <h3 class="text-white">Note and Voice Note</h3>
                    <div style="display: flex; justify-content: right;">
                        <img src="assets/IconNote.png" alt="Note Icon" class="img-fluid" style="max-width: 150px;">
                    </div>
                    <div style="display: flex; align-items: center; gap: 8px;">
                        <img src="assets/LogoPanah1.png" alt="Arrow Logo" style="width: 40px; height: auto;">
                        <a href="#" class="text-danger">Learn more</a>
                    </div>
                </div>
            </div>
            <div class="feature-box2">
                <div class="feature-content text-center">
                    <h3>To-Do List</h3>
                    <div style="display: flex; justify-content: right;">
                        <img src="assets/IconToDo.png" alt="To-Do List Icon" class="img-fluid" style="max-width: 150px;">
                    </div>
                    <div style="display: flex; align-items: center; gap: 8px;">
                        <img src="assets/LogoPanah2.png" alt="Arrow Logo" style="width: 40px; height: auto;">
                        <a href="#" class="text-white">Learn more</a>
                    </div>
                </div>
            </div>
            <div class="feature-box2 mt-4">
                <div class="feature-content text-center">
                    <h3>Daily Reminder</h3>
                    <div style="display: flex; justify-content: right;">
                        <img src="assets/IconReminder.png" alt="Reminder Icon" class="img-fluid" style="max-width: 150px;">
                    </div>
                    <div style="display: flex; align-items: center; gap: 8px;">
                        <img src="assets/LogoPanah2.png" alt="Arrow Logo" style="width: 40px; height: auto;">
                        <a href="#" class="text-white">Learn more</a>
                    </div>
                </div>
            </div>
            <div class="feature-box1 mt-4">
                <div class="feature-content text-center">
                    <h3 class="text-white">Alarm Clock</h3>
                    <div style="display: flex; justify-content: right;">
                        <img src="assets/IconAlarm.png" alt="Alarm Icon" class="img-fluid" style="max-width: 150px;">
                    </div>
                    <div style="display: flex; align-items: center; gap: 8px;">
                        <img src="assets/LogoPanah1.png" alt="Arrow Logo" style="width: 40px; height: auto;">
                        <a href="#" class="text-danger">Learn more</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </section>

    <footer class="bg-danger text-white text-center py-4">
        <p>&copy; 2025 Assistify. All rights reserved.</p>
        <p>Powered by <a href="#" class="text-white text-decoration-none klik">Assistify Technologies</a></p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka9H3GMh7dQssI40c5n8O11Fpb0pSQZxQSTH5tf9QmjAcqfOgnMw2uZxtFsiqgdF" crossorigin="anonymous"></script>
</body>
</html>

