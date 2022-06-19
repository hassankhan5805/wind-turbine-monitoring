import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseReference? _databaseReference = FirebaseDatabase.instance.reference();

  void setDataFirstTime(String cmd, String cmdValue) {
    _databaseReference!.child("123").update({cmd: cmdValue}).asStream();
    print("$cmd  $cmdValue");
  }

  createCollection() {
    setDataFirstTime("temperature", "0");
    setDataFirstTime("voltage", "0");
    setDataFirstTime("current", "0");
  }

  DataSnapshot? a;
  printData() async {
    a = await _databaseReference!.get();
  }

  bool data_ready = false;
  @override
  void initState() {
    // createCollection();
    // printData();

    super.initState();
  }

  bool doctorView = false;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        title: Text("Wind Turbine Monitoring"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: StreamBuilder(
          stream: _databaseReference!.child("123").onValue,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  // Colors.white.withOpacity(0.1),
                  Colors.lightBlue,
                  Colors.white,
                  Colors.lightBlue
                ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 190,
                          width: width / 2.2,
                          alignment: Alignment.center,
                          margin:
                              EdgeInsets.symmetric(vertical: 16, horizontal: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.grey.shade300,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: const Offset(0, 3),
                                )
                              ]),
                          child: SfRadialGauge(
                            title: GaugeTitle(
                                text: "Voltage",
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17)),
                            axes: <RadialAxis>[
                              RadialAxis(
                                  minimum: 0,
                                  maximum: 12,
                                  ranges: <GaugeRange>[
                                    GaugeRange(
                                        startValue: 0,
                                        endValue: 0.5,
                                        color: Colors.green),
                                    GaugeRange(
                                        startValue: 0.5,
                                        endValue: 4,
                                        color: Colors.orange),
                                    GaugeRange(
                                        startValue: 4,
                                        endValue: 12,
                                        color: Colors.red)
                                  ],
                                  pointers: <GaugePointer>[
                                    NeedlePointer(
                                        value: double.parse(snapshot
                                            .data.snapshot.value["voltage"]))
                                  ],
                                  annotations: <GaugeAnnotation>[
                                    GaugeAnnotation(
                                        widget: Container(
                                            child: Column(
                                          children: [
                                            SizedBox(
                                              height: 100,
                                            ),
                                            Text(
                                                "${double.parse(snapshot.data.snapshot.value["voltage"])}V",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        )),
                                        angle: 90,
                                        positionFactor: 0.5)
                                  ])
                            ],
                          ),
                        ),
                        Container(
                          height: 190,
                          width: width / 2.2,
                          alignment: Alignment.center,
                          margin:
                              EdgeInsets.symmetric(vertical: 16, horizontal: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.grey.shade300,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: const Offset(0, 3),
                                )
                              ]),
                          child: SfRadialGauge(
                            title: GaugeTitle(
                                text: "Current",
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17)),
                            axes: <RadialAxis>[
                              RadialAxis(
                                  minimum: 0,
                                  maximum: 10,
                                  ranges: <GaugeRange>[
                                    GaugeRange(
                                        startValue: 0,
                                        endValue: 5,
                                        color: Colors.green),
                                    GaugeRange(
                                        startValue: 5,
                                        endValue: 8,
                                        color: Colors.orange),
                                    GaugeRange(
                                        startValue: 8,
                                        endValue: 10,
                                        color: Colors.red)
                                  ],
                                  pointers: <GaugePointer>[
                                    NeedlePointer(
                                        value: double.parse(snapshot
                                            .data.snapshot.value["current"]))
                                  ],
                                  annotations: <GaugeAnnotation>[
                                    GaugeAnnotation(
                                        widget: Column(
                                          children: [
                                            SizedBox(
                                              height: 100,
                                            ),
                                            Container(
                                                child: Text(
                                                    "${double.parse(snapshot.data.snapshot.value["current"]).toStringAsFixed(4)}A",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                          ],
                                        ),
                                        angle: 90,
                                        positionFactor: 0.5)
                                  ])
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                                height: 250,
                                width: width / 2.2,
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 6),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.grey.shade300,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black45.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 3,
                                        offset: const Offset(0, 3),
                                      )
                                    ]),
                                child: Thermo(
                                    temp:
                                        "${snapshot.data.snapshot.value["temperature"].toString().split(".").first}")),
                            rowComponent("Temp",
                                "${snapshot.data.snapshot.value["temperature"]}")
                          ],
                        ),
                        rowComponent("Power",
                            "${((double.parse(snapshot.data.snapshot.value["voltage"]) * double.parse(snapshot.data.snapshot.value["voltage"])) / 1000).toStringAsFixed(2)}W")
                      ],
                    )
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  rowComponent(String s, String t) {
    return Container(
      alignment: Alignment.center,
      height: 100,
      width: 160,
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.shade200,
          boxShadow: [
            BoxShadow(
              color: Colors.black45.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 3),
            )
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$s',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '$t',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.3),
          ),
        ],
      ),
    );
  }
}

/// Flutter package imports

/// Renders the linear gauge thermometer sample.
class Thermo extends StatefulWidget {
  final String temp;
  Thermo({Key? key, required this.temp}) : super(key: key);

