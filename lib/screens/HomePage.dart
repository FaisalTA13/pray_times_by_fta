import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late LocationPermission per;
  var Fajr;
  var Fajrf;
  var fajrh;
  var datestring;
  var Dhuhr;
  var Dhuhrf;
  var Dhuhrh;
  var Asr;
  var Asrf;
  var Asrh;
  var Maghrib;
  var Maghribf;
  var Maghribh;
  var Isha;
  var Ishaf;
  var Ishah;
  var hijri;
  var gregorian;
  var hijrimonth;
  var gregorianmonth;
  var serf;
  late double city;
  late double country;
  var url;
  get() async {
    serf = Geolocator.isLocationServiceEnabled();
    if (serf == false) {
      Center(
        child: Column(
          children: [
            Text("يحتاج التطبيق إلى صلاحية الموقع لجلب أوقات الصلاة إلى موقعك"),
            ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    )),
                child: Text("موافق")),
          ],
        ),
      );
    }
    per = await Geolocator.checkPermission();
    if (per == LocationPermission.denied && per == LocationPermission.values) {
      Geolocator.requestPermission();
    }
    if (per == LocationPermission.deniedForever) {
      Center(
        child: Column(
          children: [
            Text("يحتاج التطبيق إلى صلاحية الموقع لجلب أوقات الصلاة إلى موقعك"),
            ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    )),
                child: Text("موافق")),
          ],
        ),
      );

      if (per == LocationPermission.unableToDetermine) {
        Center(
          child: Column(
            children: [
              Text(
                  "يحتاج التطبيق إلى صلاحية الموقع لجلب أوقات الصلاة إلى موقعك"),
              ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      )),
                  child: Text("موافق")),
            ],
          ),
        );
      }
    }
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    city = position.latitude;
    country = position.longitude;
    url =
        "https://api.aladhan.com/v1/timingsByCity?city=$city&country=$country&method=4";
    http.Response response = await http.get(Uri.parse(url), headers: {
      "Accept":
          "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
    });
    var responsebody = jsonDecode(response.body);
    Fajr = responsebody['data']['timings']["Fajr"];
    Fajrf = DateFormat('hh:mm').parse(Fajr);
    fajrh = DateFormat("hh:mm a").format(Fajrf);
    print(fajrh);
    Dhuhr = responsebody['data']['timings']["Dhuhr"];
    Dhuhrf = DateFormat('hh:mm').parse(Dhuhr);
    Dhuhrh = DateFormat("hh:mm a").format(Dhuhrf);
    Asr = responsebody['data']['timings']["Asr"];
    Asrf = DateFormat('hh:mm').parse(Asr);
    Asrh = DateFormat("hh:mm a").format(Asrf);
    Maghrib = responsebody['data']['timings']["Maghrib"];
    Maghribf = DateFormat('hh:mm').parse(Maghrib);
    Maghribh = DateFormat("hh:mm a").format(Maghribf);
    Isha = responsebody['data']['timings']["Isha"];
    Ishaf = DateFormat('hh:mm').parse(Isha);
    Ishah = DateFormat("hh:mm a").format(Ishaf);
    hijri = responsebody['data']['date']['hijri']['date'];
    gregorian = responsebody['data']['date']['gregorian']['date'];
    hijrimonth = responsebody['data']['date']['hijri']['month']['ar'];
    gregorianmonth = responsebody['data']['date']['gregorian']['month']['en'];
    return responsebody;
  }

  @override
  void initState() {
    get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'هجري',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 55,
                                      ),
                                    ),
                                    Text(
                                      '$hijri',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 25,
                                      ),
                                    ),
                                    Text(
                                      '$hijrimonth',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'ميلادي',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 55,
                                      ),
                                    ),
                                    Text(
                                      '$gregorian',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 25,
                                      ),
                                    ),
                                    Text(
                                      '$gregorianmonth',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        height: 50,
                        color: Colors.black,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 100,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 217, 255, 0),
                                      borderRadius: BorderRadius.circular(
                                          1111111111111111),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          '$fajrh',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 30,
                                          ),
                                        ),
                                        Text(
                                          'الفجر',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(3, 0, 3, 0),
                                child: Container(
                                  width: 100,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF3E5A5A),
                                    borderRadius:
                                        BorderRadius.circular(1111111111111111),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        '$Dhuhrh',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 30,
                                        ),
                                      ),
                                      Text(
                                        'الظهر',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(3, 0, 3, 0),
                                child: Container(
                                  width: 100,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFB8B156),
                                    borderRadius:
                                        BorderRadius.circular(1111111111111111),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        '$Asrh',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 30,
                                        ),
                                      ),
                                      Text(
                                        'العصر',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(3, 0, 3, 0),
                                child: Container(
                                  width: 100,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFA76666),
                                    borderRadius:
                                        BorderRadius.circular(1111111111111111),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        '$Maghribh',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 30,
                                        ),
                                      ),
                                      Text(
                                        'المغرب',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(3, 0, 3, 0),
                                child: Container(
                                  width: 100,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF3FC426),
                                    borderRadius:
                                        BorderRadius.circular(1111111111111111),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        '$Ishah',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 30,
                                        ),
                                      ),
                                      Text(
                                        'العشاء',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}