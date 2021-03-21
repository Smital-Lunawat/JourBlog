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

          itemBuilder: (index, context, documentSnapshot) => Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.shade100.withOpacity(0.4),
                      spreadRadius: 3,
                      blurRadius: 0.2,
                      //offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                        imageUrl: documentSnapshot.data()!['image'],
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Text(
                                  documentSnapshot.data()!['description'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 14.0),
                                  // textDirection: TextDirection.ltr,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            documentSnapshot.data()!['date'],
                            style: TextStyle(fontSize: 10.0),
                          ),
                          Text(
                            documentSnapshot.data()!['time'],
                            style: TextStyle(fontSize: 10.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          // orderBy is compulsary to enable pagination
          itemsPerPage: 10,
          padding: const EdgeInsets.all(10),
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