  @override
  State<Thermo> createState() => _ThermoState();
}

class _ThermoState extends State<Thermo> {
  late double _meterValue = double.parse(widget.temp);
  final double _temperatureValue = 37.5;
  @override
  void initState() {
    print("printing temp");
    print(widget.temp);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildThermometer(context);
  }

  /// Returns the thermometer.
  Widget _buildThermometer(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final Brightness brightness = Theme.of(context).brightness;

    return Center(
        child: SizedBox(
            height: MediaQuery.of(context).size.height * 3 / 4,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 11),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        /// Linear gauge to display celsius scale.
                        SfLinearGauge(
                            minimum: -20,
                            maximum: 50,
                            interval: 10,
                            minorTicksPerInterval: 0,
                            axisTrackExtent: 23,
                            axisTrackStyle: LinearAxisTrackStyle(
                                thickness: 12,
                                color: Colors.lightGreen,
                                borderWidth: 1,
                                edgeStyle: LinearEdgeStyle.bothCurve),
                            tickPosition: LinearElementPosition.outside,
                            labelPosition: LinearLabelPosition.outside,
                            orientation: LinearGaugeOrientation.vertical,
                            markerPointers: <LinearMarkerPointer>[
                              LinearWidgetPointer(
                                  markerAlignment: LinearMarkerAlignment.end,
                                  value: 50,
                                  enableAnimation: false,
                                  position: LinearElementPosition.outside,
                                  offset: 8,
                                  child: SizedBox(
                                    height: 30,
                                    child: Text(
                                      '°C',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  )),
                              LinearShapePointer(
                                value: -20,
                                markerAlignment: LinearMarkerAlignment.start,
                                shapeType: LinearShapePointerType.circle,
                                borderWidth: 1,
                                borderColor: brightness == Brightness.dark
                                    ? Colors.white30
                                    : Colors.black26,
                                color: Colors.green,
                                position: LinearElementPosition.cross,
                                width: 24,
                                height: 24,
                              ),
                              LinearShapePointer(
                                value: -20,
                                markerAlignment: LinearMarkerAlignment.start,
                                shapeType: LinearShapePointerType.circle,
                                borderWidth: 6,
                                borderColor: Colors.transparent,
                                color: _meterValue > _temperatureValue
                                    ? const Color(0xffFF7B7B)
                                    : const Color(0xff0074E3),
                                position: LinearElementPosition.cross,
                                width: 24,
                                height: 24,
                              ),
                              LinearWidgetPointer(
                                  value: -20,
                                  markerAlignment: LinearMarkerAlignment.start,
                                  child: Container(
                                    width: 10,
                                    height: 3.4,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                            width: 2.0,
                                            color: Colors.lightBlue),
                                        right: BorderSide(
                                            width: 2.0, color: Colors.blue),
                                      ),
                                      color: _meterValue > _temperatureValue
                                          ? const Color(0xffFF7B7B)
                                          : const Color(0xff0074E3),
                                    ),
                                  )),
                              LinearWidgetPointer(
                                  value: _meterValue,
                                  enableAnimation: false,
                                  position: LinearElementPosition.outside,
                                  onChanged: (dynamic value) {
                                    setState(() {
                                      _meterValue = value;
                                    });
                                  },
                                  child: Container(
                                      width: 16,
                                      height: 12,
                                      transform:
                                          Matrix4.translationValues(4, 0, 0.0),
                                      child: Icon(Icons
                                          .keyboard_arrow_right_outlined))),
                              LinearShapePointer(
                                value: _meterValue,
                                width: 20,
                                height: 20,
                                enableAnimation: false,
                                color: Colors.transparent,
                                position: LinearElementPosition.cross,
                                onChanged: (dynamic value) {
                                  setState(() {
                                    _meterValue = value as double;
                                  });
                                },
                              )
                            ],
                            barPointers: <LinearBarPointer>[
                              LinearBarPointer(
                                value: _meterValue,
                                enableAnimation: false,
                                thickness: 6,
                                edgeStyle: LinearEdgeStyle.endCurve,
                                color: _meterValue > _temperatureValue
                                    ? const Color(0xffFF7B7B)
                                    : const Color(0xff0074E3),
                              )
                            ]),

                        /// Linear gauge to display Fahrenheit  scale.
                        Container(
                            transform: Matrix4.translationValues(-6, 0, 0.0),
                            child: SfLinearGauge(
                              maximum: 120,
                              showAxisTrack: false,
                              interval: 20,
                              minorTicksPerInterval: 0,
                              axisTrackExtent: 24,
                              axisTrackStyle:
                                  const LinearAxisTrackStyle(thickness: 0),
                              orientation: LinearGaugeOrientation.vertical,
                              markerPointers: <LinearMarkerPointer>[
                                LinearWidgetPointer(
                                    markerAlignment: LinearMarkerAlignment.end,
                                    value: 120,
                                    position: LinearElementPosition.inside,
                                    offset: 6,
                                    enableAnimation: false,
                                    child: SizedBox(
                                      height: 30,
                                      child: Text(
                                        '°F',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    )),
                              ],
                            ))
                      ],
                    )))));
  }
}
