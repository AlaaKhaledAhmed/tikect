
import 'package:flutter/material.dart';
import 'package:tikect/Admin/ViewUser.dart';


class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      //استدعينا الفيو يوزر
      body:ViewUser(),

    );
  }
}
