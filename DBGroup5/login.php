<?php

session_start();
include './private/debug.php';
require_once './private/db.php';

// Check if the form is submitted
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Retrieve the submitted username and password
    $username = $_SESSION['username'] = $_POST['username'];
    $password = $_POST['password'];

    // Create the SQL query using prepared statements
    $stmt = $con->prepare("SELECT * FROM employees WHERE Username = ? LIMIT 1");
    $stmt->bind_param("s", $username); // 's' specifies the variable type => 'string'

    // Execute the query
    $stmt->execute();
    $result = $stmt->get_result();
    

    if ($result && $result->num_rows > 0) {
        $user = $result->fetch_assoc();
        
        if ($password == $user['Password']) {
            // echo "Login successful. Welcome, " . htmlspecialchars($username) . "!";
            // Redirect or set session variables as needed
            $_SESSION['id'] = $user['EmployeeID'];
            $_SESSION['name'] = $user['FirstName'] . ' ' . $user['LastName'];
            if ($user['IsAdmin'] == 1) {
                $_SESSION['IsAdmin'] = TRUE;
            } else {
                $_SESSION['IsAdmin'] = FALSE;
            }
            header('Location: dashboard.php');
            // exit();
        } else {
            echo "Invalid username or password.";
        }
    } else {
        echo "Invalid username or password.";
    }

    // Close the database connection
    $stmt->close();
    $con->close();
} else {
    // Redirect to the login form if not submitted
    header('Location: login.php');
    exit();
}
?>



