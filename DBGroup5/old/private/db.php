<?php

$host      = "127.0.0.1:3306"; //localhost:3306;
$user      = "u803325201_comp420admin"; // comp420admin
$password  = "Csucicomp420"; // same
$db_name   = "u803325201_DBGroup5"; // DBGroup5
$con       = mysqli_connect ( $host, $user, $password, $db_name);

if ( !$con ) {
    die ( "Database connection error: " . mysqli_connect_error() );
}
