import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MassConverter extends StatefulWidget {
  const MassConverter({super.key});

  @override
  _MassConverterState createState() => _MassConverterState();
}

class _MassConverterState extends State<MassConverter> {
  final TextEditingController _controller = TextEditingController();
  String _convertedMass = '';
  String _selectedFromUnit = 'Kilograms';
  String _selectedToUnit = 'Grams';

  final List<String> _units = [
    'Carats',
    'Milligrams',
    'Centigrams',
    'Decigrams',
    'Grams',
    'Dekagrams',
    'Hectograms',
    'Kilograms',
    'Metric Tons',
    'Ounces',
    'Pounds',
    'Stones',
    'Short Tons',
    'Long Tons',
  ];

  void _convertMass() {
    final double? value = double.tryParse(_controller.text);
    if (value == null) {
      setState(() {
        _convertedMass = 'Invalid input';
      });
      return;
    }

    double convertedValue;

    // Convert to kilograms first
    switch (_selectedFromUnit) {
      case 'Carats':
        convertedValue = value * 0.0002;
        break;
      case 'Milligrams':
        convertedValue = value / 1e6;
        break;
      case 'Centigrams':
        convertedValue = value / 100000;
        break;
      case 'Decigrams':
        convertedValue = value / 10000;
        break;
      case 'Grams':
        convertedValue = value / 1000;
        break;
      case 'Dekagrams':
        convertedValue = value / 100;
        break;
      case 'Hectograms':
        convertedValue = value / 10;
        break;
      case 'Kilograms':
        convertedValue = value;
        break;
      case 'Metric Tons':
        convertedValue = value * 1000;
        break;
      case 'Ounces':
        convertedValue = value * 0.028349523125;
        break;
      case 'Pounds':
        convertedValue = value * 0.45359237;
        break;
      case 'Stones':
        convertedValue = value * 6.35029318;
        break;
      case 'Short Tons':
        convertedValue = value * 907.18474;
        break;
      case 'Long Tons':
        convertedValue = value * 1016.0469088;
        break;
      default:
        convertedValue = value; // Same unit
    }

    // Convert from kilograms to the selected unit
    switch (_selectedToUnit) {
      case 'Carats':
        convertedValue /= 0.0002;
        break;
      case 'Milligrams':
        convertedValue *= 1e6;
        break;
      case 'Centigrams':
        convertedValue *= 100000;
        break;
      case 'Decigrams':
        convertedValue *= 10000;
        break;
      case 'Grams':
        convertedValue *= 1000;
        break;
      case 'Dekagrams':
        convertedValue *= 100;
        break;
      case 'Hectograms':
        convertedValue *= 10;
        break;
      case 'Kilograms':
        break;
      case 'Metric Tons':
        convertedValue /= 1000;
        break;
      case 'Ounces':
        convertedValue /= 0.028349523125;
        break;
      case 'Pounds':
        convertedValue /= 0.45359237;
        break;
      case 'Stones':
        convertedValue /= 6.35029318;
        break;
      case 'Short Tons':
        convertedValue /= 907.18474;
        break;
      case 'Long Tons':
        convertedValue /= 1016.0469088;
        break;
    }

    setState(() {
      _convertedMass = convertedValue.toStringAsFixed(10); // Scientific precision
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
          title: const Text("Mass Converter", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          elevation: 8,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTitle('Enter mass:', accentColor),
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
            hintText: 'Mass',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.transparent,
            prefixIcon: Icon(Icons.monitor_weight, color: accentColor),
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
      onPressed: _convertMass,
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
            _convertedMass.isEmpty || _convertedMass == 'Invalid input'
                ? 'Converted Mass'
                : '$_convertedMass $_selectedToUnit',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.052,
              color: _convertedMass == 'Invalid input' ? Colors.red : accentColor,
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