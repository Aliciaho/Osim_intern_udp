import 'dart:io';

import 'package:udp/udp.dart';

void udpSend(int destPort, InternetAddress address, String msg) async {
  var sender = await UDP.bind(Endpoint.any());

  if (address == null) {
    await sender.send(msg.codeUnits, Endpoint.broadcast(port: Port(destPort)));
    print("Broadcasting!");
  } else {
    await sender.send(
        msg.codeUnits, Endpoint.unicast(address, port: Port(destPort)));
  }
  print("Message sent!");
  sender.close();
}
