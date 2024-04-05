<?php

session_start();
include './private/debug.php';
require './private/db.php';

// Set the default timezone to Pacific Time
date_default_timezone_set('America/Los_Angeles');

$employeeId = $_SESSION['id'];
$currentDate = date('Y-m-d');

// Debugging
error_log("Attempting to clock in/out. EmployeeID: $employeeId, CurrentDate: $currentDate");

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['action'])) {
    // Check if the employee has a shift for the current date
    $checkShiftQuery = "SELECT * FROM shifts WHERE EmployeeID = ? AND TRIM(ShiftDate) = ?";
    $checkShiftQuery2 = "SELECT * FROM shifts WHERE EmployeeID = "."'$employeeId'"."  AND TRIM(ShiftDate) = "."'$currentDate'";
    // Debugging
    error_log("Prepared check shift query: $checkShiftQuery2");
    if ($checkStmt = $con->prepare($checkShiftQuery)) {
        $checkStmt->bind_param('is', $employeeId, $currentDate);
        $checkStmt->execute();
        $checkResult = $checkStmt->get_result();
        $checkStmt->close();

        // Debugging
        error_log("Rows found: " . $checkResult->num_rows);

        if ($checkResult->num_rows == 0) {
            $_SESSION['message'] = "Error: You are not scheduled today. Please see your manager.";
            header('Location: dashboard.php');
            exit();
        }
    } else {
        // Handle error in preparing the statement
        error_log("MySQL Error: " . $con->error);
        exit('Error in preparing the SQL statement.');
    }
    // If a shift exists for the current date, proceed with clocking in or out
    $currentTime = date('Y-m-d H:i:s');
    $formattedTime = date('H:i:s');
    $action = $_POST['action'];
    $successMessage = "";

    if ($action == 'clockIn') {
        $query = "UPDATE shifts SET ActualStart = ? WHERE EmployeeID = ? AND TRIM(ShiftDate) = ?";
        $successMessage = "Clocked in successfully at " . $formattedTime . ".";
    } elseif ($action == 'clockOut') {
        $query = "UPDATE shifts SET ActualEnd = ? WHERE EmployeeID = ? AND TRIM(ShiftDate) = ?";
        $successMessage = "Clocked out successfully at " . $formattedTime . ".";

        //new code
        $notaries = $_POST['notaries'];
        $mailboxes = $_POST['mailboxes'];
        $bonusIDQuery = "SELECT AUTO_INCREMENT FROM information_schema.TABLES WHERE TABLE_NAME = 'Bonuses'";
        $bonusIDStmt = $con->prepare($bonusIDQuery);
        $bonusIDStmt->execute();
        $bonusIDResult = $bonusIDStmt->get_result();
        $bonusIDRow = $bonusIDResult->fetch_assoc();
        $nextBonusID = $bonusIDRow['AUTO_INCREMENT'];

        if ($notaries >= 0) {
            $bonusType = "Notary";
            $bonusAmount = $notaries;
            $bonusSQL = "INSERT INTO Bonuses (BonusID, EmployeeID, BonusType, BonusAmount, BonusDate) VALUES (?,?,?,?,?)";
            $stmt = $con->prepare($bonusSQL);
            $stmt->bind_param('iisds', $nextBonusID, $employeeId, $bonusType, $bonusAmount, $currentDate);
            $stmt->execute();
        }

        if ($mailboxes >= 0) {
            $bonusType = "Mailbox";
            $bonusAmount = $mailboxes;
            $nextBonusID = $nextBonusID + 1; 
            $bonusSQL2 = "INSERT INTO Bonuses (BonusID, EmployeeID, BonusType, BonusAmount, BonusDate) VALUES (?,?,?,?,?)";
            $stmt = $con->prepare($bonusSQL2);
            $stmt->bind_param('iisds', $nextBonusID, $employeeId, $bonusType, $bonusAmount, $currentDate);
            $stmt->execute();
        }
         // end of new code
    } else {
        die('Invalid action.');
    }

    $stmt = $con->prepare($query);
    $stmt->bind_param('sis', $currentTime, $employeeId, $currentDate);
    $stmt->execute();

    if ($stmt->error) {
        $_SESSION['message'] = "An error occurred: " . $stmt->error;
        $stmt->close();
        header('Location: dashboard.php');
        exit();
    } else {
        // Only set success message if update query was successful
        $_SESSION['message'] = $successMessage;
    }

    $stmt->close();
    header('Location: dashboard.php');
    exit();
}
?>
