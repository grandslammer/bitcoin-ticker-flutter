import 'dart:io' show Platform;

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  int convertedInt;
  String outputData;
  String rawData;

  void initState() {
    super.initState();
    getConversionData();
  }

  void getConversionData() async {
    var data = await CoinData().getCoinData(selectedCurrency: selectedCurrency);
    updateUI(data);
  }

  void updateUI(dynamic data) {
    setState(() {
      rawData = data['bpi']['$selectedCurrency']['rate'];
    });
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> myDropdownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );

      myDropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: myDropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getConversionData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> myPickerItems = [];

    for (String currency in currenciesList) {
      myPickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
//        selectedCurrency = get
      },
      children: myPickerItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $rawData $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
