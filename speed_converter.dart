import 'package:flutter/material.dart';

class SpeedConverter extends StatefulWidget {
  @override
  _SpeedConverterState createState() => _SpeedConverterState();
}

class _SpeedConverterState extends State<SpeedConverter> {
  final TextEditingController _controller = TextEditingController();
  String _convertedSpeed = '';
  String _selectedFromUnit = 'Meters per second';
  String _selectedToUnit = 'Kilometers per hour';

  final List<String> _units = [
    'Meters per second',
    'Kilometers per hour',
    'Miles per hour',
    'Feet per second'
  ];

  void _convertSpeed() {
    final double? value = double.tryParse(_controller.text);
    if (value == null) {
      setState(() {
        _convertedSpeed = 'Invalid input';
      });
      return;
    }

    double convertedValue;

    switch (_selectedFromUnit) {
      case 'Meters per second':
        convertedValue = _convertFromMetersPerSecond(value);
        break;
      case 'Kilometers per hour':
        convertedValue = _convertFromKilometersPerHour(value);
        break;
      case 'Miles per hour':
        convertedValue = _convertFromMilesPerHour(value);
        break;
      case 'Feet per second':
        convertedValue = _convertFromFeetPerSecond(value);
        break;
      default:
        convertedValue = value; // Same unit
    }

    setState(() {
      _convertedSpeed = convertedValue.toStringAsFixed(2);
    });
  }

  double _convertFromMetersPerSecond(double value) {
    switch (_selectedToUnit) {
      case 'Kilometers per hour': return value * 3.6;
      case 'Miles per hour': return value * 2.237;
      case 'Feet per second': return value * 3.281;
      default: return value; // Same unit
    }
  }

  double _convertFromKilometersPerHour(double value) {
    switch (_selectedToUnit) {
      case 'Meters per second': return value / 3.6;
      case 'Miles per hour': return value / 1.609;
      case 'Feet per second': return value * 0.911;
      default: return value; // Same unit
    }
  }

  double _convertFromMilesPerHour(double value) {
    switch (_selectedToUnit) {
      case 'Meters per second': return value / 2.237;
      case 'Kilometers per hour': return value * 1.609;
      case 'Feet per second': return value * 1.467;
      default: return value; // Same unit
    }
  }

  double _convertFromFeetPerSecond(double value) {
    switch (_selectedToUnit) {
      case 'Meters per second': return value / 3.281;
      case 'Kilometers per hour': return value / 0.911;
      case 'Miles per hour': return value / 1.467;
      default: return value; // Same unit
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Speed Converter"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.black, // Set background color to black
      body: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Enter speed:', style: TextStyle(fontSize: 20, color: Colors.white)),
            SizedBox(height: 10),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.grey[900],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Speed',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.grey[800],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildDropdown('From:', _selectedFromUnit, (value) {
              setState(() {
                _selectedFromUnit = value!;
              });
            }),
            SizedBox(height: 20),
            _buildDropdown('To:', _selectedToUnit, (value) {
              setState(() {
                _selectedToUnit = value!;
              });
            }),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertSpeed,
              child: Text('Convert'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.grey[900],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Converted Speed: $_convertedSpeed $_selectedToUnit',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 20, color: Colors.white)),
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: value,
              onChanged: onChanged,
              items: _units.map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(unit, style: TextStyle(color: Colors.white)),
                );
              }).toList(),
              dropdownColor: Colors.grey[850],
              isExpanded: true,
            ),
          ),
        ),
      ],
    );
  }
}
