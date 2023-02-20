import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Colors/Colors.dart';
import '../Funcations/Funcation.dart';
import '../Messag/Messages.dart';
import 'UserMainPage/Details.dart';

class Search extends SearchDelegate<String> {
  CollectionReference user = FirebaseFirestore.instance.collection("tickets");
  String name = '';
  var context;
  final List<dynamic> list;
  final String userId;

  Search(this.list, this.context, this.userId);

  @override
  //اربع مثودات في السيرش اساسيه البيلد علامه الاكس
  List<Widget> buildActions(BuildContext context) {
    // Action of app bar
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }
//الزر الي بالسيرش حق الرجوع
  @override
  Widget buildLeading(BuildContext context) {
    // الايقون الموجودة قبل المربع النصي
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

//buildResults------------------------------------------------------
  @override
  //نفس كود الايفنت جبناه وغيرنا عليه
  Widget buildResults(BuildContext context) {
    CollectionReference<Map<String, dynamic>> productCollection =
        FirebaseFirestore.instance.collection("tickets");

    // نتيجة البحث
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
          future: productCollection.where("name", isEqualTo: query).get(),
          builder: (BuildContext context, AsyncSnapshot snapshat) {
            if (snapshat.hasError) {
              return Text("${snapshat.error}");
            }
            if (snapshat.hasData) {
              return SizedBox(
                height: 300.h,
                child: mainBody(context, snapshat));
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  } //bulid result

//buildSuggestions-----------------------------------------------------------------------------------
  @override
  //تبع نتايج البحث
  Widget buildSuggestions(BuildContext context) {
    print(list);
    //سوينا زيه عرفنا لست سيرش يرجع قايمه بكل الفعاليات
    var listSearch = query.isEmpty
        ? list
    //اذا ما كتبنا شي يرجعه القايمه كامله
    // اذا كتبنا يرجع لنا الشي صح يرجعه
        : list.where((name) => name.startsWith(query)).toList();
    return ListView.builder(
        itemCount: listSearch.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              query = listSearch[index];
              showResults(context);
            },
            leading: const Icon(Icons.event),
            title: Text(listSearch[index]),
          );
        });
  }
//================================================================
  Widget mainBody(BuildContext context, AsyncSnapshot snapshat) {
    return snapshat.data.docs.length > 0
        ? ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshat.data.docs.length,
            itemBuilder: (context, i) {
              var data = snapshat.data.docs[i].data();
              return InkWell(
                  onTap: () {
                    goTo(
                        context,
                        Details(
                          name: data['name'],
                          city: data['city'],
                          docId: snapshat.data.docs[i].id,
                          detail: data['details'],
                          endData: data['endDate'],
                          fileName: data['fileName'],
                          link: data['link'],
                          location: data['location'],
                          price: data['price'],
                          stDate: data['startDate'],
                          ticketNumbrt: data['totalTicket'],
                          soldOut: data['soldOut'],
                          eventId: data['eventId'],
                          userId: userId,
                        ));
                  },

//=========================================================
                  child: SizedBox(
                    height: 280.h,
                    width: 220.w,
                    child: Card(
                      elevation: 10,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 120.h,
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                  color: white,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        5.0.r), //<-- SEE HERE
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5.0.r)),
                                    child: Image.network(
                                      data['link'],
                                      fit: BoxFit.cover,
                                    ),
                                  ))),
//============================================================================================

                          Padding(
                            padding: EdgeInsets.only(left: 10.0.w, top: 5.h),
                            child: text(context, data['startDate'],
                                mainTextSize, Colors.grey[900]!,
                                align: TextAlign.justify),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0.w),
                            child: text(context, data['name'], mainTextSize,
                                Colors.grey[700]!,
                                align: TextAlign.justify),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0.w),
                            child: text(context, data['city'], mainTextSize,
                                Colors.grey[500]!,
                                align: TextAlign.justify),
                          ),
//============================================================================================
                          const Spacer(),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: iconColor,
                                //Colors.grey[700]!,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.r))),
                            margin: EdgeInsets.all(10.r),
                            padding: EdgeInsets.all(11.r),
                            child: text(
                                context,
                                'Sold out ${data['soldOut']} of ${data['totalTicket']}',
                                subTextSize + 2,
                                white,
                                align: TextAlign.justify),
                          ),
                        ],
                      ),
                    ),
                  ));
            })

//================================================================
        : Center(
            child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2),
                child: Center(
                  child: text(context, 'No Events to show', subTextSize, black,
                      fontWeight: FontWeight.bold),
                )),
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
}
