import 'package:flutter/material.dart';

class AreaConverter extends StatefulWidget {
  @override
  _AreaConverterState createState() => _AreaConverterState();
}

class _AreaConverterState extends State<AreaConverter> {
  final TextEditingController _controller = TextEditingController();
  String _convertedArea = '';
  String _selectedFromUnit = 'Square meters';
  String _selectedToUnit = 'Square feet';

  final List<String> _units = [
    'Square millimeters',
    'Square centimeters',
    'Square meters',
    'Square kilometers',
    'Square inches',
    'Square feet',
    'Square yards',
    'Acres',
    'Hectares',
    'Square miles',
  ];

  void _convertArea() {
    final double? value = double.tryParse(_controller.text);
    if (value == null) {
      setState(() {
        _convertedArea = 'Invalid input';
      });
      return;
    }

    double convertedValue = value;

    // Convert from the selected unit to square meters (base unit)
    switch (_selectedFromUnit) {
      case 'Square millimeters':
        convertedValue = value * 1e-6;
        break;
      case 'Square centimeters':
        convertedValue = value * 1e-4;
        break;
      case 'Square meters':
        convertedValue = value;
        break;
      case 'Square kilometers':
        convertedValue = value * 1e6;
        break;
      case 'Square inches':
        convertedValue = value * 0.00064516;
        break;
      case 'Square feet':
        convertedValue = value * 0.092903;
        break;
      case 'Square yards':
        convertedValue = value * 0.836127;
        break;
      case 'Acres':
        convertedValue = value * 4046.8564224;
        break;
      case 'Hectares':
        convertedValue = value * 10000;
        break;
      case 'Square miles':
        convertedValue = value * 2.589988110336e6;
        break;
    }

    // Convert from square meters (base unit) to the selected target unit
    switch (_selectedToUnit) {
      case 'Square millimeters':
        convertedValue *= 1e6;
        break;
      case 'Square centimeters':
        convertedValue *= 1e4;
        break;
      case 'Square meters':
        break;
      case 'Square kilometers':
        convertedValue *= 1e-6;
        break;
      case 'Square inches':
        convertedValue /= 0.00064516;
        break;
      case 'Square feet':
        convertedValue /= 0.092903;
        break;
      case 'Square yards':
        convertedValue /= 0.836127;
        break;
      case 'Acres':
        convertedValue /= 4046.8564224;
        break;
      case 'Hectares':
        convertedValue /= 10000;
        break;
      case 'Square miles':
        convertedValue /= 2.589988110336e6;
        break;
    }

    setState(() {
      _convertedArea = convertedValue.toStringAsFixed(4);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Area Converter", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTitle('Enter area:'),
            SizedBox(height: screenHeight * 0.02),
            _buildInputField(),
            SizedBox(height: screenHeight * 0.03),
            _buildCustomDropdown('From:', _selectedFromUnit, (value) {
              setState(() {
                _selectedFromUnit = value!;
              });
            }),
            SizedBox(height: screenHeight * 0.03),
            _buildCustomDropdown('To:', _selectedToUnit, (value) {
              setState(() {
                _selectedToUnit = value!;
              });
            }),
            SizedBox(height: screenHeight * 0.03),
            _buildConvertButton(),
            SizedBox(height: screenHeight * 0.03),
            _buildResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05, color: Colors.white),
    );
  }

  Widget _buildInputField() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.grey[850],
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter value',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey[800],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomDropdown(String label, String value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(label),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.grey[850],
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04, vertical: MediaQuery.of(context).size.height * 0.01),
            child: DropdownButton<String>(
              value: value,
              onChanged: onChanged,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: Colors.yellow),
              dropdownColor: Colors.grey[900],
              underline: SizedBox(),
              style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.04),
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
        ),
      ],
    );
  }

  Widget _buildConvertButton() {
    return ElevatedButton(
      onPressed: _convertArea,
      child: Text('Convert'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow,
        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
        textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),
        minimumSize: Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Center(
      child: Card(
        color: Colors.grey[850],
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          child: Text(
            'Converted Area: $_convertedArea $_selectedToUnit',
            style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
