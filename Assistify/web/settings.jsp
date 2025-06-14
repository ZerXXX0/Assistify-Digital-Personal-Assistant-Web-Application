<%-- Settings Content Only --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="config.DB"%>
<%@page import="java.sql.ResultSet"%>

<%
// Get current user's notification settings
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
    e.printStackTrace();
} finally {
    db.disconnect();
}
%>

<!-- Page Header -->
<div class="page-header">
    <div class="page-title-section">
        <h1>
            <i class="fas fa-cog"></i>
            Settings
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

<!-- Settings Grid -->
<div class="settings-grid">
    <!-- Profile Setting Card -->
    <div class="settings-card">
        <div class="card-header">
            <div class="card-icon">
                <i class="fas fa-user"></i>
            </div>
            <h3 class="card-title">Profile Setting</h3>
        </div>
        
        <div class="profile-picture-section">
            <div class="profile-picture">
                <i class="fas fa-user"></i>
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
            <a href="HomeServlet?page=edit_profile" class="btn btn-primary">
                <i class="fas fa-edit"></i> Edit Profile
            </a>
        </form>
    </div>

    <!-- Notification Setting Card -->
    <div class="settings-card">
        <div class="card-header">
            <div class="card-icon">
                <i class="fas fa-bell"></i>
            </div>
            <h3 class="card-title">Notification Setting</h3>
        </div>
        
        <div class="form-group mb-3">
            <label for="alarmSoundSelect" class="form-label">Alarm Ringtone</label>
            <select class="form-control" id="alarmSoundSelect">
                <option value="1" <%= alarmSound == 1 ? "selected" : "" %>>Classic Alarm</option>
                <option value="2" <%= alarmSound == 2 ? "selected" : "" %>>Morning Bell</option>
                <option value="3" <%= alarmSound == 3 ? "selected" : "" %>>Gentle Wake</option>
                <option value="4" <%= alarmSound == 4 ? "selected" : "" %>>Digital Beep</option>
            </select>
            <button type="button" class="btn btn-sm btn-outline-primary mt-2" id="previewAlarmBtn" onclick="previewAlarmSound()">
                <i class="fas fa-play"></i> Preview Alarm Sound
            </button>
        </div>
        
        <div class="form-group mb-3">
            <label for="notificationSoundSelect" class="form-label">Reminder Notification Sound</label>
            <select class="form-control" id="notificationSoundSelect">
                <option value="1" <%= notificationSound == 1 ? "selected" : "" %>>Soft Chime</option>
                <option value="2" <%= notificationSound == 2 ? "selected" : "" %>>Notification Bell</option>
                <option value="3" <%= notificationSound == 3 ? "selected" : "" %>>Gentle Ping</option>
                <option value="4" <%= notificationSound == 4 ? "selected" : "" %>>Alert Tone</option>
            </select>
            <button type="button" class="btn btn-sm btn-outline-primary mt-2" id="previewNotificationBtn" onclick="previewNotificationSound()">
                <i class="fas fa-play"></i> Preview Notification Sound
            </button>
        </div>
        
        <button type="button" class="btn btn-primary" onclick="updateNotificationSettings()">
            <i class="fas fa-save"></i> Save Settings
        </button>
    </div>

    <!-- Danger Zone Card - Full width -->
    <div class="settings-card full-width">
        <div class="card-header">
            <div class="card-icon" style="background-color: #dc3545;">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <h3 class="card-title">Danger Zone</h3>
        </div>
        
        <div class="row">
            <div class="col-md-6">
                <button type="button" class="btn btn-danger w-100 mb-3" onclick="confirmLogout()">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </button>
            </div>
            <div class="col-md-6">
                <button type="button" class="btn btn-danger w-100 mb-3" onclick="confirmDeleteAccount()">
                    <i class="fas fa-trash"></i> Delete Account
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Audio elements for preview -->
<audio id="previewAudio" preload="none"></audio>

<script>
// Global variables for audio control
let currentPreviewTimeout = null;
let isPreviewPlaying = false;

// Debug function to check if elements exist
function checkElements() {
    const alarmSelect = document.getElementById('alarmSoundSelect');
    const notificationSelect = document.getElementById('notificationSoundSelect');
    
    console.log('Alarm select element:', alarmSelect);
    console.log('Notification select element:', notificationSelect);
    
    if (alarmSelect) {
        console.log('Alarm select value:', alarmSelect.value);
    } else {
        console.error('Alarm select element not found!');
    }
    
    if (notificationSelect) {
        console.log('Notification select value:', notificationSelect.value);
    } else {
        console.error('Notification select element not found!');
    }
}

