import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tm_app/app/routes/app_pages.dart';

class AuthController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential? _userCredential;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController searchFriendsController,
      titleController,
      descriptionController,
      dueDateController;

  @override
  void onInit() {
    super.onInit();
    searchFriendsController = TextEditingController();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    dueDateController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    searchFriendsController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
  }

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    print(googleUser!.email);
    // Once signed in, return the UserCredential
    await auth
        .signInWithCredential(credential)
        .then((value) => _userCredential = value);

    // firebase
    CollectionReference users = firestore.collection('users');

    final cekuser = await users.doc(googleUser.email).get();
    if (!cekuser.exists) {
      users.doc(googleUser.email).set({
        'uid': _userCredential!.user!.uid,
        'name': googleUser.displayName,
        'email': googleUser.email,
        'photo': googleUser.photoUrl,
        'creadAt': _userCredential!.user!.metadata.creationTime.toString(),
        'lastloginAt':
            _userCredential!.user!.metadata.lastSignInTime.toString(),
        // 'list_cari': [D,DA,DAF,DAFF,DAFFI],
      }).then((value) async {
        String temp = '';
        try {
          for (var i = 0; i < googleUser.displayName!.length; i++) {
            temp = temp + googleUser.displayName![i];
            await users.doc(googleUser.email).set({
              'list_cari': FieldValue.arrayUnion([temp.toUpperCase()])
            }, SetOptions(merge: true));
          }
        } catch (e) {
          print(e);
        }
      });
    } else {
      users.doc(googleUser.email).update({
        'lastloginAt':
            _userCredential!.user!.metadata.lastSignInTime.toString(),
      });
    }
    Get.offAllNamed(Routes.HOME);
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  var kataCari = [].obs;
  var hasilPencarian = [].obs;
  void searchFriends(String keyword) async {
    CollectionReference users = firestore.collection('users');

    if (keyword.isNotEmpty) {
      final hasilQuary = await users
          .where('list_cari', arrayContains: keyword.toUpperCase())
          .get();
      if (hasilQuary.docs.isNotEmpty) {
        for (var i = 0; i < hasilQuary.docs.length; i++) {
          kataCari.add(hasilQuary.docs[i].data() as Map<String, dynamic>);
        }
      }

      if (kataCari.isNotEmpty) {
        hasilPencarian.value = [];
        kataCari.forEach((element) {
          print(element);
          hasilPencarian.add(element);
        });
        kataCari.clear();
      }
    } else {
      kataCari.value = [];
      hasilPencarian.value = [];
    }
    kataCari.refresh();
    hasilPencarian.refresh();
  }

  void addFriends(String _emailFriends) async {
    CollectionReference friends = firestore.collection('friends');

    final cekFriends = await friends.doc(auth.currentUser!.email).get();
    //cek terdapat data atau tidak
    if (cekFriends.data() == null) {
      await friends.doc(auth.currentUser!.email).set({
        'emailMe': auth.currentUser!.email,
        'emailFriends': [_emailFriends],
      }).whenComplete(() => Get.snackbar("Friends", "Friends sucsessfuly add"));
    } else {
      await friends.doc(auth.currentUser!.email).set({
        'emailFriends': FieldValue.arrayUnion([_emailFriends]),
      }, SetOptions(merge: true)).whenComplete(
          () => Get.snackbar("Friends", "Friends sucsessfuly add"));
    }
    kataCari.clear();
    hasilPencarian.clear();
    searchFriendsController.clear();
    Get.back();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamFriends() {
    return firestore
        .collection('friends')
        .doc(auth.currentUser!.email)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUsers(String email) {
    return firestore.collection('users').doc(email).snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPeople() async {
    CollectionReference friendsCollec = firestore.collection('friends');

    final cekFriends = await friendsCollec.doc(auth.currentUser!.email).get();
    var listFriends =
        (cekFriends.data() as Map<String, dynamic>)['emailFriends'] as List;
    var hasil = await firestore
        .collection('users')
        .where('email', whereNotIn: listFriends)
        .get();
    return hasil;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamTask(String taskId) {
    return firestore.collection('task').doc(taskId).snapshots();
  }

  Future<void> saveUpdateTask(
      {String? titel,
      String? description,
      String? dueDate,
      String? docId,
      String? type}) async {
    print(titel);
    print(description);
    print(dueDate);
    print(docId);
    print(type);
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();
    CollectionReference taskColl = firestore.collection('task');
    CollectionReference usersColl = firestore.collection('users');
    var taskId = DateTime.now().toIso8601String();
    if (type == 'Add') {
      await taskColl.doc(taskId).set({
        'title': titel,
        'description': description,
        'dueDate': dueDate,
        'status': '0',
        'total_task': '0',
        'total_task_finished': '0',
        'task_detail': [],
        'asign_to': [auth.currentUser!.email],
        'created_by': auth.currentUser!.email,
      }).whenComplete(() async {
        await usersColl.doc(auth.currentUser!.email).set({
          'task_id': FieldValue.arrayUnion([taskId])
        }, SetOptions(merge: true));
        Get.back();
        Get.snackbar('Task', 'Successfully ${type}ed');
      }).catchError((error) {
        Get.snackbar('Task', 'Failed to $type');
      });
    } else {
      await taskColl.doc(docId).update({
        'title': titel,
        'description': description,
        'dueDate': dueDate,
      }).whenComplete(() async {
        // await usersColl.doc(auth.currentUser!.email).set({
        //   'task_id': FieldValue.arrayUnion([taskId])
        // }, SetOptions(merge: true));
        Get.back();
        Get.snackbar('Task', 'Successfully ${type}ed');
      }).catchError((error) {
        Get.snackbar('Task', 'Failed to $type');
      });
    }
  }

  void deleteTask(String taskId) async {
    CollectionReference taskColl = firestore.collection('task');
    CollectionReference usersColl = firestore.collection('users');

    await taskColl.doc(taskId).delete().whenComplete(() async {
      await usersColl.doc(auth.currentUser!.email).set({
        'task_id': FieldValue.arrayRemove([taskId])
      }, SetOptions(merge: true));
    });
    Get.back();
    Get.snackbar('Task', 'Successfully deleted');
  }
}
