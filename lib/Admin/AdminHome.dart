
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Colors/Colors.dart';
import '../Data/Firebase.dart';
import '../Funcations/Funcation.dart';
import '../Icons/Icons.dart';
import '../Messag/Messages.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //وقفنا عند صفحه الادمن
      body: Center(child: text(context, "Admin Home",15 , black)),

    );
  }
}
