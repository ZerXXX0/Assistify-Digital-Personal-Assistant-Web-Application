<%-- 
    Document   : login_page
    Created on : May 14, 2025, 2:13:47 PM
    Author     : Fathan Fardian Sanum
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - ASSISTIFY 2025</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link href='https://fonts.googleapis.com/css?family=Space+Grotesk' rel='stylesheet'>
    <link rel="stylesheet" href="styles.css">
    <style>
        body {
            font-family: 'Space Grotesk';font-size: 22px;
            margin: 0;
            padding: 0;
            background-color: #fff;
        }

        header {
            background-color: #fff;
            padding: 20px 40px;
            border-bottom: 1px solid #ddd;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo img {
            width: 150px;  /* Adjust logo size */
            height: auto;
        }

        nav {
            display: flex;
            justify-content: flex-end;
            flex-grow: 1;
        }

        nav ul {
            display: flex;
            list-style: none;
            margin: 0;
            padding: 0;
        }

        nav ul li {
            margin-left: 20px;
        }

        nav ul li a {
            text-decoration: none;
            color: #FF3B65;
            font-weight: bold;
            padding: 10px 20px;
            border-radius: 5px;
            transition: all 0.3s ease;
        }

        nav ul li a:hover {
            background-color: #FF3B65;
            color: white;
        }

        .klik:hover {
            text-decoration: underline !important;
        }

        /* Login Page Section */
        .login-section {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #fff;
        }

        .login-container {
            background-color: #FF3B65;
            color: white;
            padding: 40px;
            width: 400px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .login-container h2 {
            font-size: 2rem;
            margin-bottom: 30px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-container label {
            display: grid;
            font-size: 1.1rem;
            margin-bottom: 5px;
            justify-content: left;
        }

        .login-container input {
            width: 100%;
            margin-bottom: 20px;
            padding-top: 8px;
            padding-bottom: 8px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1rem;
            box-sizing: border-box;
        }

        .login-container button {
            width: 100%;
            padding-top: 10px;
            padding-bottom: 10px;
            padding-left: 10px;
            background-color: #ffffff;
            color: #FF3B65;
            font-size: 1.1rem;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-container button:hover {
            background-color: #FF3B65;
            border: 2px solid white;
            color: white;
            transform: scale(1.05);
        }

        .signup-link {
            margin-top: 20px;
            font-size: 1rem;
        }

        .signup-link a {
            color: #ffffff;
            text-decoration: none;
        }

        .signup-link a:hover {
            text-decoration: underline;
        }

        footer {
            background-color: #FF3B65;
            color: white;
            text-align: center;
            padding: 20px 0;
        }

        footer p {
            margin: 10px 0;
        }

        footer a {
            color: white;
            text-decoration: none;
            font-weight: bold;
        }

        footer a:hover {
            text-decoration: underline;
        }

        .klik:hover {
            text-decoration: underline !important;
        }

    </style>
    
</head>
<body>
    <header>
        <div class="d-flex justify-content-between align-items-center">
            <a href="index.jsp">
                <img src="assets/Logo.png" alt="ASSISTIFY Logo" class="img-fluid" style="max-width: 150px;">
            </a>
        </div>
    </header>

    <section class="login-section d-flex justify-content-center align-items-center">
        <div class="login-container text-white p-5 rounded shadow-lg" style="width: 500px;">
            <h2 class="text-center mb-4">Log In</h2>
            <form action="login" method="POST">
                <% String error = (String) request.getAttribute("error"); %>
                <% if (error != null) { %>
                    <div class="alert alert-danger"><%= error %></div>
                <% } %>
                
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" class="form-control" id="username" name="username" maxlength="25" required>
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password" maxlength="25" required>
                </div>

                <button type="submit" class="btn btn-light mt-5 w-100 py-3">Log In</button>
            </form>

            <p class="mt-1 pt-4 text-center">
                Don't have an account? <a href="registration_page.jsp" class="text-white text-decoration-none klik">Click here</a>
            </p>
        </div>
    </section>

    <footer class="text-white text-center py-3">
        <p>&copy; 2025 Assistify. All rights reserved.</p>
        <p>Powered by <a href="#" class="text-white text-decoration-none klik">Assistify Technologies</a></p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js" integrity="sha384-oBqDVmMz4fnFO9gyb3+KnujsUR6g7U95RkFq3bRQGzVf0X0R9BcXsSm6a1T3McDGH" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous"></script>
</body>
</html>
