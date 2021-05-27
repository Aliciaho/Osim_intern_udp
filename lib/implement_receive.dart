import 'dart:io';
import 'package:intl/intl.dart';
import 'package:udp/udp.dart';

class Receiver {
  String portNumber;
  Function messageListener;
  bool hasChangePort = false;
  var thisTime;
  final df = new DateFormat('dd-MM-yyyy hh:mm:ss a');

  Receiver(this.portNumber, this.messageListener);

  void setHasChangePort(bool hasChange) {
    this.hasChangePort = hasChange;
  }

  void getMessage() async {
    // RawDatagramSocket.bind(InternetAddress.anyIPv4, int.parse(portNumber))
    //     .then((RawDatagramSocket socket) {
    //   print('Datagram socket ready to receive');
    //   print('${socket.address.address}:${socket.port}');
    //   socket.listen((RawSocketEvent e) {
    //     if (hasChangePort == true) {
    //       socket.close();
    //     }
    //     Datagram d = socket.receive();
    //     if (d == null) return "";

    //     String receivedMessage = new String.fromCharCodes(d.data).trim();
    //     thisTime = df.format(DateTime.now());
    //     String printMessage =
    //         'Message from ${d.address.address}:${d.port}:\n$receivedMessage\n$thisTime';
    //     print('Datagram from ${d.address.address}:${d.port}: $receivedMessage');
    //     messageListener(printMessage);
    //   });
    // });
    var receiver =
        await UDP.bind(Endpoint.any(port: Port(int.parse(portNumber))));
    print('Datagram socket ready to receive');
    print('${receiver.socket.address.address}:${receiver.socket.port}');
    // receiving\listening
    receiver.listen((datagram) {
      if (hasChangePort == true) {
        receiver.close();
        print("reciver1 closed");
        return;
      }
      var str = String.fromCharCodes(datagram.data).trim();
      thisTime = df.format(DateTime.now());
      String printMessage =
          'Message from ${datagram.address.address}:${datagram.port}:\n$str\n$thisTime';
      print('Datagram from ${datagram.address.address}:${datagram.port}: $str');
      messageListener(printMessage);
    });
  }
}
