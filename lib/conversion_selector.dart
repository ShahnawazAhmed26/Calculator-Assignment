
import 'package:Omniculator/calculator.dart';
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
import 'bmi_converter.dart';

class ConversionsSelector extends StatelessWidget {
  static const Color backgroundColor = Colors.black; 
  static const Color textColor = Colors.white; 

  @override
  Widget build(BuildContext context) {
    final converters = [
      {'title': 'Angle ', 'widget': AngleConverter()},
      {'title': 'Area ', 'widget': AreaConverter()},
      {'title': 'Currency ', 'widget': CurrencyConverter()},
      {'title': 'Data ', 'widget': DataConverter()},
      {'title': 'Distance ', 'widget': DistanceConverter()},
      {'title': 'Energy ', 'widget': EnergyConverter()},
      {'title': 'Mass ', 'widget': MassConverter()},
      {'title': 'Power ', 'widget': PowerConverter()},
      {'title': 'Pressure ', 'widget': PressureConverter()},
      {'title': 'Speed ', 'widget': SpeedConverter()},
      {'title': 'Temperature ', 'widget': TemperatureConverter()},
      {'title': 'Volume ', 'widget': VolumeConverter()},
      {'title': 'Time ', 'widget': TimeConverter()},
      {'title': 'BMI ', 'widget': BMICalculator()},
    ];

    converters.sort((a, b) => (a['title'] as String).compareTo(b['title'] as String));

    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: converters.map((converter) {
            return _buildConversionTile(
              title: converter['title'] as String,
              icon: _getIconForConverter(converter['title'] as String),
              onTap: () {
                Navigator.push(
                  context,
                  _createRoute(converter['widget'] as Widget),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

 AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: backgroundColor,
    elevation: 0,
    automaticallyImplyLeading: false, // This removes the back arrow
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Calculator()),
            );
          },
          child: Text(
            'Calculator',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
             
            ),
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ConversionsSelector()),
            );
          },
          child: Text(
            'Converter',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
               fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}


  Route _createRoute(Widget targetScreen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  IconData _getIconForConverter(String title) {
    switch (title) {
      case 'Angle ':
        return Icons.rotate_left;
      case 'Area ':
        return Icons.crop_square;
      case 'Currency ':
        return Icons.currency_exchange;
      case 'Data ':
        return Icons.data_object;
      case 'Distance ':
        return Icons.straighten;
      case 'Energy ':
        return Icons.bolt;
      case 'Mass ':
        return Icons.scale;
      case 'Power ':
        return Icons.electric_bolt;
      case 'Pressure ':
        return Icons.compress;
      case 'Speed ':
        return Icons.speed;
      case 'Temperature ':
        return Icons.device_thermostat;
      case 'Volume ':
        return Icons.local_drink;
      case 'Time ':
        return Icons.access_time;
      case 'BMI ':
        return Icons.monitor_weight;
      default:
        return Icons.help;
    }
  }

  Widget _buildConversionTile({required String title, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
