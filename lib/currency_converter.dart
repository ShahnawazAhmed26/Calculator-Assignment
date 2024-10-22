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
  String _errorMessage = '';

  final Map<String, Map<String, String>> _countryDetails = {
    'USD': {'name': 'United States - Dollar', 'flag': 'https://flagpedia.net/data/flags/h80/us.png'},
    'EUR': {'name': 'Euro', 'flag': 'https://flagpedia.net/data/flags/h80/eu.png'},
    'GBP': {'name': 'British - Pound Sterling', 'flag': 'https://flagpedia.net/data/flags/h80/gb.png'},
    'JPY': {'name': 'Japanese - Yen', 'flag': 'https://flagpedia.net/data/flags/h80/jp.png'},
    'AUD': {'name': 'Australian - Dollar', 'flag': 'https://flagpedia.net/data/flags/h80/au.png'},
    'CAD': {'name': 'Canadian - Dollar', 'flag': 'https://flagpedia.net/data/flags/h80/ca.png'},
    'CHF': {'name': 'Swiss - Franc', 'flag': 'https://flagpedia.net/data/flags/h80/ch.png'},
    'CNY': {'name': 'Chinese - Yuan', 'flag': 'https://flagpedia.net/data/flags/h80/cn.png'},
    'SEK': {'name': 'Swedish - Krona', 'flag': 'https://flagpedia.net/data/flags/h80/se.png'},
    'NZD': {'name': 'New Zealand - Dollar', 'flag': 'https://flagpedia.net/data/flags/h80/nz.png'},
    'MXN': {'name': 'Mexican - Peso', 'flag': 'https://flagpedia.net/data/flags/h80/mx.png'},
    'INR': {'name': 'Indian - Rupee', 'flag': 'https://flagpedia.net/data/flags/h80/in.png'},
    'BRL': {'name': 'Brazilian - Real', 'flag': 'https://flagpedia.net/data/flags/h80/br.png'},
    'ZAR': {'name': 'South African - Rand', 'flag': 'https://flagpedia.net/data/flags/h80/za.png'},
    'HKD': {'name': 'Hong Kong - Dollar', 'flag': 'https://flagpedia.net/data/flags/h80/hk.png'},
    'SGD': {'name': 'Singapore - Dollar', 'flag': 'https://flagpedia.net/data/flags/h80/sg.png'},
    'KRW': {'name': 'South Korean - Won', 'flag': 'https://flagpedia.net/data/flags/h80/kr.png'},
    'TRY': {'name': 'Turkish - Lira', 'flag': 'https://flagpedia.net/data/flags/h80/tr.png'},
    'RUB': {'name': 'Russian - Ruble', 'flag': 'https://flagpedia.net/data/flags/h80/ru.png'},
    'NOK': {'name': 'Norwegian - Krone', 'flag': 'https://flagpedia.net/data/flags/h80/no.png'},
    'DKK': {'name': 'Danish - Krone', 'flag': 'https://flagpedia.net/data/flags/h80/dk.png'},
    'PLN': {'name': 'Polish - Zloty', 'flag': 'https://flagpedia.net/data/flags/h80/pl.png'},
    'HUF': {'name': 'Hungarian - Forint', 'flag': 'https://flagpedia.net/data/flags/h80/hu.png'},
    'CZK': {'name': 'Czech - Koruna', 'flag': 'https://flagpedia.net/data/flags/h80/cz.png'},
    'ILS': {'name': 'Israeli - Shekel', 'flag': 'https://flagpedia.net/data/flags/h80/il.png'},
    'THB': {'name': 'Thai - Baht', 'flag': 'https://flagpedia.net/data/flags/h80/th.png'},
    'MYR': {'name': 'Malaysian - Ringgit', 'flag': 'https://flagpedia.net/data/flags/h80/my.png'},
    'PHP': {'name': 'Philippine - Peso', 'flag': 'https://flagpedia.net/data/flags/h80/ph.png'},
    'AED': {'name': 'United Arab Emirates - Dirham', 'flag': 'https://flagpedia.net/data/flags/h80/ae.png'},
    'COP': {'name': 'Colombian - Peso', 'flag': 'https://flagpedia.net/data/flags/h80/co.png'},
    'ARS': {'name': 'Argentine - Peso', 'flag': 'https://flagpedia.net/data/flags/h80/ar.png'},
    'CLP': {'name': 'Chilean - Peso', 'flag': 'https://flagpedia.net/data/flags/h80/cl.png'},
    'PEN': {'name': 'Peruvian - Sol', 'flag': 'https://flagpedia.net/data/flags/h80/pe.png'},
    'BWP': {'name': 'Botswana - Pula', 'flag': 'https://flagpedia.net/data/flags/h80/bw.png'},
    'DOP': {'name': 'Dominican - Peso', 'flag': 'https://flagpedia.net/data/flags/h80/do.png'},
    'GHS': {'name': 'Ghanaian - Cedi', 'flag': 'https://flagpedia.net/data/flags/h80/gh.png'},
    'KWD': {'name': 'Kuwaiti - Dinar', 'flag': 'https://flagpedia.net/data/flags/h80/kw.png'},
    'LYD': {'name': 'Libyan - Dinar', 'flag': 'https://flagpedia.net/data/flags/h80/ly.png'},
    'OMR': {'name': 'Omani - Rial', 'flag': 'https://flagpedia.net/data/flags/h80/om.png'},
    'TND': {'name': 'Tunisian - Dinar', 'flag': 'https://flagpedia.net/data/flags/h80/tn.png'},
    'JMD': {'name': 'Jamaican - Dollar', 'flag': 'https://flagpedia.net/data/flags/h80/jm.png'},
    'PAB': {'name': 'Panamanian - Balboa', 'flag': 'https://flagpedia.net/data/flags/h80/pa.png'},
    'PYG': {'name': 'Paraguayan - Guarani', 'flag': 'https://flagpedia.net/data/flags/h80/py.png'},
    'VND': {'name': 'Vietnamese - Dong', 'flag': 'https://flagpedia.net/data/flags/h80/vn.png'},
    'BDT': {'name': 'Bangladeshi - Taka', 'flag': 'https://flagpedia.net/data/flags/h80/bd.png'},
    'MMK': {'name': 'Burmese - Kyat', 'flag': 'https://flagpedia.net/data/flags/h80/mm.png'},
    'KZT': {'name': 'Kazakhstani - Tenge', 'flag': 'https://flagpedia.net/data/flags/h80/kz.png'},
    'RSD': {'name': 'Serbian - Dinar', 'flag': 'https://flagpedia.net/data/flags/h80/rs.png'},
    'MDL': {'name': 'Moldovan - Leu', 'flag': 'https://flagpedia.net/data/flags/h80/md.png'},
    'GEL': {'name': 'Georgian - Lari', 'flag': 'https://flagpedia.net/data/flags/h80/ge.png'},
    'RWF': {'name': 'Rwandan - Franc', 'flag': 'https://flagpedia.net/data/flags/h80/rw.png'},
    'UGX': {'name': 'Ugandan - Shilling', 'flag': 'https://flagpedia.net/data/flags/h80/ug.png'},
    'TZS': {'name': 'Tanzanian - Shilling', 'flag': 'https://flagpedia.net/data/flags/h80/tz.png'},
    'ETB': {'name': 'Ethiopian - Birr', 'flag': 'https://flagpedia.net/data/flags/h80/et.png'},
    'AOA': {'name': 'Angolan - Kwanza', 'flag': 'https://flagpedia.net/data/flags/h80/ao.png'},
    'MRO': {'name': 'Mauritanian - Ouguiya', 'flag': 'https://flagpedia.net/data/flags/h80/mr.png'},
    'XOF': {'name': 'West African - CFA Franc', 'flag': 'https://flagpedia.net/data/flags/h80/ci.png'},
    'XAF': {'name': 'Central African - CFA Franc', 'flag': 'https://flagpedia.net/data/flags/h80/cm.png'},
    'DZD': {'name': 'Algerian - Dinar', 'flag': 'https://flagpedia.net/data/flags/h80/dz.png'},
    'JOD': {'name': 'Jordanian - Dinar', 'flag': 'https://flagpedia.net/data/flags/h80/jo.png'},
    'NAD': {'name': 'Namibian - Dollar', 'flag': 'https://flagpedia.net/data/flags/h80/na.png'},
    'TMT': {'name': 'Turkmenistani - Manat', 'flag': 'https://flagpedia.net/data/flags/h80/tm.png'},
    'GMD': {'name': 'Gambian - Dalasi', 'flag': 'https://flagpedia.net/data/flags/h80/gm.png'},
    'BIF': {'name': 'Burundian - Franc', 'flag': 'https://flagpedia.net/data/flags/h80/bi.png'},
    'LBP': {'name': 'Lebanese - Pound', 'flag': 'https://flagpedia.net/data/flags/h80/lb.png'},
    'AFN': {'name': 'Afghan - Afghani', 'flag': 'https://flagpedia.net/data/flags/h80/af.png'},
    'SOS': {'name': 'Somali - Shilling', 'flag': 'https://flagpedia.net/data/flags/h80/so.png'},
    'MZN': {'name': 'Mozambican - Metical', 'flag': 'https://flagpedia.net/data/flags/h80/mz.png'},
    'SRD': {'name': 'Surinamese - Dollar', 'flag': 'https://flagpedia.net/data/flags/h80/sr.png'},
    'BSD': {'name': 'Bahamian - Dollar', 'flag': 'https://flagpedia.net/data/flags/h80/bs.png'},
  };

  @override
  void initState() {
    super.initState();
    _fetchConversionRates();
  }

  Future<void> _fetchConversionRates() async {
    final url = 'https://data.fixer.io/api/latest?access_key=b012743447cbeb19dd65c331ba7c3a9b';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('rates')) {
          final rates = data['rates'] as Map<String, dynamic>;
          setState(() {
            _conversionRates = rates.map((key, value) => MapEntry(key, value.toDouble()));
            _errorMessage = '';
          });
        } else {
          setState(() {
            _errorMessage = 'Invalid data format: Rates are missing';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to load conversion rates: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching conversion rates: $e';
      });
    }
  }

  void _convertCurrency() {
    if (_conversionRates.isEmpty) {
      setState(() {
        _errorMessage = 'Conversion rates not available';
      });
      return;
    }

    final fromRate = _conversionRates[_fromCurrency] ?? 1.0;
    final toRate = _conversionRates[_toCurrency] ?? 1.0;
    final amount = double.tryParse(_amountController.text) ?? 0;
    setState(() {
      _convertedAmount = (amount / fromRate) * toRate;
      _errorMessage = '';
    });
  }