// Stop current preview
function stopCurrentPreview() {
    const audio = document.getElementById('previewAudio');
    if (audio) {
        audio.pause();
        audio.currentTime = 0;
    }
    
    if (currentPreviewTimeout) {
        clearTimeout(currentPreviewTimeout);
        currentPreviewTimeout = null;
    }
    
    isPreviewPlaying = false;
    
    // Reset button texts
    const alarmBtn = document.getElementById('previewAlarmBtn');
    const notificationBtn = document.getElementById('previewNotificationBtn');
    
    if (alarmBtn) {
        alarmBtn.innerHTML = '<i class="fas fa-play"></i> Preview Alarm Sound';
        alarmBtn.disabled = false;
    }
    
    if (notificationBtn) {
        notificationBtn.innerHTML = '<i class="fas fa-play"></i> Preview Notification Sound';
        notificationBtn.disabled = false;
    }
}

// Preview alarm sound function
function previewAlarmSound() {
    if (isPreviewPlaying) {
        stopCurrentPreview();
        return;
    }
    
    const alarmSelect = document.getElementById('alarmSoundSelect');
    if (!alarmSelect) {
        console.error('Alarm select element not found');
        return;
    }
    
    const soundNumber = alarmSelect.value;
    console.log('Previewing alarm sound:', soundNumber);
    
    // Validate sound number
    if (!soundNumber || soundNumber === '' || soundNumber === 'undefined') {
        console.error('Invalid sound number:', soundNumber);
        return;
    }
    
    playSound(soundNumber, 'alarm');
}

// Preview notification sound function
function previewNotificationSound() {
    if (isPreviewPlaying) {
        stopCurrentPreview();
        return;
    }
    
    const notificationSelect = document.getElementById('notificationSoundSelect');
    if (!notificationSelect) {
        console.error('Notification select element not found');
        return;
    }
    
    const soundNumber = notificationSelect.value;
    console.log('Previewing notification sound:', soundNumber);
    
    // Validate sound number
    if (!soundNumber || soundNumber === '' || soundNumber === 'undefined') {
        console.error('Invalid sound number:', soundNumber);
        return;
    }
    
    playSound(soundNumber, 'notification');
}

// Play sound function with 7-second limit
function playSound(soundNumber, type) {
    // Ensure soundNumber is a string and not empty
    const soundNum = String(soundNumber).trim();
    
    if (!soundNum || soundNum === '' || soundNum === 'undefined' || soundNum === 'null') {
        console.error('Invalid sound number for playSound:', soundNumber);
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Invalid sound selection. Please select a valid sound.',
            timer: 3000,
            showConfirmButton: false
        });
        return;
    }
    
    const audio = document.getElementById('previewAudio');
    
    // Build the sound path using proper string concatenation
    let soundPath;
    if (type === 'alarm'){
        soundPath = 'assets/sound/alarm/' + soundNum + '.mp3';
    } else {
        soundPath = 'assets/sound/notif/' + soundNum + '.mp3';
    }
    
    
    console.log('Playing sound:', soundPath, 'for type:', type);
    console.log('Sound number used:', soundNum);
    
    // Stop any current preview
    stopCurrentPreview();
    
    // Set playing state
    isPreviewPlaying = true;
    
    // Update button text based on type
    const btnId = type === 'alarm' ? 'previewAlarmBtn' : 'previewNotificationBtn';
    const btn = document.getElementById(btnId);
    if (btn) {
        btn.innerHTML = '<i class="fas fa-stop"></i> Stop Preview';
        btn.disabled = false;
    }
    
    // Set the source and load
    audio.src = soundPath;
    audio.load(); // Force reload
    
    // Attempt to play
    const playPromise = audio.play();
    
    if (playPromise !== undefined) {
        playPromise.then(() => {
            console.log('Audio playing successfully');
            
            // Set timeout to stop after 7 seconds
            currentPreviewTimeout = setTimeout(() => {
                console.log('Stopping preview after 7 seconds');
                stopCurrentPreview();
            }, 7000); // 7 seconds
            
        }).catch(e => {
            console.error('Error playing preview sound:', e);
            console.error('Failed sound path:', soundPath);
            stopCurrentPreview();
            Swal.fire({
                icon: 'warning',
                title: 'Audio Preview',
                text: `Could not play ${type} sound ${soundNum}. Audio file may not exist: ${soundPath}`,
                timer: 4000,
                showConfirmButton: false
            });
        });
    }
    
    // Also stop when audio ends naturally
    audio.addEventListener('ended', stopCurrentPreview, { once: true });
}

