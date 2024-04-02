<?php

$host      = "localhost:3306";
$user      = "root";  
$password  = "root";
$db_name   = "dbgroup5";   
$con       = mysqli_connect ( $host, $user, $password, $db_name);

if ( !$con ) {
    die ( "Database connection error: " . mysqli_connect_error() );
}
