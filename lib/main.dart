import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:wear/wear.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wear OS App',
      theme: ThemeData.dark(),
      home: WatchScreen(),
    );
  }
}

class WatchScreen extends StatelessWidget {
  const WatchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            if (mode == WearMode.active) {
              return MyHomePage();
            } else {
              return AmbientWatchFace();
            }
          },
        );
      },
    );
  }
}

class AmbientWatchFace extends StatelessWidget {
  const AmbientWatchFace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "FlutterOS",
              style: TextStyle(color: Colors.blue[600], fontSize: 30),
            ),
            SizedBox(height: 15),
            FlutterLogo(size: 60),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _currentTime = '';
  String _currentDate = '';
  String _weatherDescription = '';
  double _temperature = 0.0;
  String _location = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    _fetchWeatherData();
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('HH:mm').format(DateTime.now());
      _currentDate = DateFormat('MMM d, y').format(DateTime.now());
    });
    Future.delayed(Duration(seconds: 1), _updateTime);
  }

  Future<void> _fetchWeatherData() async {
    final apiKey =
        'c81d46b4c863da22daed4b1c6b3430a2'; // Reemplaza con tu API Key de OpenWeatherMap
    final city = 'Mexico City'; // Cambia la ciudad según tus necesidades

    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final weatherData = jsonDecode(response.body);
      final weatherDescription = weatherData['weather'][0]['description'];
      final temperature = weatherData['main']['temp'];
      final location = weatherData['name'];

      setState(() {
        _weatherDescription = weatherDescription;
        _temperature = temperature;
        _location = location;
      });
    } else {
      setState(() {
        _weatherDescription = 'Error al obtener el clima';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF263238),
              Color(0xFF37474F),
              Color(0xFF455A64),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _currentTime,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                _currentDate,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 10),
              Text(
                _location,
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 10),
              Text(
                _weatherDescription,
                style: TextStyle(fontSize: 10),
              ),
              SizedBox(height: 10),
              Text(
                '${_temperature.toStringAsFixed(1)}°C',
                style: TextStyle(fontSize: 10),
              ),
              SizedBox(height: 5),
              Text(
                'Jesus Alberto Ronquillo Ramirez',
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                'DS02SV-22',
                style: TextStyle(fontSize: 5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
