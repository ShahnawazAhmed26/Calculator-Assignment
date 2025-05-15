import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AreaConverter extends StatefulWidget {
  const AreaConverter({super.key});

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
    final accentColor = const Color(0xFFFFD600);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Color(0xFF222222)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Area Converter", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          elevation: 8,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTitle('Enter area:', accentColor),
              SizedBox(height: screenHeight * 0.02),
              _buildInputField(accentColor),
              SizedBox(height: screenHeight * 0.03),
              _buildCustomDropdown('From:', _selectedFromUnit, (value) {
                setState(() {
                  _selectedFromUnit = value!;
                });
              }, accentColor),
              SizedBox(height: screenHeight * 0.03),
              _buildCustomDropdown('To:', _selectedToUnit, (value) {
                setState(() {
                  _selectedToUnit = value!;
                });
              }, accentColor),
              SizedBox(height: screenHeight * 0.03),
              _buildConvertButton(accentColor),
              SizedBox(height: screenHeight * 0.03),
              _buildResultCard(accentColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String text, Color accentColor) {
    return Text(
      text,
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.052,
        color: accentColor,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildInputField(Color accentColor) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white.withOpacity(0.07),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: 'Enter value',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.transparent,
            prefixIcon: Icon(Icons.square_foot, color: accentColor),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomDropdown(String label, String value, ValueChanged<String?> onChanged, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(label, accentColor),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white.withOpacity(0.07),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,
                vertical: MediaQuery.of(context).size.height * 0.01),
            child: DropdownButton<String>(
              value: value,
              onChanged: onChanged,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: accentColor),
              dropdownColor: Colors.grey[900],
              underline: const SizedBox(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.045,
                  fontWeight: FontWeight.w600),
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

  Widget _buildConvertButton(Color accentColor) {
    return ElevatedButton(
      onPressed: _convertArea,
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.022),
        textStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.052,
            fontWeight: FontWeight.bold),
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        shadowColor: accentColor.withOpacity(0.3),
      ),
      child: const Text('Convert', style: TextStyle(color: Colors.black)),
    );
  }

  Widget _buildResultCard(Color accentColor) {
    return Center(
      child: Card(
        color: Colors.white.withOpacity(0.09),
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.045),
          child: Text(
            _convertedArea.isEmpty || _convertedArea == 'Invalid input'
                ? 'Converted Area'
                : '$_convertedArea $_selectedToUnit',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.052,
              color: _convertedArea == 'Invalid input' ? Colors.red : accentColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ).animate().fade(duration: 400.ms),
    );
  }
}