<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "robot_arm";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "UPDATE status SET is_running=0 WHERE id=1";
if ($conn->query($sql) === TRUE) {
    echo "Status updated successfully";
} else {
    echo "Error: " . $conn->error;
}

$conn->close();
?>
