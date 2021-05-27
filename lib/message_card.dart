import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  final String message;

  MessageCard(this.message);

  @override
  Widget build(BuildContext context) {
    List<String> parts = [];

    void splitString(String msg) {
      int idx = msg.indexOf("\n");
      parts = [msg.substring(0, idx).trim(), msg.substring(idx + 1).trim()];
    }

    splitString(message);

    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(parts[0]),
        subtitle: Text(parts[1],
            style: TextStyle(
              height: 1.5,
              fontSize: 15.0,
            )),
        isThreeLine: true,
      ),
    );
  }
}
