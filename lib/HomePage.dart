import 'package:flutter/material.dart';
import 'Authentication.dart';

class HomePage extends StatefulWidget {
  HomePage({
    required this.auth,
    required this.onSignedOut,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _logoutUser() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Jour Blog'),
      ),
      body: Container(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightBlue,
        child: Container(
          margin: EdgeInsets.only(left: 70, right: 70),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add_a_photo),
                iconSize: 40,
                color: Colors.white,
                onPressed: null,
              ),
              IconButton(
                icon: Icon(Icons.exit_to_app),
                iconSize: 40,
                color: Colors.white,
                onPressed: _logoutUser,
              ),
              // IconButton(
              //   icon: Icon(Icons.person_outline),
              //   iconSize: 50,
              //   color: Colors.white,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
