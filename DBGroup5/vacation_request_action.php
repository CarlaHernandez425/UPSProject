<?php
session_start();
require_once './private/db.php';

if (isset($_POST['action'], $_POST['vacation_id']) && ($_SESSION['IsAdmin'] == 1)) {
    $vacationId = $_POST['vacation_id'];
    $action = $_POST['action'] == 'approve' ? 'approved' : 'denied';
    $approvalDate = date('Y-m-d'); // Current date

    $updateQuery = "UPDATE employee_vacations SET status = ?, approval_date = ? WHERE vacation_id = ?";
    if ($stmt = $con->prepare($updateQuery)) {
        $stmt->bind_param('ssi', $action, $approvalDate, $vacationId);
        $stmt->execute();
        
        if ($stmt->error) {
            $_SESSION['message'] = "Error updating vacation request: " . $stmt->error;
        } else {
            $_SESSION['message'] = "Vacation request " . ($action === 'approved' ? 'approved' : 'denied') . " successfully.";
        }
        $stmt->close();
    } else {
        $_SESSION['message'] = "Error preparing update statement: " . $con->error;
    }
} else {
    $_SESSION['message'] = "Unauthorized action or insufficient data provided.";
}

header('Location: manager.php');
exit();
?>
