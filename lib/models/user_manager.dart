import 'package:app_loja_virtual/helpers/firebase_errors.dart';
import 'package:app_loja_virtual/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserManager extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  UserManager() {
    _loadCurrentUser();
  }

  //FirebaseUser user;
  UserModel user;

  bool _loading = false;
  bool get loading => _loading;
  bool get isLoggedIn => user != null;

  Future<void> signIn(
      {UserModel user, Function onFail, Function onSuccess}) async {
    //setLoading(value: true);
    loading = true;
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);

      //await Future.delayed(Duration(seconds: 4));
      await _loadCurrentUser(firebaseUser: result.user);
      //this.user = result.user;
      debugPrint(result.user.uid);
      onSuccess();
    } on PlatformException catch (e, ex) {
      debugPrint(e.code);
      debugPrint("$e >>> $ex");
      onFail(getErrorString(e.code));
    } on FirebaseAuthException catch (e, ex) {
      debugPrint(e.code);
      debugPrint("$e >>> $ex");
      onFail(getNewAPIErrorString(e.code.trim().toLowerCase()));
    } catch (e, ex) {
      debugPrint("$e >>> $ex");
    }
    //setLoading(value: false);
    loading = false;
  }

  Future<void> _loadCurrentUser({User firebaseUser}) async {
    final User currentUser = firebaseUser ?? auth.currentUser;
    if (currentUser != null) {
      //user = currentUser;
      //print(user.uid);
      final DocumentSnapshot docUser =
          await firestore.collection('users').doc(currentUser.uid).get();
      user = UserModel.fromDocument(docUser);

      final docAdmin =
          await firestore.collection('admins').doc(docUser.id).get();

      if (docAdmin.exists) {
        user.admin = true;
      } else {
        user.admin = false;
      }

      debugPrint(user.toString());

      notifyListeners();
    }
  }

  Future<void> signUp(
      {UserModel user, Function onFail, Function onSuccess}) async {
    //setLoading(value: true);
    loading = true;
    try {
      final UserCredential result = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      //await Future.delayed(Duration(seconds: 4));

      //this.user = result.user;
      user.id = result.user.uid;
      this.user = user;
      await user.saveData();
      debugPrint(result.user.uid);
      onSuccess();
    } on PlatformException catch (e, ex) {
      debugPrint("$e >>> $ex");
      onFail(getErrorString(e.code));
    } catch (e, ex) {
      debugPrint("$e >>> $ex");
    }
    //setLoading(value: false);
    loading = false;
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setLoading({bool value}) {
    _loading = value;
    notifyListeners();
  }

  Future<void> signOut() async {
    auth.signOut();
    user = null;
    notifyListeners();
  }

  bool get adminEnabled => user != null && user.admin;
}
