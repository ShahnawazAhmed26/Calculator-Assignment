import 'package:flutter/material.dart';

class DiscountCalculator extends StatefulWidget {
  @override
  _DiscountCalculatorState createState() => _DiscountCalculatorState();
}

class _DiscountCalculatorState extends State<DiscountCalculator> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  String _finalPrice = '';

  void _calculateDiscount() {
    final double? price = double.tryParse(_priceController.text);
    final double? discount = double.tryParse(_discountController.text);

    if (price == null || discount == null) {
      setState(() {
        _finalPrice = 'Invalid input';
      });
      return;
    }

    final double finalPrice = price - (price * discount / 100);

    setState(() {
      _finalPrice = finalPrice.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Discount Calculator"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter original price:',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            _buildInputField(_priceController),
            SizedBox(height: 20),
            Text(
              'Enter discount percentage:',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            _buildInputField(_discountController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateDiscount,
              child: Text('Calculate Discount'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                padding: EdgeInsets.symmetric(vertical: 20),
                textStyle: TextStyle(fontSize: 20),
                minimumSize: Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Final Price: $_finalPrice',
              style: TextStyle(fontSize: 24, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Enter value',
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
