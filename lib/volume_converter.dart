import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class VolumeConverter extends StatefulWidget {
  @override
  _VolumeConverterState createState() => _VolumeConverterState();
}

class _VolumeConverterState extends State<VolumeConverter> {
  final TextEditingController _controller = TextEditingController();
  String _convertedVolume = '';
  String _selectedFromUnit = 'Liters';
  String _selectedToUnit = 'Milliliters';

  final List<String> _units = [
    'Liters',
    'Milliliters',
    'Cubic meters',
    'Cubic centimeters',
    'Gallons',
    'Fluid ounces',
    'Pints',
    'Quarts',
  ];

  void _convertVolume() {
    final double? value = double.tryParse(_controller.text);
    if (value == null) {
      setState(() {
        _convertedVolume = 'Invalid input';
      });
      return;
    }

    double convertedValue;

    // Convert to liters first
    switch (_selectedFromUnit) {
      case 'Liters':
        convertedValue = value;
        break;
      case 'Milliliters':
        convertedValue = value / 1000;
        break;
      case 'Cubic meters':
        convertedValue = value * 1000;
        break;
      case 'Cubic centimeters':
        convertedValue = value / 1000;
        break;
      case 'Gallons':
        convertedValue = value * 3.78541;
        break;
      case 'Fluid ounces':
        convertedValue = value / 33.814;
        break;
      case 'Pints':
        convertedValue = value * 0.473176;
        break;
      case 'Quarts':
        convertedValue = value * 0.946353;
        break;
      default:
        convertedValue = value; // Same unit
    }

    // Convert from liters to the selected unit
    switch (_selectedToUnit) {
      case 'Liters':
        break;
      case 'Milliliters':
        convertedValue *= 1000;
        break;
      case 'Cubic meters':
        convertedValue /= 1000;
        break;
      case 'Cubic centimeters':
        convertedValue *= 1000;
        break;
      case 'Gallons':
        convertedValue /= 3.78541;
        break;
      case 'Fluid ounces':
        convertedValue *= 33.814;
        break;
      case 'Pints':
        convertedValue /= 0.473176;
        break;
      case 'Quarts':
        convertedValue /= 0.946353;
        break;
    }

    setState(() {
      _convertedVolume = convertedValue.toStringAsFixed(4);
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
          title: const Text("Volume Converter", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          elevation: 8,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTitle('Enter volume:', accentColor),
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
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: 'Volume',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.transparent,
            prefixIcon: Icon(Icons.local_drink, color: accentColor),
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
      onPressed: _convertVolume,
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
            _convertedVolume.isEmpty || _convertedVolume == 'Invalid input'
                ? 'Converted Volume'
                : '$_convertedVolume $_selectedToUnit',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.052,
              color: _convertedVolume == 'Invalid input' ? Colors.red : accentColor,
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