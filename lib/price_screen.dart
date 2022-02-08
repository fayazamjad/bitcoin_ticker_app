import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'coin_data.dart';
import 'networkdataget.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  NetworkDataGet networkDataGet = NetworkDataGet();

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> data = [];
    for (var d in currenciesList) {
      var dd = DropdownMenuItem(
        child: Text(d),
        value: d,
      );
      data.add(dd);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value.toString();
          getData();
        });
      },
      items: data,
    );
  }

  Column text() {
    List<Widget> card = [];
    for (int ii = 0; ii < cryptoList.length; ii++) {
      card.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
          child: Card(
            color: Colors.lightBlueAccent,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      '1 ${cryptoList[ii]} = ${ApiResult[cryptoList[ii]]} $selectedCurrency',
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Column(children: card);
  }

  CupertinoPicker iosPicker() {
    List<Text> pickeritem = [];
    for (String i in currenciesList) {
      pickeritem.add(
        Text(
          i,
          textAlign: TextAlign.center,
        ),
      );
    }
    return CupertinoPicker(
      itemExtent: 25.0,
      onSelectedItemChanged: (data) {
        setState(() async {
          selectedCurrency = data.toString();
          getData();
        });
      },
      children: pickeritem,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Map<String, String> ApiResult = {};

  bool isWaiting = false;

  void getData() async {
    //7: Second, we set it to true when we initiate the request for prices.
    isWaiting = true;
    try {
      //6: Update this method to receive a Map containing the crypto:price key value pairs.
      var data = await networkDataGet.getNetworkData(selectedCurrency);
      //7. Third, as soon the above line of code completes, we now have the data and no longer need to wait. So we can set isWaiting to false.
      isWaiting = false;
      setState(() {
        ApiResult = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SpinKitFadingCircle(
            color: Colors.white,
            size: 35.0,
          ),
          text(),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              color: Colors.lightBlue,
              child: Platform.isAndroid ? androidDropdown() : iosPicker()),
        ],
      ),
    );
  }
}
