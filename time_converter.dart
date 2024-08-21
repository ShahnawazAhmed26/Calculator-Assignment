import 'package:flutter/material.dart';

class TimeConverter extends StatefulWidget {
  @override
  _TimeConverterState createState() => _TimeConverterState();
}

class _TimeConverterState extends State<TimeConverter> {
  final TextEditingController _controller = TextEditingController();
  String _convertedTime = '';
  String _selectedFromUnit = 'Seconds';
  String _selectedToUnit = 'Minutes';

  final List<String> _units = [
    'Seconds',
    'Minutes',
    'Hours',
    'Days',
    'Milliseconds',
    'Microseconds'
  ];

  void _convertTime() {
    final double? value = double.tryParse(_controller.text);
    if (value == null) {
      setState(() {
        _convertedTime = 'Invalid input';
      });
      return;
    }

    double convertedValue;

    switch (_selectedFromUnit) {
      case 'Seconds':
        convertedValue = _convertFromSeconds(value);
        break;
      case 'Minutes':
        convertedValue = _convertFromMinutes(value);
        break;
      case 'Hours':
        convertedValue = _convertFromHours(value);
        break;
      case 'Days':
        convertedValue = _convertFromDays(value);
        break;
      case 'Milliseconds':
        convertedValue = _convertFromMilliseconds(value);
        break;
      case 'Microseconds':
        convertedValue = _convertFromMicroseconds(value);
        break;
      default:
        convertedValue = value; // Same unit
    }

    setState(() {
      _convertedTime = convertedValue.toStringAsFixed(2);
    });
  }

  double _convertFromSeconds(double value) {
    switch (_selectedToUnit) {
      case 'Minutes': return value / 60;
      case 'Hours': return value / 3600;
      case 'Days': return value / 86400;
      case 'Milliseconds': return value * 1000;
      case 'Microseconds': return value * 1000000; // No underscore
      default: return value; // Same unit
    }
  }

  double _convertFromMinutes(double value) {
    switch (_selectedToUnit) {
      case 'Seconds': return value * 60;
      case 'Hours': return value / 60;
      case 'Days': return value / 1440; // 60 * 24
      case 'Milliseconds': return value * 60000; // 60 * 1000
      case 'Microseconds': return value * 60000000; // 60 * 1000000
      default: return value; // Same unit
    }
  }

  double _convertFromHours(double value) {
    switch (_selectedToUnit) {
      case 'Seconds': return value * 3600; // 60 * 60
      case 'Minutes': return value * 60;
      case 'Days': return value / 24;
      case 'Milliseconds': return value * 3600000; // 60 * 60 * 1000
      case 'Microseconds': return value * 3600000000; // 60 * 60 * 1000000
      default: return value; // Same unit
    }
  }

  double _convertFromDays(double value) {
    switch (_selectedToUnit) {
      case 'Seconds': return value * 86400; // 24 * 60 * 60
      case 'Minutes': return value * 1440; // 24 * 60
      case 'Hours': return value * 24;
      case 'Milliseconds': return value * 86400000; // 24 * 60 * 60 * 1000
      case 'Microseconds': return value * 86400000000; // 24 * 60 * 60 * 1000000
      default: return value; // Same unit
    }
  }

  double _convertFromMilliseconds(double value) {
    switch (_selectedToUnit) {
      case 'Seconds': return value / 1000;
      case 'Minutes': return value / 60000; // 1000 * 60
      case 'Hours': return value / 3600000; // 1000 * 60 * 60
      case 'Days': return value / 86400000; // 1000 * 60 * 60 * 24
      case 'Microseconds': return value * 1000;
      default: return value; // Same unit
    }
  }

  double _convertFromMicroseconds(double value) {
    switch (_selectedToUnit) {
      case 'Seconds': return value / 1000000; // 1000000
      case 'Minutes': return value / 60000000; // 1000000 * 60
      case 'Hours': return value / 3600000000; // 1000000 * 60 * 60
      case 'Days': return value / 86400000000; // 1000000 * 60 * 60 * 24
      case 'Milliseconds': return value / 1000;
      default: return value; // Same unit
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Time Converter"),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter time:', style: TextStyle(fontSize: 20, color: Colors.white)),
            SizedBox(height: 10),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Time',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
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
              onPressed: _convertTime,
              child: Text('Convert'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Converted Time: $_convertedTime $_selectedToUnit',
              style: TextStyle(fontSize: 18, color: Colors.white),
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
        DropdownButton<String>(
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
      ],
    );
  }
}
