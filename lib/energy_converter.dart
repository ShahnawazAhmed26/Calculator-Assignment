import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EnergyConverter extends StatefulWidget {
  const EnergyConverter({super.key});

  @override
  _EnergyConverterState createState() => _EnergyConverterState();
}

class _EnergyConverterState extends State<EnergyConverter> {
  String _fromUnit = 'Joules';
  String _toUnit = 'Kilojoules';
  double _inputValue = 0.0;
  String _result = '';

  final Map<String, double> _conversionRates = {
    'Joules': 1.0,
    'Kilojoules': 1000.0,
    'Calories': 4.184,
    'Kilocalories': 4184.0,
    'Watt-hours': 3600.0,
    'Kilowatt-hours': 3600000.0,
    'BTUs': 1055.06,
    'eV': 1.60218e-19,
    'Foot-pounds': 1.35582,
    'Thermal Calories': 4.184,
    'Food Calories': 4184.0,
    'Electron Watts': 1.60218e-19,
  };

  void _convertEnergy() {
    double fromRate = _conversionRates[_fromUnit] ?? 1.0;
    double toRate = _conversionRates[_toUnit] ?? 1.0;
    double convertedValue = (_inputValue * fromRate) / toRate;

    setState(() {
      _result = _inputValue == 0.0
          ? ''
          : '${_inputValue.toStringAsFixed(4)} $_fromUnit = ${convertedValue.toStringAsFixed(4)} $_toUnit';
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
          title: const Text('Energy Converter', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          elevation: 8,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTitle('From:', accentColor),
              SizedBox(height: screenHeight * 0.01),
              _buildCustomDropdown(_fromUnit, (value) {
                setState(() {
                  _fromUnit = value!;
                });
              }, accentColor),
              SizedBox(height: screenHeight * 0.03),
              _buildTitle('To:', accentColor),
              SizedBox(height: screenHeight * 0.01),
              _buildCustomDropdown(_toUnit, (value) {
                setState(() {
                  _toUnit = value!;
                });
              }, accentColor),
              SizedBox(height: screenHeight * 0.03),
              _buildInputField(accentColor),
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

  Widget _buildCustomDropdown(String value, ValueChanged<String?> onChanged, Color accentColor) {
    return Card(
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
          items: _conversionRates.keys.map((unit) {
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
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: 'Enter value',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.transparent,
            prefixIcon: Icon(Icons.bolt, color: accentColor),
          ),
          onChanged: (value) {
            setState(() {
              _inputValue = double.tryParse(value) ?? 0.0;
            });
          },
        ),
      ),
    );
  }

  Widget _buildConvertButton(Color accentColor) {
    return ElevatedButton(
      onPressed: _convertEnergy,
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
            _result.isEmpty ? 'Converted Energy' : _result,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.052,
              color: accentColor,
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