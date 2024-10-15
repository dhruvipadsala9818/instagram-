// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// class AddPostController extends GetxController {
//   final Rx<XFile?> image = Rx<XFile?>(null);
//   final RxBool isUploading = false.obs;
//
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<void> pickImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? selectedImage =
//         await picker.pickImage(source: ImageSource.gallery);
//     image.value = selectedImage;
//   }
//
//   Future<void> uploadImage() async {
//     if (image.value == null) return;
//
//     isUploading.value = true;
//
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         throw 'User not authenticated';
//       }
//
//       DocumentSnapshot snapshot =
//           await _firestore.collection('InstaUser').doc(user.uid).get();
//       if (!snapshot.exists) {
//         throw 'User profile not found';
//       }
//
//       String username = snapshot['username'];
//       String userProfileImageUrl = snapshot['imageUrl'];
//
//       String filePath = 'images/${DateTime.now().millisecondsSinceEpoch}.png';
//       Reference ref = _storage.ref().child(filePath);
//
//       await ref.putFile(File(image.value!.path));
//       String downloadUrl = await ref.getDownloadURL();
//
//       await _firestore.collection('posts').add({
//         'imageUrl': downloadUrl,
//         'uid': user.uid,
//         'username': username,
//         'userProfileImageUrl': userProfileImageUrl,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//
//       Fluttertoast.showToast(
//         msg: "Post added successfully!",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.black,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//
//       image.value = null;
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: "Error uploading image: $e",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.black,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//     } finally {
//       isUploading.value = false;
//     }
//   }
// }
// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// class AddPostController extends GetxController {
//   final Rx<XFile?> image = Rx<XFile?>(null);
//   final RxBool isUploading = false.obs;
//
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<void> pickImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? selectedImage =
//         await picker.pickImage(source: ImageSource.gallery);
//     image.value = selectedImage;
//   }
//
//   Future<void> uploadImage() async {
//     if (image.value == null) {
//       Fluttertoast.showToast(
//         msg: "Please select an image",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//       return;
//     }
//
//     isUploading.value = true;
//
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         throw 'User not authenticated';
//       }
//
//       DocumentSnapshot snapshot =
//           await _firestore.collection('InstaUser').doc(user.uid).get();
//
//       String username = snapshot.exists && snapshot.data() != null
//           ? (snapshot.data() as Map<String, dynamic>)['username'] ??
//               'Unknown User'
//           : 'Unknown User';
//
//       String userProfileImageUrl = snapshot.exists && snapshot.data() != null
//           ? (snapshot.data() as Map<String, dynamic>)['imageUrl'] ?? ''
//           : '';
//
//       String filePath = 'images/${DateTime.now().millisecondsSinceEpoch}.png';
//       Reference ref = _storage.ref().child(filePath);
//
//       await ref.putFile(File(image.value!.path));
//       String downloadUrl = await ref.getDownloadURL();
//
//       await _firestore.collection('posts').add({
//         'imageUrl': downloadUrl,
//         'uid': user.uid,
//         'username': username,
//         'userProfileImageUrl': userProfileImageUrl,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//
//       Fluttertoast.showToast(
//         msg: "Post added successfully!",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.black,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//
//       image.value = null;
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: "Error uploading image: $e",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.black,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//     } finally {
//       isUploading.value = false;
//     }
//   }
// }
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddPostController extends GetxController {
  final Rx<XFile?> image = Rx<XFile?>(null);
  final Rx<XFile?> video = Rx<XFile?>(null);
  final RxBool isUploading = false.obs;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedImage =
        await picker.pickImage(source: ImageSource.gallery);
    image.value = selectedImage;
  }

  Future<void> pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedVideo =
        await picker.pickVideo(source: ImageSource.gallery);
    video.value = selectedVideo;
  }

  Future<void> uploadImage() async {
    if (image.value == null) {
      Fluttertoast.showToast(
        msg: "Please select an image",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    isUploading.value = true;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw 'User not authenticated';
      }

      DocumentSnapshot snapshot =
          await _firestore.collection('InstaUser').doc(user.uid).get();

      String username = snapshot.exists && snapshot.data() != null
          ? (snapshot.data() as Map<String, dynamic>)['username'] ??
              'Unknown User'
          : 'Unknown User';

      String userProfileImageUrl = snapshot.exists && snapshot.data() != null
          ? (snapshot.data() as Map<String, dynamic>)['imageUrl'] ?? ''
          : '';

      String filePath = 'images/${DateTime.now().millisecondsSinceEpoch}.png';
      Reference ref = _storage.ref().child(filePath);

      await ref.putFile(File(image.value!.path));
      String downloadUrl = await ref.getDownloadURL();

      await _firestore.collection('posts').add({
        'imageUrl': downloadUrl,
        'uid': user.uid,
        'username': username,
        'userProfileImageUrl': userProfileImageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Fluttertoast.showToast(
        msg: "Post added successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      image.value = null;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error uploading image: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> uploadVideo() async {
    if (video.value == null) {
      Fluttertoast.showToast(
        msg: "Please select a video",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    isUploading.value = true;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw 'User not authenticated';
      }

      DocumentSnapshot snapshot =
          await _firestore.collection('InstaUser').doc(user.uid).get();

      String username = snapshot.exists && snapshot.data() != null
          ? (snapshot.data() as Map<String, dynamic>)['username'] ??
              'Unknown User'
          : 'Unknown User';

      String userProfileImageUrl = snapshot.exists && snapshot.data() != null
          ? (snapshot.data() as Map<String, dynamic>)['imageUrl'] ?? ''
          : '';

      String filePath = 'videos/${DateTime.now().millisecondsSinceEpoch}.mp4';
      Reference ref = _storage.ref().child(filePath);

      await ref.putFile(File(video.value!.path));
      String downloadUrl = await ref.getDownloadURL();

      await _firestore.collection('reels').add({
        'videoUrl': downloadUrl,
        'uid': user.uid,
        'username': username,
        'userProfileImageUrl': userProfileImageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Fluttertoast.showToast(
        msg: "Reel added successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      video.value = null;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error uploading video: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      isUploading.value = false;
    }
  }
}
