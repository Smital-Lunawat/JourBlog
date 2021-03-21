import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? sampleImage;
  String? _myValue;
  final formKey = GlobalKey<FormState>();
  ImagePicker _picker = ImagePicker();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future getImage() async {
    var tempImage = await _picker.getImage(source: ImageSource.gallery);
    final File file = File(tempImage!.path);

    setState(() {
      sampleImage = file;
    });
  }

  void uploadStatusImage() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      var timeKey = DateTime.now();
      String name = timeKey.toString() + ".jpg";
      TaskSnapshot taskSnapshot = await FirebaseStorage.instance
          .ref('Post Images/$name')
          .putFile(sampleImage as File);

      String imageURL = await taskSnapshot.ref.getDownloadURL();

      print("Image url=" + imageURL);
      saveToDatabase(imageURL);

      Navigator.pop(context);
    }
  }

  void saveToDatabase(imageURL) {
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d, yyyy');
    var formatTime = DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    CollectionReference posts = FirebaseFirestore.instance
        .collection('Posts')
        .doc('${auth.currentUser!.uid}')
        .collection("UsersPosts");
    posts
        .add({
          "image": imageURL,
          "description": _myValue!,
          "date": date,
          "time": time,
        })
        .then((value) => print("Post Added"))
        .catchError((error) => print("Failed to add post: $error"));
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("add note"),
        centerTitle: true,
      ),
      body: sampleImage == null
          ? Center(child: Text("Select an Image"))
          : SingleChildScrollView(
              reverse: true,
              padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
              child: enableUpload()),
      floatingActionButton: sampleImage == null
          ? new FloatingActionButton(
              onPressed: getImage,
              tooltip: 'Add Image',
              child: new Icon(Icons.add_a_photo),
            )
          : null,
    );
  }

  Widget enableUpload() {
    return Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Image.file(
              sampleImage as File,
              height: 273.0,
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              decoration: new InputDecoration(labelText: 'Description'),
              minLines: 2,
              maxLines: 25,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Blog Description is required';
                }
              },
              onSaved: (String? value) {
                _myValue = value!;
              },
            ),
            SizedBox(
              height: 15.0,
            ),
            ElevatedButton(
              child: Text("Add a new post"),
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue,
                onPrimary: Colors.white,
                onSurface: Colors.grey,
              ),
              onPressed: uploadStatusImage,
            ),
          ],
        ));
  }
}
