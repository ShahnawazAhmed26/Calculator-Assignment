import 'package:flutter/material.dart';

class AngleConverter extends StatefulWidget {
  @override
  _AngleConverterState createState() => _AngleConverterState();
}

class _AngleConverterState extends State<AngleConverter> {
  final TextEditingController _controller = TextEditingController();
  String _convertedAngle = '';
  String _selectedFromUnit = 'Degrees';
  String _selectedToUnit = 'Radians';

  final List<String> _units = ['Degrees', 'Radians', 'Gradians'];

  void _convertAngle() {
    final double? value = double.tryParse(_controller.text);
    if (value == null) {
      setState(() {
        _convertedAngle = 'Invalid input';
      });
      return;
    }

    double convertedValue;

    // Convert from the selected unit to degrees first
    switch (_selectedFromUnit) {
      case 'Degrees':
        convertedValue = value;
        break;
      case 'Radians':
        convertedValue = value * (180 / 3.141592653589793); // Radians to degrees
        break;
      case 'Gradians':
        convertedValue = value * 0.9; // Gradians to degrees
        break;
      default:
        convertedValue = value;
    }

    // Convert from degrees to the selected unit
    switch (_selectedToUnit) {
      case 'Degrees':
        break;
      case 'Radians':
        convertedValue = convertedValue * (3.141592653589793 / 180); // Degrees to radians
        break;
      case 'Gradians':
        convertedValue = convertedValue / 0.9; // Degrees to gradians
        break;
    }

    setState(() {
      _convertedAngle = convertedValue.toStringAsFixed(4);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Angle Converter'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle('Enter angle:'),
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
        hintText: 'Angle',
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
      onPressed: _convertAngle,
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
    return Center(
      child: Card(
        color: Colors.grey[850],
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.038),
          child: Text(
            'Converted Angle: $_convertedAngle $_selectedToUnit',
            style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

 