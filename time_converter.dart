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
    'Weeks',
    'Years',
    'Milliseconds',
    'Microseconds',
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
      case 'Weeks':
        convertedValue = _convertFromWeeks(value);
        break;
      case 'Years':
        convertedValue = _convertFromYears(value);
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
      _convertedTime = convertedValue.toStringAsFixed(6); // Adjusted for precision
    });
  }

  double _convertFromSeconds(double value) {
    switch (_selectedToUnit) {
      case 'Minutes': return value / 60;
      case 'Hours': return value / 3600;
      case 'Days': return value / 86400;
      case 'Weeks': return value / 604800;
      case 'Years': return value / 31536000;
      case 'Milliseconds': return value * 1000;
      case 'Microseconds': return value * 1000000;
      default: return value; // Same unit
    }
  }

  double _convertFromMinutes(double value) {
    switch (_selectedToUnit) {
      case 'Seconds': return value * 60;
      case 'Hours': return value / 60;
      case 'Days': return value / 1440;
      case 'Weeks': return value / 10080;
      case 'Years': return value / 525600;
      case 'Milliseconds': return value * 60000;
      case 'Microseconds': return value * 60000000;
      default: return value; // Same unit
    }
  }

  double _convertFromHours(double value) {
    switch (_selectedToUnit) {
      case 'Seconds': return value * 3600;
      case 'Minutes': return value * 60;
      case 'Days': return value / 24;
      case 'Weeks': return value / 168;
      case 'Years': return value / 8760;
      case 'Milliseconds': return value * 3600000;
      case 'Microseconds': return value * 3600000000;
      default: return value; // Same unit
    }
  }

  double _convertFromDays(double value) {
    switch (_selectedToUnit) {
      case 'Seconds': return value * 86400;
      case 'Minutes': return value * 1440;
      case 'Hours': return value * 24;
      case 'Weeks': return value / 7;
      case 'Years': return value / 365;
      case 'Milliseconds': return value * 86400000;
      case 'Microseconds': return value * 86400000000;
      default: return value; // Same unit
    }
  }

  double _convertFromWeeks(double value) {
    switch (_selectedToUnit) {
      case 'Seconds': return value * 604800;
      case 'Minutes': return value * 10080;
      case 'Hours': return value * 168;
      case 'Days': return value * 7;
      case 'Years': return value / 52.1429;
      case 'Milliseconds': return value * 604800000;
      case 'Microseconds': return value * 604800000000;
      default: return value; // Same unit
    }
  }

  double _convertFromYears(double value) {
    switch (_selectedToUnit) {
      case 'Seconds': return value * 31536000;
      case 'Minutes': return value * 525600;
      case 'Hours': return value * 8760;
      case 'Days': return value * 365;
      case 'Weeks': return value * 52.1429;
      case 'Milliseconds': return value * 31536000000;
      case 'Microseconds': return value * 31536000000000;
      default: return value; // Same unit
    }
  }

  double _convertFromMilliseconds(double value) {
    switch (_selectedToUnit) {
      case 'Seconds': return value / 1000;
      case 'Minutes': return value / 60000;
      case 'Hours': return value / 3600000;
      case 'Days': return value / 86400000;
      case 'Weeks': return value / 604800000;
      case 'Years': return value / 31536000000;
      case 'Microseconds': return value * 1000;
      default: return value; // Same unit
    }
  }

  double _convertFromMicroseconds(double value) {
    switch (_selectedToUnit) {
      case 'Seconds': return value / 1000000;
      case 'Minutes': return value / 60000000;
      case 'Hours': return value / 3600000000;
      case 'Days': return value / 86400000000;
      case 'Weeks': return value / 604800000000;
      case 'Years': return value / 31536000000000;
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
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle('Enter time:'),
            SizedBox(height: 10),
            _buildInputField(),
            SizedBox(height: 20),
            _buildCustomDropdown('From:', _selectedFromUnit, (value) {
              setState(() {
                _selectedFromUnit = value!;
              });
            }),
            SizedBox(height: 20),
            _buildCustomDropdown('To:', _selectedToUnit, (value) {
              setState(() {
                _selectedToUnit = value!;
              });
            }),
            SizedBox(height: 20),
            _buildConvertButton(),
            SizedBox(height: 20),
            _buildResultText(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, color: Colors.white),
    );
  }

  Widget _buildInputField() {
    return TextField(
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
    );
  }

  Widget _buildCustomDropdown(String label, String value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(label),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: DropdownButton<String>(
            value: value,
            onChanged: onChanged,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down, color: Colors.yellow),
            dropdownColor: Colors.grey[900],
            underline: SizedBox(),
            style: TextStyle(color: Colors.white, fontSize: 16),
            items: _units.map((unit) {
              return DropdownMenuItem(
                value: unit,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(unit),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildConvertButton() {
    return ElevatedButton(
      onPressed: _convertTime,
      child: Text('Convert'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow,
        padding: EdgeInsets.symmetric(vertical: 20), // Adjust padding for height
        textStyle: TextStyle(fontSize: 20), // Increase font size
        minimumSize: Size(double.infinity, 60), // Width (full) and height (adjustable)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Optional: Rounded edges
        ),
      ),
    );
  }

  Widget _buildResultText() {
    return Text(
      'Converted Time: $_convertedTime $_selectedToUnit',
      style: TextStyle(fontSize: 18, color: Colors.white),
    );
  }
}
