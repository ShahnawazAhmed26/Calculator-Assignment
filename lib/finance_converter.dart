import 'package:flutter/material.dart';

class FinanceConverter extends StatefulWidget {
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

    double conversionRate = 1.0; // Example conversion rate
    if (_selectedFromCurrency == 'USD' && _selectedToCurrency == 'EUR') {
      conversionRate = 0.85; // Example conversion rate USD to EUR
    } else if (_selectedFromCurrency == 'EUR' && _selectedToCurrency == 'USD') {
      conversionRate = 1.18; // Example conversion rate EUR to USD
    }
    // Add more conversion rates as needed

    setState(() {
      _result = (amount * conversionRate).toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Calculator'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle('Enter amount:'),
              SizedBox(height: 10),
              _buildInputField(),
              SizedBox(height: 20),
              _buildCustomDropdown('From:', _selectedFromCurrency, (value) {
                setState(() {
                  _selectedFromCurrency = value!;
                });
              }),
              SizedBox(height: 20),
              _buildCustomDropdown('To:', _selectedToCurrency, (value) {
                setState(() {
                  _selectedToCurrency = value!;
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
      controller: _amountController,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Amount',
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
      ],
    );
  }

  Widget _buildConvertButton() {
    return ElevatedButton(
      onPressed: _convertCurrency,
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
            'Converted Amount: $_result $_selectedToCurrency',
            style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
