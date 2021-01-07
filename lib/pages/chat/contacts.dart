import 'package:chater/pages/chat/chat.dart';
import 'package:chater/pages/widgets/contact_widget.dart';
import 'package:chater/pages/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:chater/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  final db = new Database();
  SharedPreferences sharedPreferences;
  String _userId;

  @override
  void initState() {
    _getUserId();
    super.initState();
  }

  _getUserId() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _userId = (sharedPreferences.getString("userId") ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: db.users.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  var data = document.data();
                  return data['id'] == _userId
                      ? Container()
                      : ContactWidget(
                          img: data['name'],
                          title: data['name'],
                          detail: data['email'],
                          onTap: () {
                            Get.to(
                              ChatPage(
                                id: document.id,
                                img: data['name'],
                                name: data['name'],
                              ),
                            );
                          },
                        );
                }).toList(),
              );
            }

            return Loading();
          },
        ),
      ),
    );
  }
}
