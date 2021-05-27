import 'dart:io';

import 'package:flutter/material.dart';
import 'package:regexed_validator/regexed_validator.dart';
import './udpSender.dart';

class SenderPage extends StatefulWidget {
  @override
  _SenderPageState createState() => _SenderPageState();
}

class _SenderPageState extends State<SenderPage> {
  // Variables to be kept track of
  InternetAddress _address;
  int _port;
  String _message;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // build methods
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Text("UDP Sender",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold))),
                _buildIp(),
                _buildPort(),
                _buildMsg(),
                Container(
                  width: 250,
                  padding: EdgeInsets.all(20),
                  child: OutlinedButton(
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        _formKey.currentState.save();

                        udpSend(_port, _address, _message);

                        _formKey.currentState.reset();

                        showSentDialog(
                            context,
                            (_address == null)
                                ? "Message Broadcasted"
                                : "Message Sent",
                            (_address == null)
                                ? '255.255.255.255'
                                : _address.toString(),
                            _port.toString(),
                            _message);
                      },
                      child: Text('Send Message',
                          style: Theme.of(context).textTheme.button)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Image.asset("assets/osim_logo.png"),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      leading: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context, '/receive-page');
          },
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
    );
  }

  Widget _buildIp() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(20),
            labelText: 'IP Address',
            hintText: 'Destination IP Address',
            border: OutlineInputBorder(),
            labelStyle: TextStyle(fontSize: 16)),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        validator: (String value) {
          if (value == "") {
            return null;
          }
          if (!validator.ip(value)) {
            return 'Please enter a valid IP Address';
          }
          return null;
        },
        onSaved: (String value) {
          if (value == "") {
            _address = null;
            return;
          }
          _address = InternetAddress(value);
        },
      ),
    );
  }

  Widget _buildPort() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(20),
              labelText: 'Port Number',
              hintText: 'Destination Port Number',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(fontSize: 16)),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          validator: (String value) {
            if (!isNumeric(value)) {
              return 'Please enter a numerical Port Number';
            }
            return null;
          },
          onSaved: (String value) {
            _port = int.parse(value);
          }),
    );
  }

  Widget _buildMsg() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(20),
            labelText: 'Message',
            hintText: 'Your messages',
            border: OutlineInputBorder(),
            labelStyle: TextStyle(fontSize: 16)),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Please enter your message!';
          }
          return null;
        },
        textInputAction: TextInputAction.done,
        maxLines: 5,
        onSaved: (String value) {
          _message = value;
        },
        onFieldSubmitted: (_) {},
      ),
    );
  }

  void showSentDialog(
      BuildContext context, String title, String ip, String port, String msg) {
    Widget okButton = TextButton(
        onPressed: () => Navigator.of(context).pop(), child: Text("OK"));
    AlertDialog sentDialog = AlertDialog(
      title: Text(title),
      content: SizedBox(
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Dest IP: " + ip),
            Text("Dest port: " + port),
            Text("Message: " + msg)
          ],
        ),
      ),
      actions: [okButton],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return sentDialog;
        });
  }
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}
