import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DataConverter extends StatefulWidget {
  const DataConverter({super.key});

  @override
  _DataConverterState createState() => _DataConverterState();
}

class _DataConverterState extends State<DataConverter> {
  String _fromUnit = 'Bits';
  String _toUnit = 'Bytes';
  double _inputValue = 0.0;
  String _result = '';

  final Map<String, double> _conversionRates = {
    'Bits': 1.0,
    'Bytes': 8.0,
    'Kilobits': 1000.0,
    'Kilobytes': 8000.0,
    'Megabits': 1e6,
    'Megabytes': 8e6,
    'Gigabits': 1e9,
    'Gigabytes': 8e9,
    'Terabits': 1e12,
    'Terabytes': 8e12,
    'Petabits': 1e15,
    'Petabytes': 8e15,
    'Exabits': 1e18,
    'Exabytes': 8e18,
    'Zettabits': 1e21,
    'Zettabytes': 8e21,
    'Yottabits': 1e24,
    'Yottabytes': 8e24,
    'Kibibits': 1024.0,
    'Kibibytes': 8192.0,
    'Mebibits': 1.048576e6,
    'Mebibytes': 8.388608e6,
    'Gibibits': 1.073741824e9,
    'Gibibytes': 8.589869056e9,
    'Tebibits': 1.099511627776e12,
    'Tebibytes': 8.796093022208e12,
    'Pebibits': 1.125899906842624e15,
    'Pebibytes': 9.007199254740992e15,
    'Exbibits': 1.152921504606846e18,
    'Exbibytes': 9.223372036854776e18,
    'Zebibits': 1.1805916207174113e21,
    'Zebibytes': 9.44473296573929e21,
    'Yobibits': 1.2089258196146292e24,
    'Yobibytes': 9.671406556917033e24,
  };

  void _convertData() {
    double fromRate = _conversionRates[_fromUnit]!;
    double toRate = _conversionRates[_toUnit]!;
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
          title: const Text('Data Converter', style: TextStyle(color: Colors.white)),
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
          items: _conversionRates.keys.toList().map((unit) {
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
            prefixIcon: Icon(Icons.data_object, color: accentColor),
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
      onPressed: _convertData,
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
    )
        .animate()
        .fade(duration: 400.ms)
        .then()
        .scale(duration: 400.ms, curve: Curves.easeInOut)
        .then()
        .shakeX(duration: 400.ms, curve: Curves.easeInOut);
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
            _result.isEmpty ? 'Converted Value' : _result,
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