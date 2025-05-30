<%-- 
    Document   : registration_page
    Created on : May 14, 2025, 2:36:43 PM
    Author     : Fathan Fardian Sanum
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - ASSISTIFY 2025</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link href='https://fonts.googleapis.com/css?family=Space+Grotesk' rel='stylesheet'>
    <link rel="stylesheet" href="styles.css">
    <style>
        body {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 22px;
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
            width: 150px;
            height: auto;
        }

        .register-section {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #fff;
        }

        .register-container {
            background-color: #FF3B65;
            color: white;
            padding: 40px;
            width: 400px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .register-container h2 {
            font-size: 2rem;
            margin-bottom: 30px;
        }

        .register-container label {
            display: grid;
            font-size: 1.1rem;
            margin-bottom: 5px;
            justify-content: left;
        }

        .register-container input {
            width: 100%;
            padding-top: 8px;
            padding-bottom: 8px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1rem;
            box-sizing: border-box;
        }

        .register-container button {
            width: 100%;
            padding: 10px;
            background-color: #ffffff;
            color: #FF3B65;
            font-size: 1.1rem;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .register-container button:hover {
            background-color: #FF3B65;
            border: 2px solid white;
            color: white;
            transform: scale(1.05);
        }

        .login-link {
            margin-top: 20px;
            font-size: 1rem;
        }

        .login-link a {
            color: #ffffff;
            text-decoration: none;
        }

        .login-link a:hover {
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
                <img src="assets/Logo.png" alt="ASSISTIFY Logo" class="img-fluid" style="max-width: 150px;"> <!-- Logo image -->
            </a>
        </div>
    </header>

    <section class="register-section d-flex justify-content-center align-items-center">
        <div class="register-container text-white p-5 rounded shadow-lg" style="width: 500px;">
            <h2 class="text-center mb-4">Register</h2>
            <form action="register" method="POST">
                <% String error = (String) request.getAttribute("error"); %>
                <% String success = (String) request.getAttribute("success"); %>
                
                <% if (error != null) { %>
                    <div class="alert alert-danger"><%= error %></div>
                <% } %>
                
                <% if (success != null) { %>
                    <div class="alert alert-success"><%= success %></div>
                <% } %>
                
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" class="form-control" id="username" name="username" maxlength="25" required>
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control" id="email" name="email" maxlength="100" required>
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password" maxlength="25" required>
                </div>

                <div class="mb-3">
                    <label for="confirm-password" class="form-label">Confirm Password</label>
                    <input type="password" class="form-control" id="confirm-password" name="confirm-password" maxlength="25" required>
                </div>

                <button type="submit" class="btn btn-light mt-5 w-100 py-3">Register</button>
            </form>

            <p class="mt-1 pt-4 text-center">
                Already have an account? <a href="login_page.jsp" class="text-white text-decoration-none klik">Log In</a>
            </p>
        </div>
    </section>

    <footer class="text-white text-center py-3">
        <p>&copy; 2025 Assistify. All rights reserved.</p>
        <p>Powered by <a href="#" class="text-white text-decoration-none klik">Assistify Technologies</a></p>
    </footer>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js" integrity="sha384-oBqDVmMz4fnFO9gyb3+KnujsUR6g7U95RkFq3bRQGzVf0X0R9BcXsSm6a1T3McDGH" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" integrity="sha384-pzjw8f+ua7Kw1TIq0oQXb+g3Nl5U6B2q6U8c2hZyKXYz7klz0BYdkPjVsBzIjeF1" crossorigin="anonymous"></script>
</body>
</html>
