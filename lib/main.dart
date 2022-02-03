// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Position? _location;
  Position? _otherLocation;
  String _distance = '';

  Future<void> checkPermissinon() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
  }

  Future<void> getLocation() async {
    await checkPermissinon();
    // 現在の位置を返す
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // // 北緯がプラス。南緯がマイナス
    // print("緯度: " + position.latitude.toString());
    // // 東経がプラス、西経がマイナス
    // print("経度: " + position.longitude.toString());
    // // 高度
    // print("高度: " + position.altitude.toString());
    // 距離をメートルで返す
    double distanceInMeters =
        Geolocator.distanceBetween(35.68, 139.76, -23.61, -46.40);
    print(distanceInMeters);
    // 方位を返す
    double bearing = Geolocator.bearingBetween(35.68, 139.76, -23.61, -46.40);
    print(bearing);
    setState(() {
      _location = position;
    });
  }

  Future<void> getOtherLocation() async {
    await checkPermissinon();
    // 現在の位置を返す
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _otherLocation = position;
    });
    getDistance();
  }

  Future<void> getDistance() async {
    final myLoc = _location;
    final otherLoc = _otherLocation;
    if (myLoc == null || otherLoc == null) {
      return;
    }

    double distanceInMeters = Geolocator.distanceBetween(
        myLoc.latitude, myLoc.longitude, otherLoc.latitude, otherLoc.longitude);
    print(distanceInMeters);
    // 方位を返す
    double bearing = Geolocator.bearingBetween(
        myLoc.latitude, myLoc.longitude, otherLoc.latitude, otherLoc.longitude);
    print(bearing);
    setState(() {
      _distance = distanceInMeters.toString();
    });
  }
  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            const Text(
              '現在の位置は:',
            ),
            Text(
              _location.toString(),
              style: Theme.of(context).textTheme.headline4,
            ),
            const Text(
              '距離は:',
            ),
            Text(
              _distance,
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(onPressed: getOtherLocation, child: const Text("計算"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getLocation,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
