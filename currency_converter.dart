import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  final TextEditingController _amountController = TextEditingController();
  double _convertedAmount = 0.0;
  Map<String, double> _conversionRates = {};
  List<String> _currencyList = [];

  @override
  void initState() {
    super.initState();
    _fetchConversionRates();
  }

  Future<void> _fetchConversionRates() async {
    final url = 'https://api.exchangerate-api.com/v4/latest/USD'; // Example API URL
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;

        setState(() {
          _conversionRates = rates.map((key, value) => MapEntry(key, value.toDouble()));
          _currencyList = _conversionRates.keys.toList();
        });
      } else {
        throw Exception('Failed to load conversion rates');
      }
    } catch (e) {
      // Handle error
      print('Error fetching conversion rates: $e');
    }
  }

  void _convertCurrency() {
    if (_conversionRates.isEmpty) {
      // Avoid conversion if rates are not yet available
      return;
    }

    final fromRate = _conversionRates[_fromCurrency] ?? 1.0;
    final toRate = _conversionRates[_toCurrency] ?? 1.0;
    final amount = double.tryParse(_amountController.text) ?? 0;
    setState(() {
      _convertedAmount = (amount / fromRate) * toRate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
        backgroundColor: Colors.black,
        elevation: 0, // Remove shadow for a flat look
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.black, // Set background color to black
      body: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // From Currency Card
              _buildCurrencyCard('From Currency', _fromCurrency, (newValue) {
                setState(() {
                  _fromCurrency = newValue!;
                });
              }),
              SizedBox(height: 16),
              // To Currency Card
              _buildCurrencyCard('To Currency', _toCurrency, (newValue) {
                setState(() {
                  _toCurrency = newValue!;
                });
              }),
              SizedBox(height: 16),
              // Amount Input Card
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.grey[900],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[800],
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Convert Button
              ElevatedButton(
                onPressed: _convertCurrency,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, // Set the background color
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Convert'),
              ),
              SizedBox(height: 20),
              // Result Card
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.grey[900],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Converted Amount:',
                        style: TextStyle(fontSize: 18, color: Colors.white70),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _convertedAmount.toStringAsFixed(2),
                        style: TextStyle(fontSize: 24, color: Colors.yellow), // Match color with the Convert button
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build Currency Card with Flag
  Widget _buildCurrencyCard(String label, String value, void Function(String?) onChanged) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.yellow), // Match color with the Convert button
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey[800],
          ),
          items: _currencyList.map((currency) {
            return DropdownMenuItem<String>(
              value: currency,
              child: Text(
                currency,
                style: TextStyle(color: Colors.yellow), // Currency text color
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
