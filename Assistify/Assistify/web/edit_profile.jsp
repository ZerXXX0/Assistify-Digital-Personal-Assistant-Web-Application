<%-- Edit Profile Content Only --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- Page Header -->
<div class="page-header">
    <div class="page-title-section">
        <h1>
            <i class="fas fa-user-edit"></i>
            Edit Profile
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

<div class="row justify-content-center">
    <div class="col-md-8 col-lg-6">
        <div class="settings-card">
            <div class="card-header text-center">
                <h2 class="card-title">
                    <i class="fas fa-user-edit"></i> Edit Profile
                </h2>
                <p class="text-muted">Update your account information</p>
            </div>
            
            <form action="EditUserServlet" method="post" id="editProfileForm">
                <!-- Basic Information -->
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-user me-2"></i>Username
                    </label>
                    <input type="text" name="username" class="form-control" 
                           value="<%= session.getAttribute("username") != null ? session.getAttribute("username") : "" %>" 
                           required>
                </div>

                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-envelope me-2"></i>Email
                    </label>
                    <input type="email" name="email" class="form-control" 
                           value="<%= session.getAttribute("email") != null ? session.getAttribute("email") : "" %>" 
                           required>
                </div>

                <!-- Password Section -->
                <div class="settings-card" style="background-color: rgba(248, 249, 250, 0.8); margin: 20px 0;">
                    <h6><i class="fas fa-lock me-2"></i>Change Password (Optional)</h6>
                    <p style="font-size: 0.85rem; color: #666; margin-bottom: 15px;">
                        Leave blank if you don't want to change your password
                    </p>
                    
                    <div class="form-group" id="currentPasswordGroup" style="display: none;">
                        <label class="form-label">Current Password</label>
                        <input type="password" name="currentPassword" class="form-control" 
                               placeholder="Enter your current password">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">New Password</label>
                        <input type="password" name="newPassword" class="form-control" 
                               placeholder="Enter new password" id="newPassword">
                        <div id="passwordStrength" class="password-strength"></div>
                    </div>
                    
                    <div class="form-group" id="confirmPasswordGroup" style="display: none;">
                        <label class="form-label">Confirm New Password</label>
                        <input type="password" name="confirmPassword" class="form-control" 
                               placeholder="Confirm new password" id="confirmPassword">
                        <div id="passwordMatch" class="password-match"></div>
                    </div>
                </div>
                
                <div class="form-group">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-save me-2"></i>Save Changes
                    </button>
                </div>
                
                <div class="text-center">
                    <a href="HomeServlet?page=settings" class="btn btn-secondary">
                        <i class="fas fa-times me-2"></i>Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
.password-strength {
    margin-top: 5px;
    font-size: 0.8rem;
}

.strength-weak { color: #dc3545; }
.strength-medium { color: #ffc107; }
.strength-strong { color: #28a745; }

.password-match {
    margin-top: 5px;
    font-size: 0.8rem;
}

.match-success { color: #28a745; }
.match-error { color: #dc3545; }
</style>

<script>
const newPasswordField = document.getElementById('newPassword');
const confirmPasswordField = document.getElementById('confirmPassword');
const currentPasswordGroup = document.getElementById('currentPasswordGroup');
const confirmPasswordGroup = document.getElementById('confirmPasswordGroup');
const passwordStrength = document.getElementById('passwordStrength');
const passwordMatch = document.getElementById('passwordMatch');

// Show/hide password fields based on new password input
newPasswordField.addEventListener('input', function() {
    const hasPassword = this.value.length > 0;
    currentPasswordGroup.style.display = hasPassword ? 'block' : 'none';
    confirmPasswordGroup.style.display = hasPassword ? 'block' : 'none';
    
    if (hasPassword) {
        document.querySelector('input[name="currentPassword"]').required = true;
        confirmPasswordField.required = true;
        checkPasswordStrength(this.value);
    } else {
        document.querySelector('input[name="currentPassword"]').required = false;
        confirmPasswordField.required = false;
        passwordStrength.innerHTML = '';
        passwordMatch.innerHTML = '';
    }
});

// Password strength checker
function checkPasswordStrength(password) {
    let strength = 0;
    let feedback = [];

    if (password.length >= 8) strength++;
    else feedback.push('at least 8 characters');

    if (/[a-z]/.test(password)) strength++;
    else feedback.push('lowercase letter');

    if (/[A-Z]/.test(password)) strength++;
    else feedback.push('uppercase letter');

    if (/[0-9]/.test(password)) strength++;
    else feedback.push('number');

    if (/[^A-Za-z0-9]/.test(password)) strength++;
    else feedback.push('special character');

    let strengthText = '';
    let strengthClass = '';

    if (strength < 2) {
        strengthText = 'Weak - Add: ' + feedback.join(', ');
        strengthClass = 'strength-weak';
    } else if (strength < 4) {
        strengthText = 'Medium - Add: ' + feedback.join(', ');
        strengthClass = 'strength-medium';
    } else {
        strengthText = 'Strong password';
        strengthClass = 'strength-strong';
    }

    passwordStrength.innerHTML = `<i class="fas fa-shield-alt me-1"></i>${strengthText}`;
    passwordStrength.className = `password-strength ${strengthClass}`;
}

// Password match checker
confirmPasswordField.addEventListener('input', function() {
    const newPassword = newPasswordField.value;
    const confirmPassword = this.value;

    if (confirmPassword.length > 0) {
        if (newPassword === confirmPassword) {
            passwordMatch.innerHTML = '<i class="fas fa-check me-1"></i>Passwords match';
            passwordMatch.className = 'password-match match-success';
        } else {
            passwordMatch.innerHTML = '<i class="fas fa-times me-1"></i>Passwords do not match';
            passwordMatch.className = 'password-match match-error';
        }
    } else {
        passwordMatch.innerHTML = '';
    }
});

// Form validation
document.getElementById('editProfileForm').addEventListener('submit', function(e) {
    const newPassword = newPasswordField.value;
    const confirmPassword = confirmPasswordField.value;
    const currentPassword = document.querySelector('input[name="currentPassword"]').value;

    if (newPassword && newPassword !== confirmPassword) {
        e.preventDefault();
        Swal.fire({
            icon: 'error',
            title: 'Password Mismatch',
            text: 'New passwords do not match!'
        });
        return;
    }

    if (newPassword && !currentPassword) {
        e.preventDefault();
        Swal.fire({
            icon: 'error',
            title: 'Current Password Required',
            text: 'Current password is required to change password!'
        });
        return;
    }

    if (newPassword && newPassword.length < 6) {
        e.preventDefault();
        Swal.fire({
            icon: 'error',
            title: 'Password Too Short',
            text: 'New password must be at least 6 characters long!'
        });
        return;
    }
});

// Handle success/error messages with SweetAlert2
document.addEventListener('DOMContentLoaded', function() {
    const urlParams = new URLSearchParams(window.location.search);
    const error = urlParams.get('error');
    const message = urlParams.get('message');

    if (error) {
        Swal.fire({
            icon: 'error',
            title: 'Error!',
            text: error,
            timer: 3000,
            showConfirmButton: false
        });
    }

    if (message) {
        Swal.fire({
            icon: 'success',
            title: 'Success!',
            text: message,
            timer: 3000,
            showConfirmButton: false
        });
    }
});
</script>
