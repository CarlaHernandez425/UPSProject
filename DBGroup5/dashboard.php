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

<div><h3>Upcoming Shifts</h3></div>
    <div>
        <?php
        if (isset($result) && $result->num_rows > 0) {
            echo "<table border='1' style='width: 100%; margin-top: 20px;'>";
            echo "<tr><th>Date</th><th>Scheduled Start</th><th>Scheduled End</th><th>Actual Start</th><th>Actual End</th></tr>";
            while ($row = $result->fetch_assoc()) {
                echo "<tr>";
                echo "<td>" . htmlspecialchars($row['ShiftDate']) . "</td>";
                echo "<td>" . htmlspecialchars($row['ScheduledStart']) . "</td>";
                echo "<td>" . htmlspecialchars($row['ScheduledEnd']) . "</td>";
                echo "<td>" . ($row['ActualStart'] ? htmlspecialchars($row['ActualStart']) : 'Not Started Yet') . "</td>";
                echo "<td>" . ($row['ActualEnd'] ? htmlspecialchars($row['ActualEnd']) : 'Not Ended Yet') . "</td>";
                echo "</tr>";
            }
            echo "</table>";
        } else {
            echo "<p>No upcoming shifts found.</p>";
        }
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
</html>