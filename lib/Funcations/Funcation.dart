import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';
import '../Colors/Colors.dart';
import '../Log/Logging.dart';
import '../Messag/Messages.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Widget bottom(context, String key, Color textColor, onPressed,
    {Color backgroundColor = Colors.transparent,
    double horizontal = 0.0,
    double vertical = 0.0,
    double height = 55,
    double width = double.infinity,
    fontWeight = FontWeight.normal,
    double evaluation = 0.0}) {
  return SizedBox(
    height: height.h,
    width: width,
    child: TextButton(
      onPressed: onPressed,
      child: text(context, key, bottomSize, textColor, fontWeight: fontWeight),
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(evaluation),
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        foregroundColor: MaterialStateProperty.all(textColor),
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
            horizontal: horizontal.w, vertical: vertical.h)),
      ),
    ),
  );
}

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Widget text(context, String key, double fontSize, Color color,
    {String? family,
    align = TextAlign.right,
    double space = 0,
    FontWeight fontWeight = FontWeight.normal,
    decoration = TextDecoration.none}) {
  return Text(
    key,
    textAlign: align,
    //softWrap: false,
    style: TextStyle(
      color: color,
      //overflow: TextOverflow.ellipsis,
      fontFamily: family,
      decoration: decoration,
      fontSize: fontSize.sp,
      letterSpacing: space.sp,
      fontWeight: fontWeight,
    ),
  );
}

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

goTo(context, pageName) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => pageName));
}

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

goToReplace(BuildContext context, pageName) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => pageName));
}

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

String? manditary(value) {
  if (value.isEmpty) {
    return "Empty Data";
  }
  return null;
}

String? notManditary(value) {
  return null;
}

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

String? emile(value) {
  if (value.trim().isEmpty) {
    return "Empty Data";
  }

  if (EmailValidator.validate(value.trim()) == false) {
    return "Invalid Email";
  }
  return null;
}

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

