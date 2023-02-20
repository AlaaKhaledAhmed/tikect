import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tikect/Data/Firebase.dart';
import 'package:tikect/Log/Logging.dart';
import 'package:tikect/Messag/Messages.dart';

import '../Colors/Colors.dart';
import '../Funcations/Funcation.dart';
import 'AddUser.dart';
import 'UpdateUser.dart';

class ViewUser extends StatefulWidget {
  const ViewUser({Key? key}) : super(key: key);
  @override
  State<ViewUser> createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text(context, "Manage Event Owner", mainTextSize, white),
        centerTitle: true,
        backgroundColor: iconColor,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                goToReplace(context, LogIn());
              },
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_circle),
        backgroundColor: iconColor,
        onPressed: () {

          goTo(context, const AddUser());
        },
      ),
      body:
       SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreamBuilder(
                stream: userCollection
                    .where('type', isEqualTo: 'eventOwner')
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshat) {
                  if (snapshat.hasError) {
                    return const Center(child: Text("Error check internet!"));
                  }
                  if (snapshat.hasData) {
                    return mainBody(context, snapshat);
                  }

                  return Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 2),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
              SizedBox(height: 10.h)
            ],
          ),
        ),
      ),
    );
  }

//==============================================================
  Widget mainBody(BuildContext context, AsyncSnapshot snapshat) {
    return snapshat.data.docs.length > 0
        ? Expanded(
          child: ListView.builder(
            itemCount: snapshat.data.docs.length ,
          itemBuilder: (context, i) {
              var data = snapshat.data.docs[i].data();
              return InkWell(
                onLongPress: () {
                  deleteInformation(i, snapshat.data.docs[i].id, snapshat);
                },
                onTap: () {
                  goTo(
                      context,
                      //تحديث
                      UpdateUser(
                        name: data['name'],
                        phone: data['phone'],
                        docId: snapshat.data.docs[i].id,
                      ));
                },

//=========================================================
                      child: ListTile(
                      title: Card(
                        elevation: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            getDataName(context, Icons.person, data['name']),
                            getDataName(context, Icons.phone, data['phone'])
                          ],
                      ),
                    )),
              );
            }),
        )
//================================================================
        : Center(
            child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2),
                child: text(context, 'Empty List', subTextSize, black,
                    fontWeight: FontWeight.bold)),
          );
  }

//get section===============================================================================
  getDataName(BuildContext context, IconData icon, String titel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 20.h),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor),
          SizedBox(width: 5.w),
          Expanded(
            child: text(context, titel, subTextSize, black,
                fontWeight: FontWeight.bold, align: TextAlign.start),
          ),
        ],
      ),
    );
  }

//delete====================================================================

  deleteInformation(i, String id, snapshat) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            title: text(
              context,
              deleteData,
              bottomSize,
              black,
              fontWeight: FontWeight.bold,
              align: TextAlign.center,
            ),
            content: text(context, confirmDelete, bottomSize, Colors.grey,
                fontWeight: FontWeight.bold, align: TextAlign.left),
            actions: [
              FlatButton(
                onPressed: () async {
                  Navigator.of(context).pop(true);

                  Firbase.delete(docId: id, collection: 'users')
                      .then((String v) {
                    if (v == 'done') {
                    } else {}
                  });
                },
                child: text(context, 'Yes', bottomSize, red!,
                    fontWeight: FontWeight.bold),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: text(context, 'No', bottomSize, black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}
