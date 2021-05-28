import 'package:flutter/material.dart';
import './implement_receive.dart';
import './message_card.dart';

class UDPReceive extends StatefulWidget {
  @override
  _UDPReceiveState createState() => _UDPReceiveState();
}

class _UDPReceiveState extends State<UDPReceive> {
  final _textEditingController = TextEditingController();
  Receiver receiver = new Receiver(null, null);
  List<String> _messages = [];
  bool isButtonPressed = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textEditingController.dispose();
    super.dispose();
  }

  void messageListener(dynamic message) {
    setState(() {
      _messages.insert(0, message);
    });
    //print(_messages);
  }

  void setPortNumber() {
    receiver = Receiver(_textEditingController.text, messageListener);
    receiver.setHasChangePort(false);
    receiver.getMessage();
  }

  void clearMessageList() {
    setState(() {
      _messages.clear();
      receiver.setHasChangePort(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: <Widget>[
              _buildTitle(),
              buildTextField(),
              SizedBox(height: 20.0),
              buildOutlinedButton(),
              SizedBox(height: 15.0),
              Text("Messages:",
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              buildListView(),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text("UDP Receiver",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Image.asset("assets/osim_logo.png"),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 30.0),
          child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/sender-page');
              },
              child: Icon(Icons.arrow_forward_ios)),
        ),
      ],
    );
  }

  Expanded buildListView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
            itemCount: _messages.length,
            itemBuilder: (BuildContext context, int index) {
              return _messages == null
                  ? Text("")
                  : MessageCard(_messages[index]);
            }),
      ),
    );
  }

  OutlinedButton buildOutlinedButton() {
    return OutlinedButton(
      onPressed: () {
        if (_textEditingController.text.isEmpty) {
          return;
        }
        clearMessageList();
        setPortNumber();
      },
      child: Text('Connect to Port',
          style: TextStyle(
              color: Colors.grey[200],
              fontSize: 15.0,
              fontWeight: FontWeight.bold)),
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.fromLTRB(105.0, 10.0, 105.0, 10.0)),
          backgroundColor: MaterialStateProperty.all(Colors.black),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black, width: 2)))),
    );
  }

  TextField buildTextField() {
    return TextField(
      controller: _textEditingController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
          const Radius.circular(6.0),
        )),
        filled: true,
        fillColor: Colors.white60,
        contentPadding: EdgeInsets.all(15.0),
        hintText: "Plese key in port number",
        labelText: "Port Number",
        labelStyle: TextStyle(fontSize: 16),
      ),
    );
  }
}
