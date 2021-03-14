import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UploadPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _UploadPhotoPageState();
  }
}

class _UploadPhotoPageState extends State<UplaodPhotoPage> {
  File sampleImage;
  String _myValue;
  final formKey = new GlobalKey<FormState>();

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
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
              sampleImage,
              height: 330.0,
              width: 660.0,
            ),
            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              decoration: new InputDecoration(labelText: 'Description'),
              validator: (value) {
                return value.isEmpty ? 'Blod Description is required' : null;
              },
              onSaved: (value) {
                return _myValue = value;
              },
            ),
            SizedBox(
              height: 15.0,
            ),
            RaisedButton(
              elevation: 10.0,
              child: Text("add a new post"),
              textColor: Colors.white,
              color: Colors.pink,
              onPressed: validateAndSave,
            )
          ],
        ));
  }
}
