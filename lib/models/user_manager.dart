import 'package:app_loja_virtual/helpers/firebase_errors.dart';
import 'package:app_loja_virtual/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

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

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setLoading({bool value}) {
    _loading = value;
    notifyListeners();
  }

  bool _loadingFace = false;
  bool get loadingFace => _loadingFace;

  set loadingFace(bool value) {
    _loadingFace = value;
    notifyListeners();
  }

  void setLoadingFace({bool value}) {
    _loadingFace = value;
    notifyListeners();
  }

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

      await user.saveToken();

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

      await user.saveToken();
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

  Future<void> signOut() async {
    auth.signOut();
    user = null;
    notifyListeners();
  }

  Future<void> facebookLogin({Function onFail, Function onSuccess}) async {
    loadingFace = true;
    final result = await FacebookLogin().logIn(['email', 'public_profile']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final credential =
            FacebookAuthProvider.credential(result.accessToken.token);

        final authResult = await auth.signInWithCredential(credential);

        if (authResult.user != null) {
          final firebaseUser = auth.currentUser;

          user = UserModel(
              id: firebaseUser.uid,
              name: firebaseUser.displayName,
              email: firebaseUser.email);

          await user.saveData();
          await user.saveToken();
        }
        onSuccess();
        break;
      case FacebookLoginStatus.cancelledByUser:
        debugPrint('User cancel login com facebook');
        break;
      case FacebookLoginStatus.error:
        onFail(result.errorMessage);
        break;
      default:
        break;
    }
    loadingFace = false;
  }

  bool get adminEnabled => user != null && user.admin;
}
