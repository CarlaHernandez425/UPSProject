<?php

session_start();
include './private/debug.php';
require './private/db.php';

// Set the default timezone to Pacific Time
date_default_timezone_set('America/Los_Angeles');

$employeeId = $_SESSION['id'];
$currentDate = date('Y-m-d');
$requestDate = date('Y-m-d'); // Current date in 'Y-m-d' format

// Debugging
error_log("Attempting to clock in/out or request time off. EmployeeID: $employeeId, CurrentDate: $currentDate");

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['action'])) {
    $action = $_POST['action'];
    $currentTime = date('Y-m-d H:i:s');
    $formattedTime = date('H:i:s');
    
    if ($action === 'requestTimeOff') {
        // Assuming start_date and end_date are provided as 'Y-m-d' format
        $startDate = $_POST['start_date'];
        $endDate = $_POST['end_date'];
        $requestDate = date('Y-m-d'); // Current date in 'Y-m-d' format
    
        $vacationQuery = "INSERT INTO employee_vacations (employee_id, request_date, start_date, end_date, status) VALUES (?, ?, ?, ?, 'pending')";
        if ($vacationStmt = $con->prepare($vacationQuery)) {
            // Now also binding $requestDate to the query
            $vacationStmt->bind_param('isss', $employeeId, $requestDate, $startDate, $endDate);
            $vacationStmt->execute();
    
            if ($vacationStmt->error) {
                $_SESSION['message'] = "Error submitting time-off request: " . $vacationStmt->error;
            } else {
                $_SESSION['message'] = "Time-off request submitted successfully.";
            }
            $vacationStmt->close();
        } else {
            // Handle error in preparing the statement
            error_log("MySQL Error: " . $con->error);
            $_SESSION['message'] = "Error in preparing the time-off request SQL statement.";
        }
    
        header('Location: dashboard.php');
        exit();
    }
            //shift switching based off of vacation request
    if ($action === 'switchShift') {
            $switchdate = $_POST['shift_date'];
            $requestDate = date('Y-m-d');
    
            $switchQuery = "INSERT INTO shift_switch (employeeid, switchdate, requestdate, status) VALUES(?, ?, ?, 'pending')";
            if ($switchStmt = $con->prepare($switchQuery)) {
                $switchStmt->bind_param('iss', $employeeId, $switchdate, $requestDate);
                $switchStmt->execute();
    
                if ($switchStmt->error) {
                    $_SESSION['message'] = "Error submitting shift for switching:" . $switchStmt->error;
                } else {
                    $_SESSION['message'] = "Shift switch submitted successfully.";
                }
                $switchStmt->close();
            } else {
                //error in preparing statement
                error_log("MySQL Error: " . $con->error);
                $_SESSION['message'] = "Error in preparing the shift-switch request SQL statement.";
            }
            
            header('Location: dashboard.php');
            exit();
        }
    if ($action === 'acceptShiftSwitch') {
            // Get the ShiftID and current user's EmployeeID from the form submission
            $shiftId = $_POST['shift_id'];
            $employeeId = $_POST['employee_id'];
    
            // Update the shifts table to replace the EmployeeID with the current user's EmployeeID
            $updateShiftQuery = "UPDATE shifts SET EmployeeID = ? WHERE ShiftID = ?";
            if ($updateStmt = $con->prepare($updateShiftQuery)) {
                // Bind parameters and execute the query
                $updateStmt->bind_param('ii', $employeeId, $shiftId);
                $updateStmt->execute();
            
                // Check for errors and set session message accordingly
                if ($updateStmt->error) {
                    $_SESSION['message'] = "Error accepting shift switch: " . $updateStmt->error;
                } else {
                    $_SESSION['message'] = "Shift switch accepted successfully.";
                }
    
                // Close the statement
                $updateStmt->close();
            } else {
                // Handle error in preparing the statement
                error_log("MySQL Error: " . $con->error);
                $_SESSION['message'] = "Error in preparing the shift switch accept statement.";
            }
    
            // Redirect to dashboard.php after processing
            header('Location: dashboard.php');
            exit();
        }
    
    // Proceed with clocking in or out logic if not a time-off request
    include './process_clocking.php'; // Assumes clocking logic is moved to a separate include file for cleanliness
}

?>
