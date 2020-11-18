import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather/models.dart';
import 'package:weather/page_dots.dart';
import 'package:weather/weather_icons.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final locations = ['Manyara', 'Mbeya', 'Dar es Salaam'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _pageController = new PageController();
  int tabIndex = 0;

  List _pages = [];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery
        .of(context)
        .size
        .height;
    final _width = MediaQuery
        .of(context)
        .size
        .width;

    final regions = ['Dar es Salaam', 'Mbeya', 'Manyara'];
    return Scaffold(
      body: Container(
        height: _height - MediaQuery
            .of(context)
            .padding
            .top,
        width: _width,
        color: Color(0xff3d2441),
        padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0, bottom: 5.0),
        margin: EdgeInsets.only(top: MediaQuery
            .of(context)
            .padding
            .top),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            width: _width - 10,
            height: _height,
            padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF6B2652), Color(0xFF3E2E4E)])),
            child: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  children: [
                    ...regions.map((region) => weatherScreen(region))
                  ],
                ),
                Dots(
                  controller: _pageController,
                  itemCount: regions.length,
                  onPageSelected: (int page) {
                    _pageController.animateToPage(
                        page, duration: Duration(milliseconds: 400),
                        curve: Curves.bounceInOut);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getStatsTile(icon, key, value, units, _width, primaryColor, secondaryColor) {
    /// [icon] - the icon to be displayed on top
    /// [key] - the title of the tile
    /// [value] - the value of the tile
    /// [width] - overall device width as based on media query
    ///  [primaryColor] - the color of the whole tile
    ///  [secondaryColor] - the color of the below ribbon of the tile
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        width: (_width / 3) - 20.0,
        padding: EdgeInsets.only(top: 10.0, bottom: 0.0),
        decoration: BoxDecoration(color: primaryColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(
                  color: Colors.white24.withOpacity(.02),
                  borderRadius: BorderRadius.circular(30.0)),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              child: RichText(
                text: TextSpan(
                    text: '$value',
                    style:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
                    children: <TextSpan>[
                      TextSpan(
                          text: '$units',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w300))
                    ]),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              color: secondaryColor,
              height: 30.0,
              width: double.infinity,
              child: Center(
                child: Text(
                  '$key',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  weatherScreen(region) {
    double _width = MediaQuery
        .of(context)
        .size
        .width;
    double _height = MediaQuery
        .of(context)
        .size
        .height;
    List data = [];
    return FutureBuilder(
        future: getWeatherInfo(region),
        builder: (context, future) {
          if (future.connectionState == ConnectionState.done) {
            final results = jsonDecode(future.data.body);
            WeatherModel weather = WeatherModel(
                condition: results['weather'].first['main'],
                temp: results['main']['temp'],
                visibility: results['visibility'],
                windSpeed: results['wind']['speed'],
                pressure: results['main']['pressure'],
                humidity: results['main']['humidity']);
            data = [
              {
                'width': _width,
                'icon': Weather.wind,
                'key': 'Wind',
                'value': weather.windSpeed,
                'units': 'km/h',
                'primaryColor': Color(0xFFB93B58),
                'secondaryColor': Color(0xFFA42B42),
              },
              {
                'width': _width,
                'icon': Weather.water,
                'key': 'Humidity',
                'value': weather.humidity,
                'units': '%',
                'primaryColor': Color(0xFFA64A6F),
                'secondaryColor': Color(0xFF92395D),
              },
              {
                'width': _width,
                'icon': Weather.gauge,
                'key': 'Air Pressure',
                'value': weather.pressure,
                'units': 'hpa',
                'primaryColor': Color(0xFFA64A6F),
                'secondaryColor': Color(0xFF92395D),
              },
            ];
            return Container(
              width: _width - 10,
              height: _height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF6B2652), Color(0xFF3E2E4E)])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// the first container keeps the temperature and
                        /// the condition along with the region while the
                        /// second one keeps the icon of the moon or the sun
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${weather.temp}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 62.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Text('°',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 42.0,
                                          fontWeight: FontWeight.w300)),
                                ],
                              ),
                              Container(
                                child: Text(
                                  '${weather.condition}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 30.0),
                                ),
                              ),
                              Container(
                                child: Text(
                                  '$region',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Icon(Icons.wb_sunny),
                        )
                      ],
                    ),
                  ),
                  // this container contains bottom tiles
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ...data.map((item) =>
                            getStatsTile(
                                item['icon'],
                                item['key'],
                                item['value'],
                                item['units'],
                                _width,
                                item['primaryColor'],
                                item['secondaryColor'])),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return Container();
        });
  }

  getWeatherInfo(region) async {
    return http.get('https://api.openweathermap.org/data/2.5/weather?q'
        '=$region&appid=8e50c646468aecdc448cbacfcd3a3e79&units=metric');
  }
}
