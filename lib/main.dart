import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:location/location.dart';
import 'package:weather/weather.dart';
import 'package:windowpane/geocoding.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'pages/list.dart';
import 'pages/grid.dart';
import 'pages/settings.dart';
import 'new_photo.dart';
import 'database/db.dart' as db;
import 'pages/settings.dart';
import 'pages/image_info.dart';


late final List<CameraDescription> _cameras;
bool isTwentyFourClock = false;
bool isFarenheit = false;

late String loc;
late String wthr;
late int temp;
late String date;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  await db.init();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light(useMaterial3: true),
      dark: ThemeData.dark(useMaterial3: true),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'WindowPane',
        theme: theme,
        darkTheme: darkTheme,
        home: CustomMainScaffold(title: 'WindowPane', child: HomePage()),
        routes: {
          '/list': (context) => CustomMainScaffold(
                title: 'List',
                child: ListPage(),
              ),
          '/grid': (context) => CustomMainScaffold(
                title: 'Grid',
                child: GridPage(),
              ),
          '/image_info' : (context) => ImageInfoCustomWidget(),
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [Text("")],
      ),
    );
  }
}

//Custom Widget to retain settings for all routes
class CustomMainScaffold extends StatelessWidget {
  final Widget child;
  final String title;

  //Constructor
  CustomMainScaffold({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Settings Appbar
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(title),
        actions: <Widget>[
          IconButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsPage(isFarenheit: isFarenheit, isTwentyFourClock: isTwentyFourClock,))),
              icon: const Icon(Icons.settings)),
        ],
      ),
      body: child,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _apiCalls();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NewPhoto(
                    camera: _cameras.first,
                    location: loc,
                    weather: wthr,
                    temp: temp,
                  )));
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(label: 'List', icon: Icon(Icons.list)),
          BottomNavigationBarItem(
              label: 'Grid', icon: Icon(Icons.grid_on_outlined)),
          BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
        ],
        onTap: (index) =>
            Navigator.of(context).pushReplacementNamed(switch (index) {
          0 => '/list',
          1 => '/grid',
          2 => '/',
          _ => throw UnimplementedError(),
        }),
      ),
    );
  }
}

Future<void> _apiCalls() async {
  //Location Call
  loc = 'Check your internet/location settings...';
  loc = await getLocation();
  wthr = await getWeather();
  temp = await getTemp();
  //DateTime Call
  date = getDate();
}

////////////////////
//   DATE/TIME CALL
////////////////////
String getDate() {
  return DateTime.now().toIso8601String();
}

////////////////////
//   WEATHER CALL
////////////////////
Future<String> getWeather() async {
  String wthr = '';
  var connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult != ConnectivityResult.none) {
    String key = 'c7b79e50fee4658a0dbc6c6bbecca72b';
    WeatherFactory wf = WeatherFactory(key);
    Weather w = await wf.currentWeatherByLocation(latitude, longitude);

    if (isFarenheit) {
      wthr = w.weatherDescription!;
    } else {
      wthr =
          w.weatherDescription!;
    }
  } else {
    wthr = 'Check your internet connection...';
  }
  return wthr;
}


Future<int> getTemp() async {
  int temperature = 0;
  var connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult != ConnectivityResult.none) {
    String key = 'c7b79e50fee4658a0dbc6c6bbecca72b';
    WeatherFactory wf = WeatherFactory(key);
    Weather w = await wf.currentWeatherByLocation(latitude, longitude);
    temperature = w.temperature!.fahrenheit!.toInt();
  } else {
    temperature = 0;
  }
  return temperature;
}

////////////////////
//   LOCATION CALL
////////////////////
Future<String> getLocation() async {
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return ''; //return empty string on error
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return ''; //return empty string on error
    }
  }

  _locationData = await location.getLocation();
  if (_locationData.latitude != null && _locationData.longitude != null) {
    latitude = _locationData.latitude as double;
    longitude = _locationData.longitude as double;

    return getAddressFromLocation(latitude, longitude);
  } else {
    return _locationData.toString();
  }
}