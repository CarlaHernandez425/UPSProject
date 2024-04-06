<?php
session_start();
include './private/debug.php';
require './private/db.php';

if ($_SESSION['IsAdmin'] == 1 && isset($_POST['trendType'])) {
    $trendType = $_POST['trendType'];
    $query = "";

    switch ($trendType) {
        case 'daily':
            $query = "SELECT SaleDate, SUM(SaleAmount) AS TotalSales FROM sales GROUP BY SaleDate ORDER BY SaleDate DESC";
            break;
        case 'monthly':
            $query = "SELECT YEAR(SaleDate) AS Year, MONTH(SaleDate) AS Month, SUM(SaleAmount) AS TotalSales
                FROM sales
                GROUP BY YEAR(SaleDate), MONTH(SaleDate)
                ORDER BY Year, Month DESC";
            break;
        case 'yearly':
            $query = "SELECT YEAR(SaleDate) AS Year, SUM(SaleAmount) AS TotalSales FROM sales GROUP BY Year ORDER BY Year DESC";
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
