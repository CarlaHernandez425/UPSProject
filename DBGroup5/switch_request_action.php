
<?php
session_start();
require_once './private/db.php';
//for switch_request_action.php
if (isset($_POST['action'], $_POST['requestid']) && ($_SESSION['IsAdmin'] == 1)) {
    $requestid = $_POST['requestid'];
    $action = $_POST['action'] == 'approve' ? 'approved' : 'denied';

    $updateQuery = "UPDATE shift_switch SET status = ? WHERE requestid = ?";
    if ($stmt = $con->prepare($updateQuery)) {
        $stmt->bind_param('si', $action,  $requestid);
        $stmt->execute();
        
        if ($stmt->error) {
            $_SESSION['message'] = "Error updating shift switch request: " . $stmt->error;
        } else {
            $_SESSION['message'] = "Shift switch request " . ($action === 'approved' ? 'approved' : 'denied') . " successfully.";
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
