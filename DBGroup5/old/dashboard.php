<?php
    session_start();

    // Display success/error message if it exists
    if (isset($_SESSION['message'])) {
        echo "<p>" . $_SESSION['message'] . "</p>";
        unset($_SESSION['message']); // Clear the message after displaying it
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
        <button type="submit" name="action" value="clockIn">Clock In</button>
        <button type="submit" name="action" value="clockOut">Clock Out</button>
    </form>
</div>
    
</body>
</html>