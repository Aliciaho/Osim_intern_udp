import 'package:flutter/material.dart';
import 'package:osim_intern_udp_final/udp_receive.dart';
import 'package:osim_intern_udp_final/udp_sender.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: UDPReceive(),
      routes: {
        '/sender-page': (context) => SenderPage(),
        '/receive-page': (context) => UDPReceive(),
      },
    );
  }
}
