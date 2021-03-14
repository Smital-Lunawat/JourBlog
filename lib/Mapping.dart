import 'package:flutter/material.dart';
import 'LoginRegisterPage.dart';
import 'HomePage.dart';
import 'Authentication.dart';

// class MappingPage extends StatefulWidget {
//   @override
//   _MappingPageState createState() => _MappingPageState();
//   final AuthImplementation auth;

//   MappingPage({
//     this.auth,
//   });
// }

// class _MappingPageState extends State<MappingPage> {
//   @override
//   Widget build(BuildContext context) {
//     return _MappingPageState
//   }
// }

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class MappingPage extends StatefulWidget {
  final AuthImplementation auth;

  MappingPage({
    required this.auth,
  });

  State<StatefulWidget> createState() {
    return _MappingPageState();
  }
}

class _MappingPageState extends State<MappingPage> {
  AuthStatus _authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    super.initState();

    widget.auth.getCurrentUser().then((firebaseUserId) {
      setState(() {
        _authStatus = firebaseUserId == null
            ? AuthStatus.notSignedIn
            : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      _authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.notSignedIn:
        return LoginRegisterPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        return HomePage(
          auth: widget.auth,
          onSignedOut: _signedOut,
        );
    }
  }
}
