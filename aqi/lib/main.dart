import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:aqi/network.dart';
import 'card.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String currentAddress = 'Do you want to know the AQI of your location?';
  Position? currentposition;
  dynamic aqiData;
  var composition = Map();
  bool isLoading = false;
  var aqi, co, no, no2, o3, so2, pm2_5, pm10, nh3;
  String textOnCard = 'Air Composition';
  List<String> contents = [
    'CO',
    'NO',
    'NO2',
    'O3',
    'SO2',
    'PM2_5',
    'PM10',
    'NH3'
  ];

  void updateUI(dynamic nutritionData) {
    setState(() {
      // textOnCard = value;
      composition['CO'] = aqiData['list'][0]['components']['co'].toString();
      composition['NO'] = aqiData['list'][0]['components']['no'].toString();
      composition['NO2'] = aqiData['list'][0]['components']['no2'].toString();
      composition['O3'] = aqiData['list'][0]['components']['o3'].toString();
      composition['SO2'] = aqiData['list'][0]['components']['so2'].toString();
      composition['PM2_5'] =
          aqiData['list'][0]['components']['pm2_5'].toString();
      composition['PM10'] = aqiData['list'][0]['components']['pm10'].toString();
      composition['NH3'] = aqiData['list'][0]['components']['nh3'].toString();
      // servingSize = nutritionData[0]['serving_size_g'].toString();
    });
  }

  Future<dynamic> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please enable Your Location Service');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      setState(() {
        currentposition = position;
        currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      // rethrow;
      print(e);
      // throw;
    }
    if (currentposition != Null) {
      NetworkHelper networkhelper = NetworkHelper(currentposition);
      aqiData = await networkhelper.getData();
      print(aqiData);
    }
    return aqiData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Location'),
        toolbarHeight: 21,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Text(
              currentAddress,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
          currentposition != null
              ? Text('Latitude = ' + currentposition!.latitude.toString())
              : Container(),
          currentposition != null
              ? Text('Longitude = ${currentposition!.longitude}')
              : Container(),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[300], //background color of button
                // side: BorderSide(
                //     width: 3, color: Colors.brown), //border width and color
                elevation: 3, //elevation of button
                shape: RoundedRectangleBorder(
                    //to set border radius to button
                    borderRadius: BorderRadius.circular(30)),
                // padding: EdgeInsets.all(20) //content padding inside button
              ),
              onPressed: () async {
                isLoading = true;
                aqiData = await _determinePosition();
                setState(() {
                  aqi = aqiData['list'][0]['main']['aqi'];
                  // co = aqiData['list'][0]['components']['co'];
                  // no = aqiData['list'][0]['components']['no'];
                  // no2 = aqiData['list'][0]['components']['no2'];
                  // o3 = aqiData['list'][0]['components']['o3'];
                  // so2 = aqiData['list'][0]['components']['so2'];
                  // pm2_5 = aqiData['list'][0]['components']['pm2_5'];
                  // pm10 = aqiData['list'][0]['components']['pm10'];
                  // nh3 = aqiData['list'][0]['components']['nh3'];
                  updateUI(aqiData);

                  isLoading = false;
                });
              },
              child: Text(
                'Yes!! Locate me',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 95, 32, 196)),
              )),
          Text(
            'AQI: $aqi',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 99, 5, 250)),
          ),
          // Text('co: $co'),
          // Text('no: $no'),
          // Text('no2: $no2'),
          // Text('o3: $o3'),
          // Text('so2: $so2'),
          // Text('pm2_5: $pm2_5'),
          // Text('pm10: $pm10'),
          // Text('nh3: $nh3'),
          SizedBox(height: 12),
          MyCardWidget(
              text: textOnCard,
              contents: contents,
              composition: composition,
              isLoading: isLoading)
        ],
      )),
    );
  }
}
