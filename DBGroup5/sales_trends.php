
<?php
session_start();
include './private/debug.php';
require './private/db.php';

if ($_SESSION['IsAdmin'] == 1 && isset($_POST['trendType'])) {
    $trendType = $_POST['trendType'];
    $query = "";

    switch ($trendType) {
        case 'daily':
            $query = "SELECT Date AS SaleDate, 
                             TotalTendered, 
                             TotalDeposited, 
                             (TotalTendered + TotalDeposited) AS TotalSales
                      FROM DailySales
                      ORDER BY SaleDate DESC";
            break;
        case 'monthly':
            $query = "SELECT YEAR(Date) AS Year, 
                             MONTH(Date) AS Month, 
                             SUM(TotalTendered) AS TotalTendered, 
                             SUM(TotalDeposited) AS TotalDeposited, 
                             SUM(TotalTendered + TotalDeposited) AS TotalSales
                      FROM DailySales
                      GROUP BY YEAR(Date), MONTH(Date)
                      ORDER BY Year DESC, Month DESC";
            break;
        case 'yearly':
            $query = "SELECT YEAR(Date) AS Year, 
                             SUM(TotalTendered) AS TotalTendered, 
                             SUM(TotalDeposited) AS TotalDeposited, 
                             SUM(TotalTendered + TotalDeposited) AS TotalSales
                      FROM DailySales
                      GROUP BY Year
                      ORDER BY Year DESC";
            break;
    }

    $result = mysqli_query($con, $query);
    if ($result && mysqli_num_rows($result) > 0) {
        echo "<table border='1'><tr><th>Date</th><th>Total Sales</th></tr>";
        while ($row = mysqli_fetch_assoc($result)) {
            echo "<tr>";
            switch ($trendType) {
                case 'daily':
                    echo "<td>" . $row['SaleDate'] . "</td>";
                    break;
                case 'monthly':
                    echo "<td>" . $row['Year'] . "-" . sprintf("%02d", $row['Month']) . "</td>";
                    break;
                case 'yearly':
                    echo "<td>" . $row['Year'] . "</td>";
                    break;
            }
            echo "<td>$" . number_format($row['TotalSales'], 2) . "</td>";
            echo "</tr>";
        }
        echo "</table>";
    } else {
        echo "No results found.";
    }
} else {
    echo "You are not authorized or no trend type selected.";
}
?>
