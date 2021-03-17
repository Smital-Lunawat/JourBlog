import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'HomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? sampleImage;
  late String _myValue;
  final formKey = new GlobalKey<FormState>();
  ImagePicker _picker = ImagePicker();

  Future getImage() async {
    // var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    var tempImage = await _picker.getImage(source: ImageSource.gallery);
    final File file = File(tempImage!.path);

    setState(() {
      sampleImage = file;
    });
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future<void> uploadStatusImage() async {
    if (validateAndSave()) {
      final Reference postImageRef =
          FirebaseStorage.instance.ref().child("Post Images");

      var timeKey = DateTime.now();
      final Reference uploadTask = postImageRef
          .child(timeKey.toString() + ".jpg")
          .putFile(sampleImage!) as Reference;

      // var ImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      String imageURL = await uploadTask.getDownloadURL();
      // await FirebaseStorage.instance.ref().getDownloadURL();
      // url = ImageUrl.toString();
      print("Image url=" + imageURL);

      goToHomePage();
      saveToDatabase(imageURL);
    }
  }

  void saveToDatabase(imageURL) {
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d, yyyy');
    var formatTime = DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var data = {
      "image": imageURL,
      "description": _myValue,
      "date": date,
      "time": time,
    };
    ref.child("Posts").push().set(data);
  }

  void goToHomePage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("add note"),
        centerTitle: true,
      ),
      body: new Center(
        child: sampleImage == null ? Text("Select an Image") : enableUpload(),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget enableUpload() {
    return new Container(
        key: formKey,
        child: Column(
          children: <Widget>[
            Image.file(
              sampleImage as File,
              height: 330.0,
              width: 660.0,
            ),
            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              decoration: new InputDecoration(labelText: 'Description'),
              validator: (value) {
                return value!.isEmpty ? 'Blog Description is required' : null;
              },
              onSaved: (value) {
                _myValue = value!;
              },
            ),
            SizedBox(
              height: 15.0,
            ),
            RaisedButton(
              elevation: 10.0,
              child: Text("Add a new post"),
              textColor: Colors.white,
              color: Colors.pink,
              onPressed: uploadStatusImage,
            )
          ],
        ));
  }
}
