// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Colors/Colors.dart';
import '../Funcations/Funcation.dart';
import '../Messag/Messages.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);
  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController ticketNumbrtController = TextEditingController();
  TextEditingController stDateController = TextEditingController();
  TextEditingController enDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        body: LayoutBuilder(builder: (context, constraints) {
          return NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification? overscroll) {
              overscroll!.disallowGlow();
              return true;
            },
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                    minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: Stack(
                      // alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: [
//event details==========================================================================================
                        Positioned(
                          top: 60.h,
                          bottom: 10.h,
                          left: -3,
                          right: -3,
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                color: white,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(
                                      15.0.r), //<-- SEE HERE
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10.0.w),
                                  child: ListView(
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.center,
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4,
                                      ),
//============================== name textField===============================================================
                                      textField(
                                        context,
                                        Icons.event,
                                        "Event name",
                                        false,
                                        nameController,
                                        (V) {},
                                      ),
                                      SizedBox(height: 10.h),
//============================== City textField===============================================================
                                      textField(
                                        context,
                                        Icons.location_city_rounded,
                                        "City name",
                                        false,
                                       cityController,
                                        (V) {},
                                      ),
                                      SizedBox(height: 10.h),
//============================== Location textField===============================================================
                                      textField(
                                        context,
                                        Icons.location_on_rounded,
                                        "Location",
                                        false,
                                        locationController,
                                        (V) {},
                                      ),
//============================== Tickets textField===============================================================
                                      SizedBox(height: 10.h),
                                      textField(
                                        context,
                                        Icons.newspaper,
                                        "Tickets number",
                                        false,
                                       ticketNumbrtController,
                                        (V) {},
                                      ),
                                      SizedBox(height: 10.h),
//============================== Start date textField===============================================================
                                      textField(
                                        context,
                                        Icons.date_range,
                                        "Start date",
                                        false,
                                        stDateController,
                                        (V) {},
                                      ),

//============================== End date textField===============================================================
                                      SizedBox(height: 10.h),
                                      textField(
                                        context,
                                        Icons.date_range,
                                        "End date",
                                        false,
                                        enDateController,
                                        (V) {},
                                      ),
                                      SizedBox(height: 10.h),
//======================================================================================
                                    
                                      const Spacer(),
                                      Container(
                                        width: double.infinity,
                                        height: 45.h,
                                        decoration: BoxDecoration(
                                            color: iconColor,
                                            //Colors.grey[700]!,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.r))),
                                        margin: EdgeInsets.only(top: 10.h),
                                        padding: EdgeInsets.all(15.w),
                                        child: text(context, 'Add Event',
                                            mainTextSize, white,
                                            align: TextAlign.center),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ),
                        //image==========================================================================================
                        Positioned(
                          top: 10.h,
                          bottom: MediaQuery.of(context).size.height / 1.5,
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
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5.0.r)),
                                    child: Image.network(
                                      'https://firebasestorage.googleapis.com/v0/b/tekict-event.appspot.com/o/pexels-salah-alawadhi-382297.jpg?alt=media&token=f61efe2d-7b64-4480-931c-230b52c5c732',
                                      fit: BoxFit.cover,
                                    ),
                                  ))),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }));
  }
}
