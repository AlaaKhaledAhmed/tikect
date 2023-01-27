import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:counter_button/counter_button.dart';

import '../../Colors/Colors.dart';
import '../../Funcations/Funcation.dart';
import '../../Messag/Messages.dart';

class Details extends StatefulWidget {
  final String name;
  final String city;
  final String location;
  final int ticketNumbrt;
  final String stDate;
  final String endData;
  final int price;
  final String detail;
  final String link;
  final String docId;
  final String fileName;
  final int soldOut;
  const Details(
      {Key? key,
      required this.name,
      required this.city,
      required this.location,
      required this.ticketNumbrt,
      required this.stDate,
      required this.endData,
      required this.price,
      required this.detail,
      required this.link,
      required this.docId,
      required this.fileName,
      required this.soldOut})
      : super(key: key);
  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int? totalPrice;
  int? remindTicket;
  int total = 1;
  @override
  void initState() {
    super.initState();
    totalPrice = widget.price;
    remindTicket = widget.ticketNumbrt - widget.soldOut;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: iconColor),
        body: ListView(
          children: [
//image===========================================================
            Container(
                margin: EdgeInsets.all(10.r),
                width: double.infinity,
                height: 200.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    image: DecorationImage(
                      image: NetworkImage(widget.link),
                      fit: BoxFit.cover,
                    ))),
//name===========================================================
            ListTile(
              title: text(
                  context, 'Event title', mainTextSize + 6, Colors.grey[900]!,
                  align: TextAlign.justify, fontWeight: FontWeight.bold),
              subtitle: text(context, widget.name, mainTextSize, Colors.grey,
                  align: TextAlign.justify),
            ),
//price===========================================================
            ListTile(
              title: text(
                  context, 'Event price', mainTextSize + 6, Colors.grey[900]!,
                  align: TextAlign.justify, fontWeight: FontWeight.bold),
              subtitle: text(
                  context, '${widget.price}', mainTextSize, Colors.grey,
                  align: TextAlign.justify),
            ),
//Date===========================================================
            ListTile(
              title: text(
                  context, 'Event Date', mainTextSize + 6, Colors.grey[900]!,
                  align: TextAlign.justify, fontWeight: FontWeight.bold),
              subtitle: text(context, widget.stDate + " to " + widget.endData,
                  mainTextSize, Colors.grey,
                  align: TextAlign.justify),
            ),
//location===========================================================
            ListTile(
              onTap: () async {
                await launch(widget.location);
              },
              title: text(context, 'Event Location', mainTextSize + 6,
                  Colors.grey[900]!,
                  align: TextAlign.justify, fontWeight: FontWeight.bold),
              subtitle: text(context, widget.city, mainTextSize, Colors.grey,
                  align: TextAlign.justify),
            ),
//details===========================================================
            ListTile(
              title: text(context, 'Additional information', mainTextSize + 6,
                  Colors.grey[900]!,
                  align: TextAlign.justify, fontWeight: FontWeight.bold),
              subtitle: text(context, widget.detail, mainTextSize, Colors.grey,
                  align: TextAlign.justify),
            ),
//remaining tickets===========================================================
            ListTile(
              title: text(context, 'Remaining tickets', mainTextSize + 6,
                  Colors.grey[900]!,
                  align: TextAlign.justify, fontWeight: FontWeight.bold),
              subtitle: text(
                  context, '$remindTicket', mainTextSize, Colors.grey,
                  align: TextAlign.justify),
            ),
//remaining tickets===========================================================
            ListTile(
              title: Padding(
                  padding: EdgeInsets.only(bottom: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      text(context, 'tickets number', mainTextSize + 6,
                          Colors.grey[900]!,
                          align: TextAlign.justify,
                          fontWeight: FontWeight.bold),
                      text(context, '$totalPrice RS', mainTextSize + 6,
                          Colors.grey[900]!,
                          align: TextAlign.justify,
                          fontWeight: FontWeight.bold),
                    ],
                  )),
              subtitle: CounterButton(
                loading: false,
                onChange: (int val) {
                  setState(() {
                    total = val;
                    if(total > 0 &&total <= remindTicket!){
                     totalPrice=total*widget.price;
                    }
                  });
                },
                count: total,
                countColor: black,
                buttonColor: green,
                progressColor: green,
                addIcon: const Icon(Icons.add_circle_outline),
                removeIcon: const Icon(Icons.remove_circle_outline),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
//buy===========================================================
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15.w,
              ),
              child: bottom(context, 'BUY', textColor, () {
                if (total <= 0) {
                  lode(context, '', 'You must select at least 1');
                } else if (total > remindTicket!) {
                  lode(context, '', 'The quantity is not enough');
                } else {
                  print('done');
                }
              }, backgroundColor: iconColor),
            )
          ],
        ));
  }
}
