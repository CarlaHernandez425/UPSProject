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

    $bonusIDQuery = "SELECT AUTO_INCREMENT FROM information_schema.TABLES WHERE TABLE_NAME = 'Bonuses'";
    $bonusIDStmt = $con->prepare($bonusIDQuery);
    $bonusIDStmt->execute();
    $bonusIDResult = $bonusIDStmt->get_result();
    $bonusIDRow = $bonusIDResult->fetch_assoc();
    $nextBonusID = $bonusIDRow['AUTO_INCREMENT'];

    $notaryIDQuery = "SELECT AUTO_INCREMENT FROM information_schema.TABLES WHERE TABLE_NAME = 'notaries'";
    $notaryIDStmt = $con->prepare($notaryIDQuery);
    $notaryIDStmt->execute();
    $notaryIDResult = $notaryIDStmt->get_result();
    $notaryIDRow = $notaryIDResult->fetch_assoc();
    $nextNotaryID = $notaryIDRow['AUTO_INCREMENT'];

    $mailboxIDQuery = "SELECT AUTO_INCREMENT FROM information_schema.TABLES WHERE TABLE_NAME = 'mailboxes'";
    $mailboxIDStmt = $con->prepare($mailboxIDQuery);
    $mailboxIDStmt->execute();
    $mailboxIDResult = $mailboxIDStmt->get_result();
    $mailboxIDRow = $mailboxIDResult->fetch_assoc();
    $nextMailboxID = $mailboxIDRow['AUTO_INCREMENT'];

    $notaries = isset($_POST['notaries']) ? $_POST['notaries'] : 0;
    $mailboxes = isset($_POST['mailboxes']) ? $_POST['mailboxes'] : 0;

    if ($notaries >= 0) {
        // Insert bonus logic here
        $bonusType = "Notary";
        $bonusAmount = $notaries;
        $bonusSQL = "INSERT INTO Bonuses (BonusID, EmployeeID, BonusType, BonusAmount, BonusDate) VALUES (?,?,?,?,?)";
        $stmt = $con->prepare($bonusSQL);
        $stmt->bind_param('iisds', $nextBonusID, $employeeId, $bonusType, $bonusAmount, $currentDate);
        $stmt->execute();
        $notarySQL = "INSERT INTO notaries (NotaryID, EmployeeID, Date, BonusID) VALUES (?,?,?,?)";
        $stmt = $con->prepare($notarySQL);
        $stmt->bind_param('iisi', $nextNotaryID, $employeeId, $currentDate, $nextBonusID);
        $stmt->execute();
    }

    if ($mailboxes >= 0) {
        // Insert bonus logic here
        $bonusType = "Mailbox";
        $bonusAmount = $mailboxes;
        $nextBonusID = $nextBonusID + 1; 
        $bonusSQL2 = "INSERT INTO Bonuses (BonusID, EmployeeID, BonusType, BonusAmount, BonusDate) VALUES (?,?,?,?,?)";
        $stmt = $con->prepare($bonusSQL2);
        $stmt->bind_param('iisds', $nextBonusID, $employeeId, $bonusType, $bonusAmount, $currentDate);
        $stmt->execute();
        $mailboxSQL = "INSERT INTO mailboxes (MailboxID, EmployeeID, StartDate, BonusID) VALUES (?,?,?,?)";
        $stmt = $con->prepare($mailboxSQL);
        $stmt->bind_param('iisi', $nextMailboxID, $employeeId, $currentDate, $nextBonusID);
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
