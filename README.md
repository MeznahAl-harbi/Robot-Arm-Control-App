# 🤖 Robot Arm Controller (Flutter + PHP + MySQL)

A Flutter application for controlling a robotic arm with a PHP backend and MySQL database.
The project is divided into two main parts:

- **Frontend:** Flutter app (`lib/` and related files).

- **Backend:** PHP scripts + SQL database file (`backend/`).

---
## 📂 Project Structure

```bash
robot_controller_new/
├── lib/                # Flutter code (UI & logic)
│   └── main.dart
├── android/            # Android-specific files
├── ios/                # iOS-specific files
├── pubspec.yaml        # Flutter dependencies
├── backend/            # Backend files (PHP + SQL)
│   ├── api/
│   │   ├── insert_pose.php
│   │   ├── get_run_pose.php
│   │   └── update_status.php
│   └── robot_arm.sql
└── README.md
```
---

## ⚙️ Requirements

- Flutter SDK

- PHP 7 or higher

- MySQL Database

- Local server (e.g., XAMPP, WAMP, or MAMP)

---

### 🚀 Setup Instructions

### 1. Database Setup
1. Open **phpMyAdmin** or MySQL CLI.
2. Create a new database (e.g., `robot_arm_db`).
3. Import the SQL file located at:
 ```bash
  backend/robot_arm.sql
  ```

### 2. Backend Setup
1. Copy the folder `backend/api/` to your local server directory (e.g., `htdocs` in XAMPP).
2. Open the PHP files and update the database connection if needed:
```php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "robot_arm_db";
```
3. Make sure your PHP server (Apache) is running.

### 3. Flutter App Setup

1. Open the project in VS Code or your preferred IDE.

2. In `lib/main.dart`, update the API URL to point to your local server:
 
  ```Dart
    final String apiUrl = "http://192.168.X.X/robot_controller_new/api";
   ```
  - Replace **`192.168.X.X `**with your local IP.

3. Install dependencies and run the app:
  ```bash
  flutter pub get
  flutter run
   ```

---

## 📸  Output


![App Screenshot](Screenshot.png)
