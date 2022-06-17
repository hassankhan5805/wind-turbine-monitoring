import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseReference? _databaseReference = FirebaseDatabase.instance.ref();

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
    createCollection();
    printData();

    super.initState();
  }

  bool doctorView = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
              return Column(
                children: [
                  Row(
                    children: [
                      rowComponent("Temperature",
                          "${snapshot.data.snapshot.value["temperature"].toString().split(".").first}"),
                      rowComponent("Voltage", "${snapshot.data}"),
                    ],
                  ),
                  Row(
                    children: [
                      rowComponent("Current",
                          "${snapshot.data.snapshot.value["current"]}"),
                    ],
                  ),
                ],
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
