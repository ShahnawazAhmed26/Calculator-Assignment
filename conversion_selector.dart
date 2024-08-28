import 'package:flutter/material.dart';
import 'speed_converter.dart';
import 'time_converter.dart';
import 'distance_converter.dart';
import 'temperature_converter.dart';
import 'volume_converter.dart';
import 'mass_converter.dart';
import 'area_converter.dart';
import 'currency_converter.dart';
import 'energy_converter.dart';
import 'power_converter.dart';
import 'data_converter.dart';
import 'pressure_converter.dart';
import 'angle_converter.dart';

class ConversionsSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conversions"),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildConversionTile(
              title: 'Angle Converter',
              icon: Icons.rotate_left,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AngleConverter()),
                );
              },
            ),
            _buildConversionTile(
              title: 'Area Converter',
              icon: Icons.crop_square,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AreaConverter()),
                );
              },
            ),
            _buildConversionTile(
              title: 'Currency Converter',
              icon: Icons.monetization_on,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CurrencyConverter()),
                );
              },
            ),
            _buildConversionTile(
              title: 'Data Converter',
              icon: Icons.data_usage,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DataConverter()),
                );
              },
            ),
            _buildConversionTile(
              title: 'Distance Converter',
              icon: Icons.map,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DistanceConverter()),
                );
              },
            ),
            _buildConversionTile(
              title: 'Energy Converter',
              icon: Icons.flash_on,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EnergyConverter()),
                );
              },
            ),
            _buildConversionTile(
              title: 'Mass Converter',
              icon: Icons.monitor_weight,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MassConverter()),
                );
              },
            ),
            _buildConversionTile(
              title: 'Power Converter',
              icon: Icons.power,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PowerConverter()),
                );
              },
            ),
            _buildConversionTile(
              title: 'Pressure Converter',
              icon: Icons.compress,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PressureConverter()),
                );
              },
            ),
            _buildConversionTile(
              title: 'Speed Converter',
              icon: Icons.speed,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SpeedConverter()),
                );
              },
            ),
            _buildConversionTile(
              title: 'Temperature Converter',
              icon: Icons.thermostat,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TemperatureConverter()),
                );
              },
            ),
            _buildConversionTile(
              title: 'Volume Converter',
              icon: Icons.liquor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VolumeConverter()),
                );
              },
            ),
            _buildConversionTile(
              title: 'Time Converter',
              icon: Icons.access_time,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TimeConverter()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversionTile({required String title, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