String? password(value) {
  if (value.trim().isEmpty) {
    return "Empty Data";
  }

  if (value.length < 6) {
    return "Week password";
  }
  return null;
}

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Widget textField(context, icons, String key, bool hintPass,
    TextEditingController myController, myValued,
    {Widget? suffixIcon,
    //bool logoColors = false,
    fillColor,
    void Function()? onTap,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    hintText}) {
  return TextFormField(
    obscureText: hintPass,
    validator: myValued,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    onTap: onTap,
    autofocus: false,
    inputFormatters: inputFormatters,
    keyboardType: keyboardType,
    controller: myController,
    style: TextStyle(
      color: white,
      fontSize: textFieldSize,
    ),
    decoration: InputDecoration(
        isDense: true,
        filled: true,
        suffixIcon: suffixIcon,
        hintStyle: TextStyle(
          color: white,
          fontSize: textFieldSize,
        ),
        fillColor: fillColor ?? textFieldColors,
        labelStyle: TextStyle(
          color: white,
          fontSize: textFieldSize,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(
            color: textFieldColors,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(
            color: textFieldColors,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(
            color: textFieldColors,
            width: 1.0,
          ),
        ),
        prefixIcon: Icon(icons, color: iconColor, size: 25.sp),
        labelText: key,
        hintText: hintText,
        errorStyle: TextStyle(color: Colors.red, fontSize: 13.0.sp),
        contentPadding: EdgeInsets.all(10.h)),
  );
}

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Widget menu(
    context,
    String inisValue,
    IconData prefixIcon,
    double fontSize,
    List<String> item,
    void Function(String?)? onChanged,
    String? Function(String?)? validator,
    {double width = double.infinity}) {
  return DropdownButtonFormField2<String>(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: validator,
    hint: text(context, inisValue, fontSize, white),
    items: item
        .map((type) => DropdownMenuItem(
              alignment: Alignment.center,
              value: type,
              child: text(context, type, fontSize, white),
            ))
        .toList(),
    decoration: InputDecoration(
        isDense: false,
        filled: true,
        prefixIcon: Icon(
          prefixIcon,
          color: iconColor,
        ),
        fillColor: textFieldColors,
        alignLabelWithHint: true,
        errorStyle: TextStyle(color: Colors.red, fontSize: 14.0.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(
            color: textFieldColors,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(
            color: textFieldColors,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(
            color: textFieldColors,
            width: 1.0,
          ),
        ),
        contentPadding: EdgeInsets.all(10.h)),
    onChanged: onChanged,
    dropdownMaxHeight: 140.h,
    dropdownWidth: 250.w,
    dropdownDecoration: BoxDecoration(
        color: iconColor, borderRadius: BorderRadius.all(Radius.circular(4.r))),
    iconDisabledColor: iconColor,
    iconEnabledColor: iconColor,
    scrollbarAlwaysShow: true,
  );
}

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

lode(context, String title, String content,
    {bool showButtom = false,
    void Function()? yesFunction,
    void Function()? noFunction}) {
  return showDialog(
      //barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          titlePadding: EdgeInsets.zero,
          elevation: 0,

          backgroundColor: content == "lode" ? Colors.transparent : white,

//tittle-------------------------------------------------------------------

          title: content != "lode"
              ? Container(
                  decoration: BoxDecoration(
                      color: iconColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.r),
                          topRight: Radius.circular(10.r))),
                  width: double.infinity,
                  height: 40.h,
                  child: Center(
                    child: text(context, title, subTextSize, white,
                        fontWeight: FontWeight.bold),
                  ),
                )
              : const SizedBox(),
//continent area-------------------------------------------------------------------

          content: content != "lode"
              ? SizedBox(
                  height: 100.h,
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
//continent tittle-------------------------------------------------------------------
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: text(context, content, subTextSize, black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

//divider-------------------------------------------------------------------

                      showButtom
                          ? Divider(
                              thickness: 2,
                              color: iconColor,
                            )
                          : const SizedBox(),
                      SizedBox(height: 10.h),
//bottoms-------------------------------------------------------------------

                      showButtom
                          ? Expanded(
                              flex: 2,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
// yes bottoms-------------------------------------------------------------------
                                    Expanded(
                                        child: bottom(
                                      context,
                                      "yes",
                                      white,
                                      yesFunction,
                                      backgroundColor: red!,
                                    )),

                                    SizedBox(width: 20.w),
//no buttom-------------------------------------------------------------------
                                    Expanded(
                                      child: bottom(
                                        context,
                                        "no",
                                        white,
                                        noFunction,
                                        backgroundColor: red!,
                                      ),
                                    )
                                  ]),
                            )
                          : const SizedBox(),
                    ],
                  ))
//Show Waiting image-------------------------------------------------------
              : SizedBox(
                  width: double.infinity,
                  height: 150.h,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Lottie.asset(
                      "assets/lottie/wait2.json",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

//Show bottoms -------------------------------------------------------

          actions: [
            showButtom == false && content != "lode"
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon:
                              Icon(Icons.clear, color: iconColor, size: 35.sp)),
                    ),
                  )
                : const SizedBox()
          ],
        );
      });
}

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
appBar(context, String pageName, {icon, onPress, icon2, onPress2}) {
  return AppBar(
    title: text(context, pageName, mainTextSize, textColor),
    centerTitle: true,
    actions: [
      IconButton(
          color: textColor2,
          onPressed: () {
            FirebaseAuth.instance.signOut();
            goToReplace(context, LogIn());
          },
          icon: icon2 == null
              ? const Icon(Icons.logout_rounded)
              : IconButton(onPressed: onPress2, icon: Icon(icon2,)))
    ],
    backgroundColor: iconColor,
    elevation: 0,
    leading: icon != null
        ? IconButton(color: textColor2, onPressed: onPress, icon: Icon(icon))
        : null,
  );
}

appBar2(context, String pageName, action) {
  return AppBar(
    title: text(context, pageName, mainTextSize, textColor),
    centerTitle: true,
    actions: action,
    backgroundColor: iconColor,
    elevation: 0,
  );
}
