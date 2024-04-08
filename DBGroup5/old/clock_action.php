<?php

session_start();
include './private/debug.php';
require './private/db.php';

// Assuming you have a way to identify the employee (e.g., from a session)
session_start();
$employeeId = $_SESSION['id']; 
$currentDate = date('Y-m-d');

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['action'])) {
    $currentTime = date('Y-m-d H:i:s');
    $action = $_POST['action'];

    if ($action == 'clockIn') {
        $query = "UPDATE shifts SET ActualStart = ? WHERE EmployeeID = ? AND ShiftDate = ?";
        $successMessage = "Clocked in successfully.";
    } elseif ($action == 'clockOut') {
        $query = "UPDATE shifts SET ActualEnd = ? WHERE EmployeeID = ? AND ShiftDate = ?";
        $successMessage = "Clocked out successfully.";
    } else {
        die('Invalid action.');
    }

    $stmt = $con->prepare($query);
    $stmt->bind_param('sis', $currentTime, $employeeId, $currentDate);
    $stmt->execute();

    if ($stmt->error) {
        $_SESSION['message'] = "An error occurred: " . $stmt->error;
    } else {
        $_SESSION['message'] = $successMessage;
    }

    $stmt->close();
    header('Location: dashboard.php');
    exit();
}
