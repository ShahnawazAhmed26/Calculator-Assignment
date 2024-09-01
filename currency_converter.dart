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
  'AFN': {'name': 'Afghan - Afghani', 'flag': 'https://flagpedia.net/data/flags/h80/af.png'},
  'AMD': {'name': 'Armenian - Dram', 'flag': 'https://flagpedia.net/data/flags/h80/am.png'},
  'BAM': {'name': 'Bosnia and Herzegovina - Convertible Mark', 'flag': 'https://flagpedia.net/data/flags/h80/ba.png'},
  'BIF': {'name': 'Burundian - Franc', 'flag': 'https://flagpedia.net/data/flags/h80/bi.png'},
  'KPW': {'name': 'North Korean - Won', 'flag': 'https://flagpedia.net/data/flags/h80/kp.png'},
  'LAK': {'name': 'Lao - Kip', 'flag': 'https://flagpedia.net/data/flags/h80/la.png'},
  'MZN': {'name': 'Mozambican - Metical', 'flag': 'https://flagpedia.net/data/flags/h80/mz.png'},
  'NAD': {'name': 'Namibian - Dollar', 'flag': 'https://flagpedia.net/data/flags/h80/na.png'},
  'NPR': {'name': 'Nepalese - Rupee', 'flag': 'https://flagpedia.net/data/flags/h80/np.png'},
  'SLL': {'name': 'Sierra Leonean - Leone', 'flag': 'https://flagpedia.net/data/flags/h80/sl.png'},
  'SOS': {'name': 'Somali - Shilling', 'flag': 'https://flagpedia.net/data/flags/h80/so.png'},
  'SRD': {'name': 'Surinamese - Dollar', 'flag': 'https://flagpedia.net/data/flags/h80/sr.png'},
  'TJS': {'name': 'Tajikistani - Somoni', 'flag': 'https://flagpedia.net/data/flags/h80/tj.png'},
  'TMT': {'name': 'Turkmenistani - Manat', 'flag': 'https://flagpedia.net/data/flags/h80/tm.png'},
  'KGS': {'name': 'Kyrgyzstani - Som', 'flag': 'https://flagpedia.net/data/flags/h80/kg.png'},
  'VUV': {'name': 'Vanuatu - Vatu', 'flag': 'https://flagpedia.net/data/flags/h80/vu.png'},
  'SBD': {'name': 'Solomon Islands - Dollar', 'flag': 'https://flagpedia.net/data/flags/h80/sb.png'},
  'MNT': {'name': 'Mongolian - Tugrik', 'flag': 'https://flagpedia.net/data/flags/h80/mn.png'},
  'FJD': {'name': 'Fijian - Dollar', 'flag': 'https://flagpedia.net/data/flags/h80/fj.png'},
  'PGK': {'name': 'Papua New Guinean - Kina', 'flag': 'https://flagpedia.net/data/flags/h80/pg.png'},
  'KYD': {'name': 'Cayman Islands - Dollar', 'flag': 'https://flagpedia.net/data/flags/h80/ky.png'},
  'BND': {'name': 'Bruneian - Dollar', 'flag': 'https://flagpedia.net/data/flags/h80/bn.png'},
  'GIP': {'name': 'Gibraltar - Pound', 'flag': 'https://flagpedia.net/data/flags/h80/gi.png'},
  'DJF': {'name': 'Djiboutian - Franc', 'flag': 'https://flagpedia.net/data/flags/h80/dj.png'},
  'ERN': {'name': 'Eritrean - Nakfa', 'flag': 'https://flagpedia.net/data/flags/h80/er.png'},
  'XPF': {'name': 'CFP Franc', 'flag': 'https://flagpedia.net/data/flags/h80/pf.png'},
  'MGA': {'name': 'Malagasy - Ariary', 'flag': 'https://flagpedia.net/data/flags/h80/mg.png'},
  'STN': {'name': 'São Tomé and Príncipe - Dobra', 'flag': 'https://flagpedia.net/data/flags/h80/st.png'},
  'GMD': {'name': 'Gambian - Dalasi', 'flag': 'https://flagpedia.net/data/flags/h80/gm.png'},
  'MWK': {'name': 'Malawian - Kwacha', 'flag': 'https://flagpedia.net/data/flags/h80/mw.png'},
  'KID': {'name': 'Kiribati - Dollar', 'flag': 'https://flagpedia.net/data/flags/h80/ki.png'},
  'LSL': {'name': 'Lesotho - Loti', 'flag': 'https://flagpedia.net/data/flags/h80/ls.png'},
  'MOP': {'name': 'Macanese - Pataca', 'flag': 'https://flagpedia.net/data/flags/h80/mo.png'},
  'KMF': {'name': 'Comorian - Franc', 'flag': 'https://flagpedia.net/data/flags/h80/km.png'},
  'PKR': {'name': 'Pakistani - Rupee', 'flag': 'https://flagpedia.net/data/flags/h80/pk.png'},

};




  @override
  void initState() {
    super.initState();
    _fetchConversionRates();
  }

Future<void> _fetchConversionRates() async {
    final url = 'https://data.fixer.io/api/latest?access_key=b012743447cbeb19dd65c331ba7c3a9b'; // Fixer.io URL
    try {
      final response = await http.get(Uri.parse(url));

      // Print the response body and status code for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map<String, dynamic> && data.containsKey('rates')) {
          final rates = data['rates'] as Map<String, dynamic>;

          setState(() {
            _conversionRates = rates.map((key, value) => MapEntry(key, value.toDouble()));
            _errorMessage = ''; // Clear any previous error messages
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
      // Avoid conversion if rates are not yet available
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
      _errorMessage = ''; // Clear any previous error messages
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
                      if (_errorMessage.isNotEmpty) ...[
                        SizedBox(height: 20),
                        Text(
                          _errorMessage,
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      ],
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
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: value,
                onChanged: onChanged,
                isExpanded: true, // Ensure the dropdown takes the available space
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: TextStyle(color: Colors.yellow), // Label text color
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey[800],
                ),
                style: TextStyle(color: Colors.yellow),
                items: _countryDetails.keys.map((countryCode) {
                  final country = _countryDetails[countryCode];
                  return DropdownMenuItem<String>(
                    value: countryCode,
                    child: Row(
                      children: [
                        // Display the country flag
                        Image.network(
                          country?['flag'] ?? '',
                          width: 24,
                          height: 24,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.flag, color: Colors.grey),
                        ),
                        SizedBox(width: 8),
                        // Display the country name
                        Expanded(
                          child: Text(
                            country?['name'] ?? countryCode,
                            style: TextStyle(color: Colors.black),
                            overflow: TextOverflow.ellipsis, // Handle long text
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}