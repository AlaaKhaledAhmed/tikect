
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//حق الحقول لو انا بضيف الحقول في الداتا بيز
//انشات كلاس الفير بيز فيها كل الميثود الي هنستخدمها في الداتا
//١-اضافه حساب ٢- اضافه مستخدم ٣-عمليه لوق ان ٤-عرض الايفنتات حذف الايفنت ٥-تعديل ايفنت
class Firbase {

  //=======================Sing up method======================================
  //اول فانكشن "انشاء حساب " خاص بصفحه الكريت
  static Future<String> singUpAccount({
    required String name,
    required String email,
    required String password,
    required String idNumber,
    required String type,
  }) async {
    try {
      //add user information
      //ميثود جاهزه اعطيها الايميل والباسورد وتعطيني uid
      //اول مكتبه "firabaseauth "متخصصه اني اعطيها ايميل واعطيها باسورد وهيا تضيفها لي بلجدول وتعطيها uid
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password);
      //اتاكد العمليه تمت ولا ما تمت
      if (userCredential.user != null) {
        //اذا انضاف ف انا محتاجه اضيف بقيه المعلومات في الكلاود
        //امر ابدا ضيف لي في الداتا بيز
        //انشي لي جدول اسمه يوزر اضف فيه الحقول الاتيه وهذي الحقول انتبه للاسبلنق ولانه بضيفها في كل مكان
        await FirebaseFirestore.instance.collection('users').add({
          'name': name,
          'userId': userCredential.user?.uid,
          'password': password,
          'email': email,
          'type': type,
          'idNumber': idNumber

        });
        return 'done';
      }
    } on FirebaseException catch (e) {

      if (e.code == 'weak-password') {
        return 'weak-password';
      }
      if (e.code == 'email-already-in-use') {
        return 'email-already-in-use';
      }
    } catch (e) {
      return e.toString();
    }
    return 'error';
  }

  //=======================Log in method======================================

  static Future<String> loggingToApp(
      {required String email, required String password}) async {
    try {
      //add user information
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.trim(), password: password);
      if (userCredential.user != null) {
        return '${userCredential.user?.uid}';
        //
      }
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        return 'user-not-found';

      }
      if (e.code == 'wrong-password') {
        return 'user-not-found';

      }
    } catch (e) {
      return 'error';
    }
    return 'error';

  }

//===================================================================
  //اذا نسيت الباسورد

  static Future<String> resetPassword({required String email}) async {
    try {

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      return 'done';
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        return 'user-not-found';

      }
    } catch (e) {
      return 'error';
    }
    return 'error';

  }
  //=======================Update user method======================================

  static Future<String> updateUser({
    required String name,
    required String idNumber,
    required String type,
    required String docId,

  }) async {
    try {

      await FirebaseFirestore.instance
          .collection('users')
          .doc(docId)

          .update({'name': name, 'type': type, 'idNumber': idNumber});

      return 'done';
    } catch (e) {
      return 'error';
    }
  }
  //=======================Delete  method======================================

  static Future<String> delete({
    required String docId,
    required String collection,

  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(docId)
          .delete();
      //دليت
      return 'done';
    } catch (e) {
      return 'error';
    }
  }

}
