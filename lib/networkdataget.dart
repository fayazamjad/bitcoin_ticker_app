import 'dart:convert';

import 'package:bitcoin_ticker_app/coin_data.dart';
import 'package:http/http.dart' as http;

const api = '63DB2D9A-3822-43C5-9995-16D7CED52562';

class NetworkDataGet {
  // List<double> Data = [];
  Future getNetworkData(String currencie) async {
    Map<String, String> coindata = {};
    for (String data in cryptoList) {
      String url =
          'https://rest.coinapi.io/v1/exchangerate/$data/$currencie?apikey=$api';
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var currenciesdata = jsonDecode(response.body);
        double resultdata = currenciesdata['rate'];
        coindata[data] = resultdata.toStringAsFixed(2);
      } else {
        return 'error';
      }
    }
    return coindata;
  }

  // String usd = 'USD';
  //
  // Future<dynamic> getNetwork(usd) async {
  //   for (String data in cryptoList) {
  //     http.Response response = await http.get(Uri.parse(
  //         'https://rest.coinapi.io/v1/exchangerate/$data/$usd?apikey=$api'));
  //     if (response.statusCode == 200) {
  //       var currenciesdata = jsonDecode(response.body);
  //       var resultdata = currenciesdata['rate'];
  //       Data.add(resultdata);
  //     } else {
  //       return 'error';
  //     }
  //   }
  // }

  // List<double> getResult() {
  //   // await getNetwork(usd);
  //   return Data;
  // }
}
