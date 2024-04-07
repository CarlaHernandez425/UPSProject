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
</head>
<body>

<div style="text-align: center;">
    <a href="manager.php">Manager Access Portal</a>
</div>

<div><h3>Clock-In / Clock-Out</h3></div>
<div><b>Employee Name:</b> <?= $_SESSION['name']?> </div>
<div><b>Employee ID:</b> <?= $_SESSION['id']?> </div>
<div>
    <form action="clock_action.php" method="post">
        <label for="notaries">Notaries:</label>
        <input type="number" id="notaries" name="notaries" required><br>
        <label for="mailboxes">Mailboxes:</label>
        <input type="number" id="mailboxes" name="mailboxes" required><br>
        <button type="submit" name="action" value="clockIn" id="clockInButton">Clock In</button>
        <button type="submit" name="action" value="clockOut" id="clockOutButton" disabled>Clock Out</button>
    </form>
</div>

<!-- Request Time-Off Section -->
<div><h3>Request Time-Off</h3></div>
<div>
    <form action="clock_action.php" method="post">
        <div>
            <label for="start-date">From:</label>
            <input type="date" id="start-date" name="start_date" required>
        </div>
        <div>
            <label for="end-date">To:</label>
            <input type="date" id="end-date" name="end_date" required>
        </div>
        <button type="submit" name="action" value="requestTimeOff">Submit Request</button>
    </form>
</div>

<?php
echo "<h3>Submitted Time-Off Requests</h3>";

// Query for the logged-in employee's vacation requests
$vacationQuery = "SELECT start_date, end_date, status FROM employee_vacations WHERE employee_id = ? ORDER BY request_date DESC";
if ($stmt = $con->prepare($vacationQuery)) {
    $stmt->bind_param('i', $employeeId);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        echo "<table border='1'>";
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
