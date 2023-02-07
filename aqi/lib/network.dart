import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class NetworkHelper {
  // final String url;
  Position? currentPosition;

  NetworkHelper(
    // this.url,
    this.currentPosition,
  );

  static const apiKey = '4bc4668b70eb75d43715b5e00a612ac1';
  Future<dynamic> getData() async {
    http.Response response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/air_pollution?lat=${currentPosition!.latitude}&lon=${currentPosition!.longitude}&appid=$apiKey'));
    print(response.statusCode);

    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data);

      // print(decodedData);
      // print(decodedData['list'][0]['main']['aqi'].toString());
      return decodedData;
    } else {}
  }
}
