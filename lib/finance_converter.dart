import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FinanceConverter extends StatefulWidget {
  const FinanceConverter({super.key});

  @override
  _FinanceConverterState createState() => _FinanceConverterState();
}

class _FinanceConverterState extends State<FinanceConverter> {
  final TextEditingController _amountController = TextEditingController();
  String _result = '';
  String _selectedFromCurrency = 'USD';
  String _selectedToCurrency = 'EUR';

  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'INR'];

  void _convertCurrency() {
    final double? amount = double.tryParse(_amountController.text);
    if (amount == null) {
      setState(() {
        _result = 'Invalid input';
      });
      return;
    }

    double conversionRate = 1.0;
    if (_selectedFromCurrency == 'USD' && _selectedToCurrency == 'EUR') {
      conversionRate = 0.85;
    } else if (_selectedFromCurrency == 'EUR' && _selectedToCurrency == 'USD') {
      conversionRate = 1.18;
    } else if (_selectedFromCurrency == 'USD' && _selectedToCurrency == 'INR') {
      conversionRate = 83.0;
    } else if (_selectedFromCurrency == 'INR' && _selectedToCurrency == 'USD') {
      conversionRate = 0.012;
    } else if (_selectedFromCurrency == 'USD' && _selectedToCurrency == 'GBP') {
      conversionRate = 0.79;
    } else if (_selectedFromCurrency == 'GBP' && _selectedToCurrency == 'USD') {
      conversionRate = 1.27;
    } else if (_selectedFromCurrency == _selectedToCurrency) {
      conversionRate = 1.0;
    }
    // Add more conversion rates as needed

    setState(() {
      _result = amount == 0.0
          ? ''
          : (amount * conversionRate).toStringAsFixed(2);
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
          title: const Text('Finance Converter', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          elevation: 8,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTitle('Enter amount:', accentColor),
              SizedBox(height: screenHeight * 0.01),
              _buildInputField(accentColor),
              SizedBox(height: screenHeight * 0.03),
              _buildCustomDropdown('From:', _selectedFromCurrency, (value) {
                setState(() {
                  _selectedFromCurrency = value!;
                });
              }, accentColor),
              SizedBox(height: screenHeight * 0.03),
              _buildCustomDropdown('To:', _selectedToCurrency, (value) {
                setState(() {
                  _selectedToCurrency = value!;
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
          controller: _amountController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: 'Amount',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.transparent,
            prefixIcon: Icon(Icons.attach_money, color: accentColor),
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
              items: _currencies.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(currency),
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
      onPressed: _convertCurrency,
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
            _result.isEmpty || _result == 'Invalid input'
                ? 'Converted Amount'
                : '$_result $_selectedToCurrency',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.052,
              color: _result == 'Invalid input' ? Colors.red : accentColor,
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