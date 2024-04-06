<?php

session_start();
include './private/debug.php';
require './private/db.php';

if ($_SESSION['IsAdmin'] == 1) {

    // QUERY ALL EMPLOYEES
    $query_emp = "SELECT * FROM employees"; // Query to fetch all employees
    $result_emp = mysqli_query($con, $query_emp); // Execute the query

    ?>

        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Dashboard</title>
        </head>
        <body>

            <div>
                <h1>Staff List</h1>
            </div>
            <div>
            <?php
                if ($result_emp) {
                // Check if there are any results
                if (mysqli_num_rows($result_emp) > 0) {
                    // Start the table and add the header
                    echo "<table border='1'>";
                    echo "<tr>";
                    echo "<th>Name</th>"; // Assuming you have an ID column
                    echo "<th>Position</th>"; // Add headers for other columns as needed
                    // Repeat the above line for each column in your table
                    echo "</tr>";

                    // Output data of each row
                    while($row = mysqli_fetch_assoc($result_emp)) {
                        echo "<tr>";
                        echo "<td>" . $row["FirstName"] . ' ' .  $row["LastName"] . "</td>"; // Replace 'id' with the actual column name
                        echo "<td>" . $row["Position"] . "</td>"; // Replace 'name' with the actual column name
                        // Repeat the above line for each column you wish to display
                        echo "</tr>";
                    }
                    echo "</table>";
                } else {
                    echo "0 results found.";
                }
            } else {
                echo "Error executing query: " . mysqli_error($con);
            }

            ?>
                
            </div>

            <?php

        echo "<div><h1>Staff Shifts</h1></div>";

        // Explicitly set $currentMonth to the first day of the current month to avoid timezone or time-related issues.
        $currentMonth = new DateTime('first day of this month');

        for ($offset = -1; $offset <= 1; $offset++) {
            // Clone the $currentMonth DateTime object and apply the offset to get the correct month.
            $dt = (clone $currentMonth)->modify("$offset month");
            $year = $dt->format("Y");
            $month = $dt->format("n");
            $monthName = $dt->format('F');

            // Prepare and execute your SQL query here
            $query = "SELECT e.FirstName, e.LastName, s.ShiftDate, s.TotalHours
                    FROM employees e
                    JOIN shifts s ON e.EmployeeID = s.EmployeeID
                    WHERE YEAR(s.ShiftDate) = ? AND MONTH(s.ShiftDate) = ?
                    ORDER BY s.ShiftDate, e.FirstName, e.LastName";

            $stmt = $con->prepare($query);
            $stmt->bind_param("ii", $year, $month);
            $stmt->execute();
            $result = $stmt->get_result();

            $shiftsByMonthDay = [];
            while ($row = $result->fetch_assoc()) {
                $dateObj = new DateTime($row["ShiftDate"]);
                $day = $dateObj->format("j");
                $shiftsByMonthDay[$day][] = $row;
            }

            $stmt->close();

            // Display the calendar for the month
            echo "<h2>$monthName $year</h2>";
            echo "<table border='1'>";
            echo "<tr><th>Sunday</th><th>Monday</th><th>Tuesday</th><th>Wednesday</th><th>Thursday</th><th>Friday</th><th>Saturday</th></tr>";

            $daysInMonth = cal_days_in_month(CAL_GREGORIAN, $month, $year);
            $firstDayOfMonth = new DateTime("$year-$month-01");
            $firstWeekday = (int)$firstDayOfMonth->format('w');
            $weeksInMonth = ceil(($firstWeekday + $daysInMonth) / 7);

            for ($week = 0; $week < $weeksInMonth; $week++) {
                echo "<tr>";
                for ($dayOfWeek = 0; $dayOfWeek < 7; $dayOfWeek++) {
                    $currentDayNum = $week * 7 + $dayOfWeek - $firstWeekday + 1;
                    
                    if ($currentDayNum <= 0 || $currentDayNum > $daysInMonth) {
                        echo "<td></td>"; // Empty cell for days outside the month
                    } else {
                        echo "<td>";
                        echo "<b>$currentDayNum</b><br>";
                        if (isset($shiftsByMonthDay[$currentDayNum])) {
                            foreach ($shiftsByMonthDay[$currentDayNum] as $shift) {
                                echo htmlspecialchars($shift["FirstName"]) . " " . htmlspecialchars($shift["LastName"]) . ": " . $shift["TotalHours"] . " hrs<br>";
                            }
                        }
                        echo "</td>";
                    }
                }
                echo "</tr>";
            }

            echo "</table><br>"; // Space between months
        }
        //Sales Trends Section
        // Dropdown for selecting the trend type
        echo "<div>";
        echo "<h1>Select Sales Trend Period</h1>";
        echo "<select id='trendSelect'>
                <option value='daily'>Daily</option>
                <option value='monthly'>Monthly</option>
                <option value='yearly'>Yearly</option>
            </select>";
        echo "</div>";

        // Container to display trend results
        echo "<div id='trendResults'></div>";

        ?>
        <script>
        document.getElementById('trendSelect').addEventListener('change', function() {
            var trendType = this.value;
            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'sales_trends.php', true);
            xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');

            xhr.onload = function() {
                if (this.status == 200) {
                    document.getElementById('trendResults').innerHTML = this.responseText;
                } else {
                    document.getElementById('trendResults').innerHTML = "Error loading data.";
                }
            };

            xhr.send('trendType=' + trendType);
        });
        </script>

        </body>
        </html>
        
        <?php

        } else {

            echo '<h3>You are not authorized to view this page</h3>';
            echo 'Back to employee dashboard <-- make a link here!'; 
        }
    ?>





