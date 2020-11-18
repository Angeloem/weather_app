import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: _height,
          width: _width,
          color: Color(0xff3d2441),
          padding:
              EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0, bottom: 5.0),
          margin: EdgeInsets.zero,
          child: IntroductionScreen(
            pages: [
              PageViewModel(
                  titleWidget: SizedBox(
                    height: 0,
                  ),
                  bodyWidget: Container(
                    width: _width - 10,
                    height: _height,
                    padding:
                        EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '18',
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
                                        'sunny',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 30.0),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        'Dar es salaam',
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
                            children: [

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  decoration: PageDecoration(
                    pageColor: Color(0xff3d2441),
                    titlePadding: EdgeInsets.zero,
                    imagePadding: EdgeInsets.zero,
                    contentPadding: EdgeInsets.zero,
                    descriptionPadding: EdgeInsets.zero,
                    footerPadding: EdgeInsets.zero,
                  ))
            ],
            // empty done button so as to not disrupt the ui
            done: const Text(''),
            // this method returns an empty map.... its just nothing
            onDone: () => {},
            dotsDecorator: DotsDecorator(
                size: const Size.square(10.0),
                activeSize: const Size(10.0, 10.0),
                activeColor: Colors.white,
                color: Colors.black26,
                spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0))),
          ),
        ),
      ),
    );
  }

  getStatsTile(icon, key, value, _width, primaryColor, secondaryColor) {
    /// [icon] - the icon to be displayed on top
    /// [key] - the title of the tile
    /// [value] - the value of the tile
    /// [width] - overall device width as based on media query
    ///  [primaryColor] - the color of the whole tile
    ///  [secondaryColor] - the color of the below ribbon of the tile
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        width: (_width / 3) - 40.0,
        padding:
        EdgeInsets.only(top: 10.0, bottom: 0.0),
        decoration:
        BoxDecoration(color: Color(0xFFB93B58)),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(
                  color: Colors.white24.withOpacity(.02),
                  borderRadius:
                  BorderRadius.circular(30.0)),
              child: Icon(
                Weather.wind,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.0,),
            Container(
              child: RichText(
                text: TextSpan(
                    text: '1.6',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'km/h',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight:
                              FontWeight.w300))
                    ]),
              ),
            ),
            SizedBox(height: 10.0,),
            Container(
              color: Color(0xFFA42B42),
              height: 30.0,
              width: double.infinity,
              child: Center(
                child: Text(
                  'Wind',
                  style:
                  TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
