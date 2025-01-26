import 'package:flutter/material.dart';

import 'Api.dart';

class CurrencyConverterScreen extends StatefulWidget {
  @override
  _CurrencyConverterScreenState createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  Map<String, double> exchangeRates = {};
  String selectedCurrency = "AED";
  double priceInUSD = 100.0; // Example price in USD
  double convertedPrice = 0.0;
  // Map<String, double> exchangeRates = {
  //   "AED": 3.673031,
  //   "AFN": 66.999769,
  //   "ALL": 90.349837,
  //   "AMD": 387.240484,
  //   // Add more currencies as needed
  // };
  // String selectedCurrency = "AED";
  // double priceInUSD = 100.0; // Example price in USD
  // double convertedPrice = 0.0;

  @override void initState() {
    super.initState();
    fetchData();
  }
  // @override
  // void initState() {
  //   super.initState();
  //   // Convert price initially
  //   _convertPrice();
  // }

  fetchData() async {
    final response = await Api.currencyApi();
    if (response != null) {
      setState(() {
        exchangeRates = response!.rates?.toJson().map((key, value) {
          // Convert value to double if it is a string
          double rate = value is String ? double.parse(value) : value.toDouble();
          return MapEntry(key.toString(), rate);
        }) ?? {};
        _convertPrice();
      });
    }
  }

  // fetchData() async {
  //   final response = await Api.currencyApi();
  //   if (response != null) {
  //     setState(() {
  //       exchangeRates = response!.rates?.toJson().map((key, value) => MapEntry(key.toString(), value.toDouble())) ?? {};
  //       _convertPrice();
  //     });
  //   }
  // }

  void _convertPrice() {
    setState(() {
      convertedPrice = priceInUSD * (exchangeRates[selectedCurrency] ?? 1.0);
    });
  }

  // void _convertPrice() {
  //   setState(() {
  //     convertedPrice = priceInUSD * (exchangeRates[selectedCurrency] ?? 1.0);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Currency:'),
            DropdownButton<String>(
              value: selectedCurrency,
              items: exchangeRates.keys.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedCurrency = newValue!;
                  _convertPrice();
                });
              },
            ),
            SizedBox(height: 20),
            Text('Price in USD: \$${priceInUSD.toStringAsFixed(2)}'),
            SizedBox(height: 10),
            Text('Converted Price: ${convertedPrice.toStringAsFixed(2)} $selectedCurrency'),
          ],
        ),
      ),
    );
  }
}
