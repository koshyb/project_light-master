import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:projectlight/dev/Log.dart';

class FirebaseTools {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage(storageBucket: '');
  StorageUploadTask _uploadTask;
  String error = '';
  final log = Log().logger;

  /// Get JWT token of user
  Future<IdTokenResult> getToken() async {
    try {
      return await _auth.currentUser().then((user) {
        if (user != null) {
          return user.getIdToken();
        } else {
          return null;
        }
      });
    } catch (e) {
      log.e('Failed to get token $e');
      return null;
    }
  }

  void signOut() {
    try {
      _auth.signOut().then((result) {
        log.i('Success logout');
      });
    } catch (e) {
      log.e('Failed to sign out $e');
    }
  }

  void _authChanged() {
    try {
      _auth.onAuthStateChanged.listen((firebaseUser) {
        log.i('Found user $firebaseUser');
      });
    } catch (e) {
      log.e('Failed to get _auth $e');
    }
  }

  /// Register new user
  Future<String> register({String email, String password}) async {
    try {
      if (email == null &&
          password == null &&
          email.length == 0 &&
          password.length == 0) return null;
      return await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) {
        log.i('Result ${result.user.email}');
        sendVerificationEmail(user: result.user);
        return 'Success';
      });
    } catch (e) {
      log.e('Failed to create account $e');
      error = _typesOfErrors(e.code);
      return null;
    }
  }

  void deleteUser(FirebaseUser user) async {
    await user.delete().then((result) {
      log.i('succedd in delete');
    }).catchError((error) {
      log.e('Failed to delete user $error');
    });
  }

  Future<dynamic> resetPassword({String email}) async {
    try {
      if (email == null || email.length == 0) return null;
      return await _auth.sendPasswordResetEmail(email: email).then((result) {
        return 'Success';
      });
    } catch (e) {
      error = _typesOfErrors(e.code);
      return null;
    }
  }

  /// Google cloud login
  Future<dynamic> login({String email, String password}) async {
    try {
      if (email == null ||
          email.length == 0 ||
          password == null ||
          password.length == 0) return null;
      return await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((result) {
        return 'Success';
      });
    } catch (e) {
      log.e('Failed to login $e');
      error = _typesOfErrors(e.code);
      return null;
    }
  }

  Future<FirebaseUser> getCurrentUser() async {
    try {
      print(_auth.currentUser());
      return await _auth.currentUser().then((result) {
        log.i('Found current user $result');
        return result;
      });
    } catch (e) {
      log.e('Failed to get user $e');
      return null;
    }
  }

  Future<bool> sendVerificationEmail({FirebaseUser user}) async {
    try {
      return await user.sendEmailVerification().then((result) {
        log.i('Send verification to user ${user.email}');
        return true;
      });
    } catch (e) {
      log.e('Failed to send verify email $e');
      return false;
    }
  }

  /// To Google storage
  Future<String> uploadImages(String imgPath) async {
    try {
      /// Set file name
      var extension = path.extension(imgPath);
      final String fileName =
          '${DateTime.now()}-${Random().nextInt(10000).toString()}$extension';

      log.i('image to save $imgPath');
      final StorageReference storageRef = _storage.ref().child(fileName);
      final StorageUploadTask uploadTask = storageRef.putFile(
        File(imgPath),
        StorageMetadata(
          contentType: 'image' + '/' + '${extension.replaceAll('.', '')}',
        ),
      );

      final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
      final String url = (await downloadUrl.ref.getDownloadURL());
//      print('URL Is $url');
      if (url != null) {
        return url;
      } else {
        return '';
      }
    } catch (e) {
      log.e('Failed image upload $e');
      return '';
    }
  }

  String _typesOfErrors(String error) {
    switch (error) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
        return "Email address already used.";
        break;
      case "ERROR_INVALID_EMAIL":
        return "Your email address appears to be malformed.";
        break;
      case "ERROR_WRONG_PASSWORD":
        return "Incorrect password.";
        break;
      case "ERROR_USER_NOT_FOUND":
        return "No account found. Please register!";
        break;
      case "ERROR_USER_DISABLED":
        return "This email has been disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        return "Too many requests. Try again later.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        return "Signing in with Email and Password only.";
        break;
      default:
        return "An undefined error happened.";
    }
  }
}
