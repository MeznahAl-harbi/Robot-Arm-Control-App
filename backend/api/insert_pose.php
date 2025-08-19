<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "robot_arm";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) die("Connection failed: " . $conn->connect_error);

$motor1 = $_POST['motor1'] ?? 90;
$motor2 = $_POST['motor2'] ?? 90;
$motor3 = $_POST['motor3'] ?? 90;
$motor4 = $_POST['motor4'] ?? 90;

$sql = "INSERT INTO poses (motor1, motor2, motor3, motor4) 
        VALUES ($motor1, $motor2, $motor3, $motor4)";

echo $conn->query($sql) === TRUE ? "Pose saved" : "Error: " . $conn->error;

$conn->close();
?>
