// ignore_for_file: file_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import '../Colors/Colors.dart';
import '../Data/Firebase.dart';
import '../Funcations/Funcation.dart';
import '../Messag/Messages.dart';
import 'package:path/path.dart' as path;

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
  TextEditingController price = TextEditingController();
  TextEditingController details = TextEditingController();
  GlobalKey<FormState> addKey = GlobalKey();
  Reference? fileRef;
  String? fileURL;
  File? file;
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
                          top: 120.h,
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
                                  child: Form(
                                    key: addKey,
                                    child: ListView(
                                      // crossAxisAlignment:
                                      //     CrossAxisAlignment.center,
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                        ),
                                        //============================== name textField===============================================================
                                        textField(
                                          context,
                                          Icons.event,
                                          "Event name",
                                          false,
                                          nameController,
                                          manditary,
                                        ),
                                        SizedBox(height: 10.h),
                                        //============================== City textField===============================================================
                                        textField(
                                          context,
                                          Icons.location_city_rounded,
                                          "City name",
                                          false,
                                          cityController,
                                          manditary,
                                        ),
                                        SizedBox(height: 10.h),
                                        //============================== Location textField===============================================================
                                        textField(
                                          context,
                                          Icons.location_on_rounded,
                                          "Location",
                                          false,
                                          locationController,
                                          manditary,
                                        ),
                                        //============================== Tickets textField===============================================================
                                        SizedBox(height: 10.h),
                                        textField(
                                            context,
                                            Icons.newspaper,
                                            "Tickets number",
                                            false,
                                            ticketNumbrtController,
                                            manditary,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ]),
                                        SizedBox(height: 10.h),
                                        //============================== price textField===============================================================
                                        textField(
                                            context,
                                            Icons.money,
                                            "Price",
                                            false,
                                            price,
                                            manditary,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ]),
                                        SizedBox(height: 10.h),
                                        //============================== Start date textField===============================================================

                                        textField(
                                          context,
                                          Icons.date_range,
                                          "Start date",
                                          false,
                                          stDateController,
                                          manditary,
                                          onTap: () {
                                            onTapDate(stDateController);
                                          },
                                        ),
                                        //============================== End date textField===============================================================
                                        SizedBox(height: 10.h),
                                        textField(
                                          context,
                                          Icons.date_range,
                                          "End date",
                                          false,
                                          enDateController,
                                          (value) {},
                                          onTap: () {
                                            onTapDate(enDateController);
                                          },
                                        ),
                                        SizedBox(height: 10.h),
                                        //======================================================================================
                                        textField(
                                            context,
                                            Icons.details,
                                            "Details",
                                            false,
                                            details,
                                            manditary,
                                            max: 4,
                                            minlime: 4
                                            ),
                                        SizedBox(height: 10.h),
                                        //============================== add bottom==============================================================

                                        const Spacer(),
                                        Container(
                                          width: double.infinity,
                                          height: 60.h,
                                          decoration: BoxDecoration(
                                              color: iconColor,
                                              //Colors.grey[700]!,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.r))),
                                          margin: EdgeInsets.only(top: 10.h),
                                          padding: EdgeInsets.all(15.w),
                                          child: InkWell(
                                            onTap: () async {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              if (addKey.currentState
                                                      ?.validate() ==
                                                  true) {
                                                if (file == null) {
                                                  lode(context, addData,
                                                      'Select Image');

                                                } else {
                                                  lode(context, '', 'lode');
                                                  fileRef = FirebaseStorage
                                                      .instance
                                                      .ref('tickets')
                                                      .child(path.basename(
                                                          file!.path));

                                                  await fileRef
                                                      ?.putFile(file!)
                                                      .then((getValue) async {
                                                    fileURL = await fileRef!
                                                        .getDownloadURL();
                                                    Firbase.addEvent(
                                                            price: int.parse(
                                                                price.text),
                                                            details:
                                                                details.text,
                                                            totalTicket: int.parse(
                                                                ticketNumbrtController
                                                                    .text),
                                                            name: nameController
                                                                .text,
                                                            city: cityController
                                                                .text,
                                                            link: fileURL!,
                                                            fileName:
                                                                path.basename(
                                                                    file!.path),
                                                            location:
                                                                locationController
                                                                    .text,
                                                            startDate:
                                                                stDateController
                                                                    .text,
                                                            endDate:
                                                                enDateController
                                                                    .text)
                                                        .then((v) {
                                                      print(
                                                          '================$v');
                                                      if (v == 'done') {
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                        lode(context, addData,
                                                            doneData);
                                                      } else {
                                                        Navigator.pop(context);
                                                        lode(context, addData,
                                                            errorDat);
                                                      }
                                                    });
                                                  });
                                                }
                                              }
                                            },
                                            child: text(context, 'Add Event',
                                                mainTextSize, white,
                                                align: TextAlign.center),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                        ),
//image==========================================================================================
                        Positioned(
                          top: 10.h,
                          bottom: MediaQuery.of(context).size.height /1.8 ,
                          left: 10.w,
                          right: 10.w,
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: InkWell(
                                onTap: () {
                                  getFile(context);
                                },
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
                                      child: file == null
                                          ? const Icon(Icons.image)
                                          : Image.file(
                                              file!,
                                              fit: BoxFit.cover,
                                            ),
                                    )),
                              )),
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

//show date picker======================================
  void onTapDate(TextEditingController date) async {
    FocusScope.of(context).unfocus();
    DateTime? datePicker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(20100));
    setState(() {
      if (datePicker != null) {
        date.text = '${datePicker.day}-${datePicker.month}-${datePicker.year}';
        '${datePicker.weekday}';
      }
    });
  }

  //show file picker=========================================
  Future getFile(context) async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );
    if (pickedFile == null) {
      return null;
    }
    setState(() {
      file = File(pickedFile.paths.first!);
    });
  }
}