// Update notification settings with proper form data
function updateNotificationSettings() {
    // Check elements first
    checkElements();
    
    const alarmSelect = document.getElementById('alarmSoundSelect');
    const notificationSelect = document.getElementById('notificationSoundSelect');
    
    if (!alarmSelect || !notificationSelect) {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Could not find sound selection elements. Please refresh the page.',
            showConfirmButton: true
        });
        return;
    }
    
    const alarmSound = alarmSelect.value;
    const notificationSound = notificationSelect.value;
    
    console.log('Updating settings - Alarm:', alarmSound, 'Notification:', notificationSound);
    
    // Validate values
    if (!alarmSound || !notificationSound || alarmSound === '' || notificationSound === '') {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Please select both alarm and notification sounds.',
            showConfirmButton: true
        });
        return;
    }
    
    Swal.fire({
        title: 'Updating Settings...',
        text: 'Please wait while we save your notification preferences.',
        allowOutsideClick: false,
        didOpen: () => {
            Swal.showLoading();
        }
    });
    
    // Create URL encoded form data (not FormData for better compatibility)
    const params = new URLSearchParams();
    params.append('alarmSound', alarmSound);
    params.append('notificationSound', notificationSound);
    
    console.log('Sending parameters:', params.toString());
    
    fetch('UpdateNotificationSettingsServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params.toString()
    })
    .then(response => {
        console.log('Response status:', response.status);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.text();
    })
    .then(data => {
        console.log('Response data:', data);
        Swal.close();
        if (data.includes('success')) {
            Swal.fire({
                icon: 'success',
                title: 'Settings Updated!',
                text: 'Your notification preferences have been saved.',
                timer: 3000,
                showConfirmButton: false
            });
        } else {
            throw new Error('Update failed: ' + data);
        }
    })
    .catch(error => {
        console.error('Update error:', error);
        Swal.close();
        Swal.fire({
            icon: 'error',
            title: 'Update Failed',
            text: 'Could not save your settings. Error: ' + error.message,
            showConfirmButton: true
        });
    });
}

// Confirmation functions
function confirmLogout() {
    Swal.fire({
        title: 'Are you sure?',
        text: "You will be logged out of your account",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#ff3b65',
        cancelButtonColor: '#6c757d',
        confirmButtonText: 'Yes, logout!'
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = 'logout';
        }
    });
}

function confirmDeleteAccount() {
    Swal.fire({
        title: 'Delete Account',
        html: `
            <div class="text-start">
                <div class="alert alert-danger" role="alert">
                    <strong>Warning!</strong> This action cannot be undone. All your data will be permanently deleted.
                </div>
                <div class="mb-3">
                    <label for="deletePassword" class="form-label">Enter your password to confirm:</label>
                    <input type="password" class="form-control" id="deletePassword" placeholder="Password">
                </div>
                <div class="mb-3">
                    <label for="confirmDelete" class="form-label">Type "DELETE" to confirm:</label>
                    <input type="text" class="form-control" id="confirmDelete" placeholder="DELETE">
                </div>
            </div>
        `,
        showCancelButton: true,
        confirmButtonColor: '#dc3545',
        cancelButtonColor: '#6c757d',
        confirmButtonText: 'Delete Account',
        preConfirm: () => {
            const password = document.getElementById('deletePassword').value;
            const confirmText = document.getElementById('confirmDelete').value;
            
            if (!password) {
                Swal.showValidationMessage('Please enter your password');
                return false;
            }
            
            if (confirmText !== 'DELETE') {
                Swal.showValidationMessage('Please type "DELETE" exactly to confirm');
                return false;
            }
            
            return { password: password, confirmText: confirmText };
        }
    }).then((result) => {
        if (result.isConfirmed) {
            // Create a form and submit it
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'DeleteUserServlet';
            
            const passwordInput = document.createElement('input');
            passwordInput.type = 'hidden';
            passwordInput.name = 'password';
            passwordInput.value = result.value.password;
            
            const confirmInput = document.createElement('input');
            confirmInput.type = 'hidden';
            confirmInput.name = 'confirmDelete';
            confirmInput.value = result.value.confirmText;
            
            form.appendChild(passwordInput);
            form.appendChild(confirmInput);
            document.body.appendChild(form);
            form.submit();
        }
    });
}

// Handle success/error messages with SweetAlert2
document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM loaded, checking elements...');
    checkElements();
    
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
