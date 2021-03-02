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
//     return _MappingPageState();
//   }
// }

class MappingPage extends StatefulWidget {
  final AuthImplementation auth;

  MappingPage({
    this.auth,
  });

  State<StatefulWidget> createState() {
    return mappingPageState();
  }

  State<StatefulWidget> mappingPageState() {
    return mappingPageState();
  }
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

abstract class _MappingPageState extends State<MappingPage> {
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
        return new LoginRegisterPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );
    }
    return null;
  }
}
