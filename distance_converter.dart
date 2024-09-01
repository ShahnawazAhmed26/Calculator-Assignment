import 'package:flutter/material.dart';

class DistanceConverter extends StatefulWidget {
  @override
  _DistanceConverterState createState() => _DistanceConverterState();
}

class _DistanceConverterState extends State<DistanceConverter> {
  final TextEditingController _controller = TextEditingController();
  String _convertedDistance = '';
  String _selectedFromUnit = 'Meters';
  String _selectedToUnit = 'Kilometers';

  final List<String> _units = [
    'Meters',
    'Kilometers',
    'Miles',
    'Feet',
    'Yards',
    'Centimeters',
    'Inches',
  ];

  void _convertDistance() {
    final double? value = double.tryParse(_controller.text);
    if (value == null) {
      setState(() {
        _convertedDistance = 'Invalid input';
      });
      return;
    }

    double convertedValue;

    // Convert to meters first
    switch (_selectedFromUnit) {
      case 'Meters':
        convertedValue = value;
        break;
      case 'Kilometers':
        convertedValue = value * 1000;
        break;
      case 'Miles':
        convertedValue = value * 1609.34;
        break;
      case 'Feet':
        convertedValue = value * 0.3048;
        break;
      case 'Yards':
        convertedValue = value * 0.9144;
        break;
      case 'Centimeters':
        convertedValue = value * 0.01;
        break;
      case 'Inches':
        convertedValue = value * 0.0254;
        break;
      default:
        convertedValue = value; // Same unit
    }

    // Convert from meters to the selected unit
    switch (_selectedToUnit) {
      case 'Meters':
        break;
      case 'Kilometers':
        convertedValue /= 1000;
        break;
      case 'Miles':
        convertedValue /= 1609.34;
        break;
      case 'Feet':
        convertedValue /= 0.3048;
        break;
      case 'Yards':
        convertedValue /= 0.9144;
        break;
      case 'Centimeters':
        convertedValue /= 0.01;
        break;
      case 'Inches':
        convertedValue /= 0.0254;
        break;
    }

    setState(() {
      _convertedDistance = convertedValue.toStringAsFixed(4); // Adjusted for precision
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Distance Converter", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTitle('Enter distance:'),
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
        hintText: 'Distance',
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
              return DropdownMenuItem<String>(
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
      onPressed: _convertDistance,
      child: Text('Convert'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow,
        padding: EdgeInsets.symmetric(vertical: 20),
        textStyle: TextStyle(fontSize: 20),
        minimumSize: Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildResultText() {
    return Text(
      'Converted Distance: $_convertedDistance $_selectedToUnit',
      style: TextStyle(fontSize: 18, color: Colors.white),
      textAlign: TextAlign.center,
    );
  }
}
