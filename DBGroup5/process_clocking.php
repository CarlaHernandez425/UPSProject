<?php

// Check if the employee has a shift for the current date
$checkShiftQuery = "SELECT * FROM shifts WHERE EmployeeID = ? AND TRIM(ShiftDate) = ?";
if ($checkStmt = $con->prepare($checkShiftQuery)) {
    $checkStmt->bind_param('is', $employeeId, $currentDate);
    $checkStmt->execute();
    $checkResult = $checkStmt->get_result();
    $checkStmt->close();

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

// Continue with clocking in or out
if ($action == 'clockIn') {
    $query = "UPDATE shifts SET ActualStart = ? WHERE EmployeeID = ? AND TRIM(ShiftDate) = ?";
    $successMessage = "Clocked in successfully at " . $formattedTime . ".";
} elseif ($action == 'clockOut') {
    $query = "UPDATE shifts SET ActualEnd = ? WHERE EmployeeID = ? AND TRIM(ShiftDate) = ?";
    $successMessage = "Clocked out successfully at " . $formattedTime . ".";

    // Example for handling bonuses upon clock out, adjust according to your schema and logic
    // Ensure variables like $notaries and $mailboxes are properly validated and sanitized before use
    $notaries = isset($_POST['notaries']) ? $_POST['notaries'] : 0;
    $mailboxes = isset($_POST['mailboxes']) ? $_POST['mailboxes'] : 0;
    if ($notaries >= 0) {
        $bonusType = "Notary";
        $bonusAmount = $notaries;
        // Insert into Bonuses table
        $bonusSQL = "INSERT INTO Bonuses (EmployeeID, BonusType, BonusAmount, BonusDate) VALUES (?,?,?,?)";
        $stmt = $con->prepare($bonusSQL);
        $stmt->bind_param('isds', $employeeId, $bonusType, $bonusAmount, $currentDate);
        $stmt->execute();
    }
    
    // Handle Mailboxes
    if ($mailboxes >= 0) {
        $bonusType = "Mailbox";
        $bonusAmount = $mailboxes;
        // Insert into Bonuses table
        $bonusSQL2 = "INSERT INTO Bonuses (EmployeeID, BonusType, BonusAmount, BonusDate) VALUES (?,?,?,?)";
        $stmt = $con->prepare($bonusSQL2);
        $stmt->bind_param('isds', $employeeId, $bonusType, $bonusAmount, $currentDate);
        $stmt->execute();
    }
} else {
    die('Invalid action.');
}

// Prepare and execute the clocking query
if ($stmt = $con->prepare($query)) {
    $stmt->bind_param('sis', $currentTime, $employeeId, $currentDate);
    $stmt->execute();

    if ($stmt->error) {
        $_SESSION['message'] = "An error occurred: " . $stmt->error;
    } else {
        $_SESSION['message'] = $successMessage;
    }

    $stmt->close();
} else {
    // Handle error in preparing the statement
    $_SESSION['message'] = "Error preparing the clocking SQL statement: " . $con->error;
}

header('Location: dashboard.php');
exit();
