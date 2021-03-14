import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'DialogBox.dart';

enum FormType { login, register }

class LoginRegisterPage extends StatefulWidget {
  LoginRegisterPage({
    required this.auth,
    required this.onSignedIn,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  State<StatefulWidget> createState() {
    return _LoginRegisterState();
  }
}

class _LoginRegisterState extends State<LoginRegisterPage> {
  DialogBox dialogBox = DialogBox();

  final formKey = GlobalKey<FormState>();
  FormType _formType = FormType.register;
  String _email = "";
  String _password = "";

  //Methods
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId = await widget.auth.SignIn(_email, _password);
          // dialogBox.information(
          //     context, "Congratulations", "you are logged in successfully!");

          print("login userId: " + userId);
        } else {
          String userId = await widget.auth.SignUp(_email, _password);
          // dialogBox.information(context, "Congratulations",
          //     "your account has been created successfully!");

          print("Registration userId: " + userId);
        }

        widget.onSignedIn();
      } catch (e) {
        dialogBox.information(context, "Error", e.toString());
        print("Error: " + e.toString());
      }
    }
  }

  void moveToRegister() {
    formKey.currentState!.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState!.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  //Design

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Jour Blog"),
      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: createInputs() + createButtons(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> createInputs() {
    return [
      SizedBox(
        height: 10.0,
      ),
      logo(),
      SizedBox(
        height: 20.0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) {
          return value!.isEmpty ? 'Email is required.' : null;
        },
        onSaved: (value) {
          _email = value!;
        },
      ),
      SizedBox(
        height: 10.0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) {
          return value!.isEmpty ? 'Password is required.' : null;
        },
        onSaved: (value) {
          _password = value!;
        },
      ),
      SizedBox(
        height: 20.0,
      ),
    ];
  }

  Widget logo() {
    return new Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 110.0,
        child: Image(image: AssetImage('images/IMG_7111 2.PNG')),
      ),
    );
  }

  List<Widget> createButtons() {
    if (_formType == FormType.login) {
      return [
        RaisedButton(
          child: Text("Login", style: TextStyle(fontSize: 20.0)),
          textColor: Colors.white,
          color: Colors.lightBlue,
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text("Not have an account? Create Account.",
              style: TextStyle(fontSize: 14.0)),
          textColor: Colors.blueAccent,
          onPressed: moveToRegister,
        ),
      ];
    } else {
      return [
        RaisedButton(
          child: Text("Create Account", style: TextStyle(fontSize: 20.0)),
          textColor: Colors.white,
          color: Colors.lightBlue,
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text("Already have an account? Login.",
              style: TextStyle(fontSize: 14.0)),
          textColor: Colors.blueAccent,
          onPressed: moveToLogin,
        ),
      ];
    }
    //
  }

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
