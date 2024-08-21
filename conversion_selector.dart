import 'package:flutter/material.dart';
import 'speed_converter.dart'; // Import your speed converter screen
import 'time_converter.dart'; // Import your time converter screen

class ConversionsSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conversions"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text('Speed Converter', style: TextStyle(fontSize: 18, color: Colors.white)),
              tileColor: Colors.grey[800],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SpeedConverter()),
                );
              },
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text('Time Converter', style: TextStyle(fontSize: 18, color: Colors.white)),
              tileColor: Colors.grey[800],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TimeConverter()),
                );
              },
            ),
            // Add more ListTile items for other conversions if needed
          ],
        ),
      ),
    );
  }
}
