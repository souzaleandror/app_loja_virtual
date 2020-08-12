import 'package:app_loja_virtual/helpers/firebase_errors.dart';
import 'package:app_loja_virtual/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserManager extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore firestore = Firestore.instance;

  UserManager() {
    _loadCurrentUser();
  }

  //FirebaseUser user;
  User user;

  bool _loading = false;
  bool get loading => _loading;
  bool get isLoggedIn => user != null;

  Future<void> signIn({User user, Function onFail, Function onSuccess}) async {
    //setLoading(value: true);
    loading = true;
    try {
      final AuthResult result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);

      //await Future.delayed(Duration(seconds: 4));
      await _loadCurrentUser(firebaseUser: result.user);
      //this.user = result.user;
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

  Future<void> _loadCurrentUser({FirebaseUser firebaseUser}) async {
    FirebaseUser currentUser = firebaseUser ?? await auth.currentUser();
    if (currentUser != null) {
      //user = currentUser;
      //print(user.uid);
      final DocumentSnapshot docUser =
          await firestore.collection('users').document(currentUser.uid).get();
      user = User.fromDocument(docUser);
      notifyListeners();
    }
  }

  Future<void> signUp({User user, Function onFail, Function onSuccess}) async {
    //setLoading(value: true);
    loading = true;
    try {
      final AuthResult result = await auth.createUserWithEmailAndPassword(
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
}
