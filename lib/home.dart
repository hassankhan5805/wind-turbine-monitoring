import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinbox/flutter_spinbox.dart';
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
      backgroundColor: Colors.deepPurple,
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
                  Colors.white.withOpacity(0.1),
                  Colors.deepPurple,
                  Colors.black,
                  Colors.deepPurple,
                ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        rowComponent("Temperature",
                            "${snapshot.data.snapshot.value["temperature"].toString().split(".").first}\u00b0C"),
                        rowComponent("Voltage",
                            "${snapshot.data.snapshot.value["voltage"]}V"),
                      ],
                    ),
                    Container(
                      height: 190,
                      width: width / 2 + 20,
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 6),
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
                              maximum: 30,
                              ranges: <GaugeRange>[
                                GaugeRange(
                                    startValue: 0,
                                    endValue: 2,
                                    color: Colors.green),
                                GaugeRange(
                                    startValue: 2,
                                    endValue: 10,
                                    color: Colors.orange),
                                GaugeRange(
                                    startValue: 10,
                                    endValue: 30,
                                    color: Colors.red)
                              ],
                              pointers: <GaugePointer>[
                                NeedlePointer(
                                    value: double.parse(snapshot
                                        .data.snapshot.value["current"]))
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                    widget: Container(
                                        child: Text(
                                            "${snapshot.data.snapshot.value["current"]}A",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold))),
                                    angle: 90,
                                    positionFactor: 0.5)
                              ])
                        ],
                      ),
                    ),
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