Widget _buildCurrencyCard(String title, String selectedCurrency, ValueChanged<String?> onChanged) {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    color: Colors.grey[900],
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: TextStyle(color: Colors.yellow, fontSize: 18)),
          DropdownButton<String>(
            value: selectedCurrency,
            onChanged: onChanged,
            dropdownColor: Colors.grey[900],
            iconEnabledColor: Colors.white,
            items: _countryDetails.keys.map((String currency) {
              return DropdownMenuItem<String>(
                value: currency,
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.network(
                        _countryDetails[currency]!['flag']!,
                        width: 24,
                        height: 24,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 24,
                            height: 24,
                            color: Colors.grey,
                            child: Icon(Icons.error, color: Colors.red, size: 16),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(currency, style: TextStyle(color: Colors.white)),
                  ],
                ),
              );
            }).toList(),
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter' , style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double paddingValue = constraints.maxWidth * 0.04;
          return Padding(
            padding: EdgeInsets.only(
              left: paddingValue,
              right: paddingValue,
              bottom: MediaQuery.of(context).viewInsets.bottom + paddingValue,
            ),
            child: ListView(
              children: <Widget>[
                _buildCurrencyCard('From Currency', _fromCurrency, (newValue) {
                  setState(() {
                    _fromCurrency = newValue!;
                  });
                }),
                SizedBox(height: 16),
                _buildCurrencyCard('To Currency', _toCurrency, (newValue) {
                  setState(() {
                    _toCurrency = newValue!;
                  });
                }),
                SizedBox(height: 16),
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
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                  onPressed: _convertCurrency,
                  child: Text('Convert'),
                ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                if (_convertedAmount > 0)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text(
                        'Converted Amount: ${_convertedAmount.toStringAsFixed(2)} $_toCurrency',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
