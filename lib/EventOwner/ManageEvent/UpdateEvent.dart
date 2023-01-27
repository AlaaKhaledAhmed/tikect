import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import'package:tikect/Data/Firebase.dart';
import '../../Colors/Colors.dart';
import '../../Funcations/Funcation.dart';
import '../../Messag/Messages.dart';
import 'package:path/path.dart' as path;

class UpdateEvent extends StatefulWidget {
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
  const UpdateEvent(
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
      required this.fileName})
      : super(key: key);

  @override
  State<UpdateEvent> createState() => _UpdateEventState();
}

class _UpdateEventState extends State<UpdateEvent> {
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
  void initState() {
    super.initState();
    nameController.text = widget.name;
    cityController.text = widget.city;
    locationController.text = widget.location;
    ticketNumbrtController.text = widget.ticketNumbrt.toString();
    stDateController.text = widget.stDate;
    enDateController.text = widget.endData;
    price.text = widget.price.toString();
    details.text = widget.detail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: text(context, 'Update Event', mainTextSize, white),
          backgroundColor: iconColor,
          centerTitle: true,
        ),
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
                    child: Form(
                      key: addKey,
                      child: Column(children: [
                        SizedBox(
                            height: 200.h,
                                width: double.infinity,
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0.r)),
                                    child: file == null
                                        ? Image.network(
                                            widget.link,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            file!,
                                            fit: BoxFit.cover,
                                          ),
                                  )),
                            )),
                      SizedBox(height: 10.h),
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
                        textField(context, Icons.newspaper, "Tickets number",
                            false, ticketNumbrtController, manditary,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ]),
                        SizedBox(height: 10.h),
                    //============================== price textField===============================================================
                        textField(context, Icons.money, "Price", false, price,
                            manditary, inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
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
                        textField(context, Icons.details, "Details", false,
                            details, manditary,
                            max: 4, minlime: 4),
                        SizedBox(height: 10.h),
//============================== add bottom==============================================================
                    
                        const Spacer(),
                        Container(
                          width: double.infinity,
                          height: 50.h,
                          decoration: BoxDecoration(
                              color: iconColor,
                              //Colors.grey[700]!,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r))),
                          margin: EdgeInsets.only(top: 10.h),
                          padding: EdgeInsets.all(15.w),
                          child: InkWell(
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (addKey.currentState?.validate() == true) {
                                if (file == null) {
                                  Firbase.updateEvent(
                                          price: int.parse(price.text),
                                          details: details.text,
                                          totalTicket: int.parse(
                                              ticketNumbrtController.text),
                                          name: nameController.text,
                                          city: cityController.text,
                                          link: widget.link,
                                          fileName: widget.fileName,
                                          location: locationController.text,
                                          startDate: stDateController.text,
                                          endDate: enDateController.text,
                                          docId: widget.docId)
                                      .then((v) {
                                    print('================$v');
                                    if (v == 'done') {
                                      Navigator.pop(context);
                                      // Navigator.pop(context);
                                      lode(context, updateData, doneData);
                                    } else {
                                      Navigator.pop(context);
                                      lode(context, updateData, errorDat);
                                    }
                                  });
                                  //================================================================================================
                                } else {
                                  lode(context, '', 'lode');
                                  fileRef = FirebaseStorage.instance
                                      .ref('tickets')
                                      .child(path.basename(file!.path));
                                     
                                  await fileRef
                                      ?.putFile(file!)
                                      .then((getValue) async {
                                        
                                    fileURL = await fileRef?.getDownloadURL();
                                     print('await fileRef: ${ fileURL}');
                                    Firbase.updateEvent(
                                            price: int.parse(price.text),
                                            details: details.text,
                                            totalTicket: int.parse(
                                                ticketNumbrtController.text),
                                            name: nameController.text,
                                            city: cityController.text,
                                            link: "$fileURL!",
                                            fileName: path.basename(file!.path),
                                            location: locationController.text,
                                            startDate: stDateController.text,
                                            endDate: enDateController.text,
                                           docId: widget.docId)
                                        .then((v) {
                                      print('================$v');
                                      if (v == 'done') {
                                         Navigator.pop(context);
                                         Navigator.pop(context);
                                        lode(context, updateData, doneData);
                                      } else {
                                        Navigator.pop(context);
                                        lode(context, updateData, errorDat);
                                      }
                                    });
                                  });
                                }
                              }
                            },
                            child: text(
                                context, 'Update Event', mainTextSize, white,
                                align: TextAlign.center),
                          ),
                        ),
                      ]),
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
