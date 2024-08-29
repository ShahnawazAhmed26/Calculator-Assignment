import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
                        style: TextStyle(fontSize: 24, color: Colors.white),
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
            labelStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey[800],
          ),
          items: _currencyList.map((currency) {
            final flagUrl = _getFlagUrlForCurrency(currency);
            return DropdownMenuItem(
              value: currency,
              child: Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: flagUrl,
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.red),
                  ),
                  SizedBox(width: 8),
                  Text(currency),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getFlagUrlForCurrency(String currency) {
    final flagUrls = {
      'USD': 'https://flagpedia.net/data/flags/h80/us.png',
      'BHD': 'https://www.worldometers.info/img/flags/ba-flag.gif',
      'EUR': 'https://upload.wikimedia.org/wikipedia/en/thumb/b/ba/Flag_of_Germany.svg/1280px-Flag_of_Germany.svg.png',
      'GGP': 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Flag_of_Guernsey.svg/1200px-Flag_of_Guernsey.svg.png',
      'GIP': 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/02/Flag_of_Gibraltar.svg/800px-Flag_of_Gibraltar.svg.png?20140908142958',
      'HRK': 'https://www.worldometers.info/img/flags/hr-flag.gif',
      'IMP': 'https://cdn11.bigcommerce.com/s-2lbnjvmw4d/images/stencil/1280x1280/products/2977/5230/isleofman__63002.1614877874.jpg?c=2',
      'IQD': 'https://www.worldometers.info/img/flags/iz-flag.gif',
      'IRR': 'https://www.worldometers.info/img/flags/ir-flag.gif',
      'ISK': 'https://www.worldometers.info/img/flags/ic-flag.gif',
      'JEP': 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Flag_of_the_United_Kingdom_%281-2%29.svg/383px-Flag_of_the_United_Kingdom_%281-2%29.svg.png',
      'KID': 'https://flagpedia.net/data/flags/h80/us.png',
      'KRW': 'https://www.worldometers.info/img/flags/ks-flag.gif',
      'LYD': 'https://www.worldometers.info/img/flags/ly-flag.gif',
      'MRU': 'https://www.worldometers.info/img/flags/mr-flag.gif',
      'SLE': 'https://www.worldometers.info/img/flags/sl-flag.gif',
      'TVD': 'https://seeklogo.com/images/T/taiwan-logo-55EA4050B8-seeklogo.com.png',
      'VES': 'https://www.worldometers.info/img/flags/ve-flag.gif',
      'XDR': 'https://www.imf.org/en/About/brand/-/media/Images/IMF/About/branding/imf-brand-seal-01.ashx',
      'ZMW': 'https://www.worldometers.info/img/flags/za-flag.gif',
      'CVE': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSsPTOxDmPLCKzeMcv5ZzfYoiRwaWAy8Wt1wQ&s',
      'FOK': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtn9aJOe-KIMoZ0MfTDfyJA1nDIKPvNRYzmQ&s',
      'GBP': 'https://flagpedia.net/data/flags/h80/gb.png',
      'JPY': 'https://flagpedia.net/data/flags/h80/jp.png',
      'AUD': 'https://flagpedia.net/data/flags/h80/au.png',
      'CAD': 'https://flagpedia.net/data/flags/h80/ca.png',
      'CHF': 'https://flagpedia.net/data/flags/h80/ch.png',
      'CNY': 'https://flagpedia.net/data/flags/h80/cn.png',
      'SEK': 'https://flagpedia.net/data/flags/h80/se.png',
      'NZD': 'https://flagpedia.net/data/flags/h80/nz.png',
      'PKR': 'https://flagpedia.net/data/flags/h80/pk.png',
      'INR': 'https://flagpedia.net/data/flags/h80/in.png',
      'SGD': 'https://flagpedia.net/data/flags/h80/sg.png',
      'MXN': 'https://flagpedia.net/data/flags/h80/mx.png',
      'BRL': 'https://flagpedia.net/data/flags/h80/br.png',
      'TRY': 'https://flagpedia.net/data/flags/h80/tr.png',
      'RUB': 'https://flagpedia.net/data/flags/h80/ru.png',
      'ZAR': 'https://flagpedia.net/data/flags/h80/za.png',
      'THB': 'https://flagpedia.net/data/flags/h80/th.png',
      'PHP': 'https://flagpedia.net/data/flags/h80/ph.png',
      'HKD': 'https://flagpedia.net/data/flags/h80/hk.png',
      'HUF': 'https://flagpedia.net/data/flags/h80/hu.png',
      'CZK': 'https://flagpedia.net/data/flags/h80/cz.png',
      'ILS': 'https://flagpedia.net/data/flags/h80/il.png',
      'DKK': 'https://flagpedia.net/data/flags/h80/dk.png',
      'NOK': 'https://flagpedia.net/data/flags/h80/no.png',
      'PLN': 'https://flagpedia.net/data/flags/h80/pl.png',
      'RON': 'https://flagpedia.net/data/flags/h80/ro.png',
      'AED': 'https://flagpedia.net/data/flags/h80/ae.png',
      'AFN': 'https://flagpedia.net/data/flags/h80/af.png',
      'ALL': 'https://flagpedia.net/data/flags/h80/al.png',
      'AMD': 'https://flagpedia.net/data/flags/h80/am.png',
      'ANG': 'https://carversreach.com.au/wp-content/uploads/2023/02/netherland-flag.jpg',
      'AOA': 'https://flagpedia.net/data/flags/h80/ao.png',
      'ARS': 'https://flagpedia.net/data/flags/h80/ar.png',
      'AWG': 'https://flagpedia.net/data/flags/h80/aw.png',
      'AZN': 'https://flagpedia.net/data/flags/h80/az.png',
      'BAM': 'https://flagpedia.net/data/flags/h80/ba.png',
      'BBD': 'https://flagpedia.net/data/flags/h80/bb.png',
      'BDT': 'https://flagpedia.net/data/flags/h80/bd.png',
      'BGN': 'https://flagpedia.net/data/flags/h80/bg.png',
      'BIF': 'https://flagpedia.net/data/flags/h80/bi.png',
      'BMD': 'https://flagpedia.net/data/flags/h80/bm.png',
      'BND': 'https://flagpedia.net/data/flags/h80/bn.png',
      'BOB': 'https://flagpedia.net/data/flags/h80/bo.png',
      'BSD': 'https://flagpedia.net/data/flags/h80/bs.png',
      'BTN': 'https://flagpedia.net/data/flags/h80/bt.png',
      'BWP': 'https://flagpedia.net/data/flags/h80/bw.png',
      'BYN': 'https://flagpedia.net/data/flags/h80/by.png',
      'BZD': 'https://flagpedia.net/data/flags/h80/bz.png',
      'CDF': 'https://flagpedia.net/data/flags/h80/cd.png',
      'CLP': 'https://flagpedia.net/data/flags/h80/cl.png',
      'COP': 'https://flagpedia.net/data/flags/h80/co.png',
      'CRC': 'https://flagpedia.net/data/flags/h80/cr.png',
      'CUP': 'https://flagpedia.net/data/flags/h80/cu.png',
      'CVR': 'https://flagpedia.net/data/flags/h80/cv.png',
      'DJF': 'https://flagpedia.net/data/flags/h80/dj.png',
      'DOP': 'https://flagpedia.net/data/flags/h80/do.png',
      'DZD': 'https://flagpedia.net/data/flags/h80/dz.png',
      'EGP': 'https://flagpedia.net/data/flags/h80/eg.png',
      'ERN': 'https://flagpedia.net/data/flags/h80/er.png',
      'ETB': 'https://flagpedia.net/data/flags/h80/et.png',
      'FJD': 'https://flagpedia.net/data/flags/h80/fj.png',
      'FKP': 'https://flagpedia.net/data/flags/h80/fk.png',
      'GEL': 'https://flagpedia.net/data/flags/h80/ge.png',
      'GHS': 'https://flagpedia.net/data/flags/h80/gh.png',
      'GMD': 'https://flagpedia.net/data/flags/h80/gm.png',
      'GNF': 'https://flagpedia.net/data/flags/h80/gn.png',
      'GTQ': 'https://flagpedia.net/data/flags/h80/gt.png',
      'GYD': 'https://flagpedia.net/data/flags/h80/gf.png',
      'HNL': 'https://flagpedia.net/data/flags/h80/hn.png',
      'HTG': 'https://flagpedia.net/data/flags/h80/ht.png',
      'IDR': 'https://flagpedia.net/data/flags/h80/id.png',
      'JMD': 'https://flagpedia.net/data/flags/h80/jm.png',
      'JOD': 'https://flagpedia.net/data/flags/h80/jo.png',
      'KES': 'https://flagpedia.net/data/flags/h80/ke.png',
      'KGS': 'https://flagpedia.net/data/flags/h80/kg.png',
      'KHR': 'https://flagpedia.net/data/flags/h80/kh.png',
      'KMF': 'https://flagpedia.net/data/flags/h80/km.png',
      'KWD': 'https://flagpedia.net/data/flags/h80/kw.png',
      'KYD': 'https://flagpedia.net/data/flags/h80/ky.png',
      'KZT': 'https://flagpedia.net/data/flags/h80/kz.png',
      'LAK': 'https://flagpedia.net/data/flags/h80/la.png',
      'LBP': 'https://flagpedia.net/data/flags/h80/lb.png',
      'LKR': 'https://flagpedia.net/data/flags/h80/lk.png',
      'LRD': 'https://flagpedia.net/data/flags/h80/lr.png',
      'LSL': 'https://flagpedia.net/data/flags/h80/ls.png',
      'MAD': 'https://flagpedia.net/data/flags/h80/ma.png',
      'MDL': 'https://flagpedia.net/data/flags/h80/md.png',
      'MGA': 'https://flagpedia.net/data/flags/h80/mg.png',
      'MKD': 'https://flagpedia.net/data/flags/h80/mk.png',
      'MMK': 'https://flagpedia.net/data/flags/h80/mm.png',
      'MNT': 'https://flagpedia.net/data/flags/h80/mn.png',
      'MOP': 'https://flagpedia.net/data/flags/h80/mo.png',
      'MRO': 'https://flagpedia.net/data/flags/h80/mr.png',
      'MUR': 'https://flagpedia.net/data/flags/h80/mu.png',
      'MVR': 'https://flagpedia.net/data/flags/h80/mv.png',
      'MWK': 'https://flagpedia.net/data/flags/h80/mw.png',
      'MYR': 'https://flagpedia.net/data/flags/h80/my.png',
      'MZN': 'https://flagpedia.net/data/flags/h80/mz.png',
      'NAD': 'https://flagpedia.net/data/flags/h80/na.png',
      'NGN': 'https://flagpedia.net/data/flags/h80/ng.png',
      'NIO': 'https://flagpedia.net/data/flags/h80/ni.png',
      'NPR': 'https://flagpedia.net/data/flags/h80/np.png',
      'OMR': 'https://flagpedia.net/data/flags/h80/om.png',
      'PAB': 'https://flagpedia.net/data/flags/h80/pa.png',
      'PEN': 'https://flagpedia.net/data/flags/h80/pe.png',
      'PGK': 'https://flagpedia.net/data/flags/h80/pg.png',
      'PYG': 'https://flagpedia.net/data/flags/h80/py.png',
      'QAR': 'https://flagpedia.net/data/flags/h80/qa.png',
      'RSD': 'https://flagpedia.net/data/flags/h80/rs.png',
      'RWF': 'https://flagpedia.net/data/flags/h80/rw.png',
      'SAR': 'https://flagpedia.net/data/flags/h80/sa.png',
      'SBD': 'https://flagpedia.net/data/flags/h80/sb.png',
      'SCR': 'https://flagpedia.net/data/flags/h80/sc.png',
      'SDG': 'https://flagpedia.net/data/flags/h80/sd.png',
      'SHP': 'https://flagpedia.net/data/flags/h80/sh.png',
      'SLL': 'https://flagpedia.net/data/flags/h80/sl.png',
      'SOS': 'https://flagpedia.net/data/flags/h80/so.png',
      'SRD': 'https://flagpedia.net/data/flags/h80/sr.png',
      'SSP': 'https://flagpedia.net/data/flags/h80/ss.png',
      'STN': 'https://flagpedia.net/data/flags/h80/st.png',
      'SYP': 'https://flagpedia.net/data/flags/h80/sy.png',
      'SZL': 'https://flagpedia.net/data/flags/h80/sz.png',
      'TJS': 'https://flagpedia.net/data/flags/h80/tj.png',
      'TMT': 'https://flagpedia.net/data/flags/h80/tm.png',
      'TND': 'https://flagpedia.net/data/flags/h80/tn.png',
      'TOP': 'https://flagpedia.net/data/flags/h80/to.png',
      'TTD': 'https://flagpedia.net/data/flags/h80/tt.png',
      'TWD': 'https://flagpedia.net/data/flags/h80/tw.png',
      'TZS': 'https://flagpedia.net/data/flags/h80/tz.png',
      'UAH': 'https://flagpedia.net/data/flags/h80/ua.png',
      'UGX': 'https://flagpedia.net/data/flags/h80/ug.png',
      'UYU': 'https://flagpedia.net/data/flags/h80/uy.png',
      'UZS': 'https://flagpedia.net/data/flags/h80/uz.png',
      'VEF': 'https://flagpedia.net/data/flags/h80/ve.png',
      'VND': 'https://flagpedia.net/data/flags/h80/vn.png',
      'VUV': 'https://flagpedia.net/data/flags/h80/vu.png',
      'WST': 'https://flagpedia.net/data/flags/h80/ws.png',
      'XAF': 'https://flagpedia.net/data/flags/h80/cf.png',
      'XCD': 'https://flagpedia.net/data/flags/h80/ec.png',
      'XOF': 'https://flagpedia.net/data/flags/h80/bf.png',
      'XPF': 'https://flagpedia.net/data/flags/h80/pf.png',
      'YER': 'https://flagpedia.net/data/flags/h80/ye.png',
      'ZMK': 'https://flagpedia.net/data/flags/h80/zm.png',
      'ZWL': 'https://flagpedia.net/data/flags/h80/zw.png',
    };

    return flagUrls[currency] ?? 'https://flagpedia.net/data/flags/h80/unknown.png'; // Default placeholder
  }
}
