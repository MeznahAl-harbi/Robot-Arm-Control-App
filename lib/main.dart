import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// This Flutter app allows users to control a 4-motor robotic arm.
// Users can adjust each motor's angle with sliders, save poses locally,
// and send/receive poses to/from a PHP backend server using HTTP requests.

void main() {
  runApp(const RobotArmApp());
}

class RobotArmApp extends StatelessWidget {
  const RobotArmApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Main app scaffold
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Robot Arm Control',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ControlPage(),
    );
  }
}

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  // Current motor values (default = 90°)
  double motor1 = 90, motor2 = 90, motor3 = 90, motor4 = 90;

  // Saved poses (each pose is a list of 4 motor values)
  List<List<int>> savedPoses = [];

  // Replace with your ESP32 / server API endpoint
  final String apiUrl = "http://192.168.8.49/robot_controller_new";

  // ------------------------
  // Main control functions
  // ------------------------

  void savePose() {
    // Save current motor angles locally and send them to the server
    savedPoses.add([
      motor1.toInt(),
      motor2.toInt(),
      motor3.toInt(),
      motor4.toInt(),
    ]);
    setState(() {});
    sendPoseToServer();
  }

  void resetPose() {
    // Reset all motor angles to default (90°)
    setState(() {
      motor1 = motor2 = motor3 = motor4 = 90;
    });
  }

  void runPose(List<int> pose) {
    // Apply a saved pose to the motors
    setState(() {
      motor1 = pose[0].toDouble();
      motor2 = pose[1].toDouble();
      motor3 = pose[2].toDouble();
      motor4 = pose[3].toDouble();
    });
  }

  // ------------------------
  // HTTP Requests Functions
  // ------------------------

  Future<void> sendPoseToServer() async {
    // Send the current motor angles to the PHP backend
    final url = Uri.parse('$apiUrl/insert_pose.php');
    try {
      final response = await http.post(
        url,
        body: {
          'motor1': motor1.toInt().toString(),
          'motor2': motor2.toInt().toString(),
          'motor3': motor3.toInt().toString(),
          'motor4': motor4.toInt().toString(),
        },
      );
      if (response.statusCode == 200) {
        print("Pose saved successfully: ${response.body}");
      } else {
        print("Error saving pose: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception while sending pose: $e");
    }
  }

  Future<void> fetchLastPose() async {
    // Fetch the last saved pose from the PHP backend and apply it
    final url = Uri.parse('$apiUrl/get_run_pose.php');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            motor1 = (data['motor1'] ?? 90).toDouble();
            motor2 = (data['motor2'] ?? 90).toDouble();
            motor3 = (data['motor3'] ?? 90).toDouble();
            motor4 = (data['motor4'] ?? 90).toDouble();
          });
        }
      } else {
        print("Error fetching last pose: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception while fetching pose: $e");
    }
  }

  // ------------------------
  // UI widget for each motor slider
  // ------------------------

  Widget motorSlider(String name, double value, Function(double) onChanged) {
    // Returns a card with a slider for adjusting motor angles
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$name: ${value.toInt()}°", // Display current motor value
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Slider(
              value: value,
              min: 0,
              max: 180,
              divisions: 180,
              activeColor: Colors.deepPurple,
              label: value.toInt().toString(),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------
  // Button style helper
  // ------------------------

  ButtonStyle smallWhiteButtonStyle(Color textColor) {
    // Returns a small white elevated button style with colored text
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: textColor,
      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    );
  }

  // ------------------------
  // Build UI
  // ------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🤖 Robot Arm Control Panel"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Motor sliders
            motorSlider("Motor 1", motor1, (v) => setState(() => motor1 = v)),
            motorSlider("Motor 2", motor2, (v) => setState(() => motor2 = v)),
            motorSlider("Motor 3", motor3, (v) => setState(() => motor3 = v)),
            motorSlider("Motor 4", motor4, (v) => setState(() => motor4 = v)),

            const SizedBox(height: 6),

            // Main control buttons: Reset, Save Pose, Run Last Pose
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: resetPose,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text("Reset"),
                  style: smallWhiteButtonStyle(Colors.deepPurple),
                ),
                ElevatedButton.icon(
                  onPressed: savePose,
                  icon: const Icon(Icons.save, size: 16),
                  label: const Text("Save Pose"),
                  style: smallWhiteButtonStyle(Colors.deepPurple),
                ),
                ElevatedButton.icon(
                  onPressed: fetchLastPose,
                  icon: const Icon(Icons.play_arrow, size: 16),
                  label: const Text("Run"),
                  style: smallWhiteButtonStyle(Colors.deepPurple),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Saved poses title
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "💾 Saved Poses:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),

            // List of saved poses
            Expanded(
              child: savedPoses.isEmpty
                  ? const Center(
                      child: Text(
                        "No poses saved yet",
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  : ListView.builder(
                      itemCount: savedPoses.length,
                      itemBuilder: (context, index) {
                        final pose = savedPoses[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                              "Pose ${index + 1}: ${pose.join(', ')}",
                              style: const TextStyle(fontSize: 12),
                            ),
                            leading: IconButton(
                              icon: const Icon(
                                Icons.play_arrow,
                                color: Colors.blue,
                                size: 20,
                              ),
                              onPressed: () => runPose(pose),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 20,
                              ),
                              onPressed: () {
                                savedPoses.removeAt(index);
                                setState(() {});
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
