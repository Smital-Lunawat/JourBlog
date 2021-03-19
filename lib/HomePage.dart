import 'package:blog_app_vs/PhotoUpload.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'PhotoUpload.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

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
  final FirebaseAuth auth = FirebaseAuth.instance;

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
      body: PaginateFirestore(
          itemBuilderType:
              PaginateBuilderType.listView, // listview and gridview

          itemBuilder: (index, context, documentSnapshot) => Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: documentSnapshot.data()!['image'],
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                  Column(
                    children: [
                      Text(documentSnapshot.data()!['description']),
                      Text(documentSnapshot.data()!['date']),
                      Text(documentSnapshot.data()!['time']),
                    ],
                  ),
                ],
              ),
          // orderBy is compulsary to enable pagination
          itemsPerPage: 10,
          query: FirebaseFirestore.instance
              .collection('Posts')
              .doc('${auth.currentUser!.uid}')
              .collection("UsersPosts")
              .orderBy('time'),
          isLive: true // to fetch real-time data
          ),
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
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return new UploadPage();
                  }));
                },
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
