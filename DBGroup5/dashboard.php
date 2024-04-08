

<?php
    session_start();
    include './private/debug.php';
    require_once './private/db.php';

    // Display success/error message if it exists
    if (isset($_SESSION['message'])) {
        echo "<p>" . $_SESSION['message'] . "</p>";
        unset($_SESSION['message']); // Clear the message after displaying it
    }

    if (!isset($_SESSION['id'])) {
        // Redirect to login page if not logged in
        header('Location: login.php');
        exit();
    }

    // Fetch upcoming shifts for the logged-in employee
    $employeeId = $_SESSION['id'];
    $query = "SELECT ShiftDate, ScheduledStart, ScheduledEnd, ActualStart, ActualEnd
              FROM shifts
              WHERE EmployeeID = ?
              AND ShiftDate >= CURDATE()
              ORDER BY ShiftDate, ScheduledStart ASC";
    if ($stmt = $con->prepare($query)) {
        $stmt->bind_param("i", $employeeId);
        $stmt->execute();
        $result = $stmt->get_result();
    } else {
        echo "Error preparing statement: " . $con->error;
    }
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <style>
        body {
            background-color: #f0f2f5;
        }
        .container {
            padding-top: 20px;
        }
        .shadow-sm {
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
        }
        .rounded-3 {
            border-radius: 0.75rem;
        }
        .mb-4, .my-4 {
            margin-bottom: 1.5rem!important;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="text-center mb-4">
            <a href="manager.php" class="btn btn-primary">Manager Access Portal</a>
        </div>

        <div class="bg-white p-4 shadow-sm rounded-3 mb-4">
            <div><h3>Clock-In / Clock-Out</h3></div>
            <div><b>Employee Name:</b> <?= $_SESSION['name']?> </div>
            <div><b>Employee ID:</b> <?= $_SESSION['id']?> </div>
            <div class="mt-3">
                <form action="clock_action.php" method="post" class="row g-3">
                    <div class="col-auto">
                        <label for="notaries" class="visually-hidden">Notaries:</label>
                        <input type="number" class="form-control" id="notaries" name="notaries" placeholder="Notaries" required>
                    </div>
                    <div class="col-auto">
                        <label for="mailboxes" class="visually-hidden">Mailboxes:</label>
                        <input type="number" class="form-control" id="mailboxes" name="mailboxes" placeholder="Mailboxes" required>
                    </div>
                    <div class="col-auto">
                        <button type="submit" name="action" value="clockIn" id="clockInButton" class="btn btn-primary mb-3">Clock In</button>
                        <button type="submit" name="action" value="clockOut" id="clockOutButton" class="btn btn-secondary mb-3" disabled>Clock Out</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
<!-- Request Time-Off Section -->
<div class="bg-white p-4 shadow-sm rounded-3 mb-4">
    <h3>Request Time-Off</h3>
    <form action="clock_action.php" method="post" class="row g-3">
        <div class="col-md-6">
            <label for="start-date" class="form-label">From:</label>
            <input type="date" id="start-date" name="start_date" class="form-control" required>
        </div>
        <div class="col-md-6">
            <label for="end-date" class="form-label">To:</label>
            <input type="date" id="end-date" name="end_date" class="form-control" required>
        </div>
        <div class="col-12">
            <button type="submit" name="action" value="requestTimeOff" class="btn btn-primary">Submit Request</button>
        </div>
    </form>
</div>

<div class="bg-white p-4 shadow-sm rounded-3 mb-4">
    <h3>Submitted Time-Off Requests</h3>
<?php
// Query for the logged-in employee's vacation requests
$vacationQuery = "SELECT start_date, end_date, status FROM employee_vacations WHERE employee_id = ? ORDER BY request_date DESC";
if ($stmt = $con->prepare($vacationQuery)) {
    $stmt->bind_param('i', $employeeId);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        echo "<table border='1'>";
        echo "<table class='table table-striped'>";
        echo "<tr><th>From</th><th>To</th><th>Status</th></tr>";
        while ($row = $result->fetch_assoc()) {
            echo "<tr>";
            echo "<td>" . htmlspecialchars($row['start_date']) . "</td>";
            echo "<td>" . htmlspecialchars($row['end_date']) . "</td>";
            echo "<td>" . htmlspecialchars($row['status']) . "</td>";
            echo "</tr>";
        }
        echo "</table>";
    } else {
        echo "You have no submitted time-off requests.";
    }
    $stmt->close();
} else {
    echo "Error preparing statement: " . $con->error;
}
?>
</div>
<div class="bg-white p-4 shadow-sm rounded-3 mb-4">
<div><h3>Upcoming Shifts</h3></div>
<div>
    <?php
        // Fetch upcoming shifts for the logged-in employee using distinct variables
        $shiftsQuery = $con->prepare("SELECT ShiftDate, ScheduledStart, ScheduledEnd, ActualStart, ActualEnd
                                      FROM shifts
                                      WHERE EmployeeID = ? AND ShiftDate >= CURDATE()
                                      ORDER BY ShiftDate, ScheduledStart ASC");
        $shiftsQuery->bind_param("i", $employeeId);
        $shiftsQuery->execute();
        $shiftsResult = $shiftsQuery->get_result(); // Use a distinct variable for shifts result
        
        if ($shiftsResult->num_rows > 0) {
            echo "<table border='1' style='width: 100%; margin-top: 20px;'>";
            echo "<table class='table table-striped'>";
            echo "<tr><th>Date</th><th>Scheduled Start</th><th>Scheduled End</th><th>Actual Start</th><th>Actual End</th></tr>";
            while ($shiftRow = $shiftsResult->fetch_assoc()) { // Use a distinct variable for the fetched row
                echo "<tr>";
                echo "<td>" . htmlspecialchars($shiftRow['ShiftDate']) . "</td>";
                echo "<td>" . htmlspecialchars($shiftRow['ScheduledStart']) . "</td>";
                echo "<td>" . htmlspecialchars($shiftRow['ScheduledEnd']) . "</td>";
                echo "<td>" . ($shiftRow['ActualStart'] ? htmlspecialchars($shiftRow['ActualStart']) : 'Not Started Yet') . "</td>";
                echo "<td>" . ($shiftRow['ActualEnd'] ? htmlspecialchars($shiftRow['ActualEnd']) : 'Not Ended Yet') . "</td>";
                echo "</tr>";
            }
            echo "</table>";
        } else {
            echo "<p>No upcoming shifts found.</p>";
        }
        $shiftsQuery->close();
    ?>
</div>
<!-- Offer Shift -->
<div class="bg-white p-4 shadow-sm rounded-3 mb-4">
    <h3>Switch Shift</h3>
    <form action="clock_action.php" method="post" class="row g-3">
        <div class="col-md-6">
            <label for="shift-date" class="form-label">From:</label>
            <input type="date" id="shift-date" name="shift_date" class="form-control" required>
        </div>
        <div class="col-12">
            <button type="submit" name="action" value="switchShift" class="btn btn-primary">Submit Request</button>
        </div>
    </form>
</div>
<!--Available Shifts -->
<div class="bg-white p-4 shadow-sm rounded-3 mb-4">
    <h3>Available Shifts</h3>
    <?php 
        $stmt = $con->prepare("SELECT * FROM shift_switch WHERE SwitchDate >= CURDATE() ORDER BY SwitchDate ASC");
        $stmt->execute();
        $shiftsResult = $stmt->get_result();        
        
        if ($shiftsResult->num_rows > 0) {
            echo "<table border='1' style='width: 100%; margin-top: 20px;'>";
            echo "<table class='table table-striped'>";
            echo "<tr>
                    <th>Available Shift</th>
                    <th>Date Submitted</th>
                    <th>Actions</th>
                 </tr>";
            while ($shiftRow = $shiftsResult->fetch_assoc()) { // Use a distinct variable for the fetched row
                echo "<tr>";
                echo "  <td>" . htmlspecialchars($shiftRow['SwitchDate']) . "</td>";
                echo "  <td>" . htmlspecialchars($shiftRow['RequestDate']) . "</td>";
                echo "<td>";
                $_SESSION['SwitchDate'] = htmlspecialchars($shiftRow['SwitchDate']);
                // Form for accepting the shift switch
                echo "<form action='clock_action.php' method='post'>";
                // Hidden input fields to capture ShiftID and current user's EmployeeID
                echo "<input type='hidden' name='shift_id' value='" . $shiftRow['RequestID'] . "'>";
                echo "<input type='hidden' name='employee_id' value='" . $_SESSION['id'] . "'>";
                echo "<input type='hidden' name='switch_date' value='" . $_SESSION['SwitchDate'] . "'>";
                echo "<button type='submit' name='action' value='acceptShiftSwitch' class='btn btn-primary'>Accept Shift</button>";
                echo "</form>";
                echo "</td>";
                echo "</tr>";
            }
            echo "</table>";
        } else {
            echo "<p>No upcoming shifts found.</p>";
        }
    ?>
</div>


</div>

<script>
    const notariesInput = document.getElementById("notaries");
    const mailboxesInput = document.getElementById("mailboxes");
    const clockOutButton = document.getElementById("clockOutButton");

    function checkInputs() {
        if (notariesInput.value !== "" && mailboxesInput.value !== "") {
            clockOutButton.disabled = false;
        } else {
            clockOutButton.disabled = true;
        }
    }

    notariesInput.addEventListener("input", checkInputs);
    mailboxesInput.addEventListener("input", checkInputs);

    // Check initial state on page load
    checkInputs();
</script>

</body>
</html>
