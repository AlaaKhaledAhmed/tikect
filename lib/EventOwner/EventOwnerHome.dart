import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Colors/Colors.dart';
import '../Data/Firebase.dart';
import '../Funcations/Funcation.dart';
import '../Log/Logging.dart';
import '../Messag/Messages.dart';
import 'AddEvent.dart';

class EventOwnerHome extends StatefulWidget {
  const EventOwnerHome({Key? key}) : super(key: key);

  @override
  State<EventOwnerHome> createState() => _EventOwnerHomeState();
}

class _EventOwnerHomeState extends State<EventOwnerHome> {
  CollectionReference ticketsCollection =
      FirebaseFirestore.instance.collection("tickets");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 241, 241, 237),
      appBar: AppBar(
        title: text(context, "Event Owner Home", mainTextSize, white),
        centerTitle: true,
        backgroundColor: iconColor,
        leading:  IconButton(
              onPressed: () {
                goTo(context, const AddEvent());
              },
              icon: const Icon(Icons.add_circle_outline_rounded)),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                goToReplace(context, LogIn());
              },
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreamBuilder(
                stream: ticketsCollection
                    // .orderBy('')
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
    return
        snapshat.data.docs.length > 0
        ?
        Expanded(
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //عدد العناصر في كل صف
              crossAxisSpacing: 0, // المسافات الراسية
              childAspectRatio: 0.55, //حجم العناصر
              mainAxisSpacing: 0 //المسافات الافقية

              ),
          itemCount: snapshat.data.docs.length ,
          itemBuilder: (context, i) {
           var data = snapshat.data.docs[i].data();
            return InkWell(
                onLongPress: () {
                  deleteInformation(i, snapshat.data.docs[i].id, snapshat);
                },
                onTap: () {
                  // goTo(
                  //     context,
                  //     UpdateUser(
                  //       name: data['name'],
                  //       phone: data['phone'],
                  //       docId: snapshat.data.docs[i].id,
                  //     ));
                },

//=========================================================
                child: Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Stack(
                    // alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
//event details==========================================================================================
                      Positioned(
                        top: 120.h,
                        bottom: 10.h,
                        left: -3,
                        right: -3,
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              color: Colors.white,
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                side:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(
                                    15.0.r), //<-- SEE HERE
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10.0.w),
                                child: SizedBox(
                                  height: 140.h,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 70.h,
                                      ),
                                      text(context, data['startDate'],
                                          mainTextSize, Colors.grey[900]!,
                                          align: TextAlign.justify),
                                      text(context, data['name'],
                                          mainTextSize, Colors.grey[700]!,
                                          align: TextAlign.justify),
                                      text(context, data['location'],
                                          mainTextSize, Colors.grey[500]!,
                                          align: TextAlign.justify),
                                      const Spacer(),
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: iconColor,
                                            //Colors.grey[700]!,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.r))),
                                        margin: EdgeInsets.only(top: 10.h),
                                        padding: EdgeInsets.all(11.w),
                                        child: text(context, 'Sold out ${data['soldOut']} of ${data['totalTicket']}',
                                            subTextSize+2, white,
                                            align: TextAlign.justify),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      ),
//image==========================================================================================
                      Positioned(
                        top: 30.h,
                        bottom: 210.h,
                        left: 10.w,
                        right: 10.w,
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                                color: white,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      5.0.r), //<-- SEE HERE
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0.r)),
                                  child: Image.network(
                                   data['link'],
                                    fit: BoxFit.cover,
                                  ),
                                ))),
                      ),
                    ],
                  ),
                ));
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

                  Firbase.delete(docId: id, collection: 'tickets')
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
