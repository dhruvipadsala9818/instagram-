// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class EditProfileController extends GetxController {
//   var isSwitched = false.obs;
//   var image = Rx<File?>(null);
//   var profileImageUrl = ''.obs;
//
//   final usernameController = TextEditingController();
//   final emailController = TextEditingController();
//   final pronounsController = TextEditingController();
//   final bioController = TextEditingController();
//
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchProfileData();
//   }
//
//   Future<void> fetchProfileData() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentSnapshot userDoc =
//           await _firestore.collection('InstaUser').doc(user.uid).get();
//       if (userDoc.exists) {
//         profileImageUrl.value = userDoc.get('imageUrl') ?? '';
//         usernameController.text = userDoc.get('username') ?? '';
//         emailController.text = userDoc.get('email') ?? '';
//         pronounsController.text = userDoc.get('pronouns') ?? '';
//         bioController.text = userDoc.get('bio') ?? '';
//       }
//     }
//   }
//
//   Future<void> pickImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? pickedFile = await Get.defaultDialog<XFile?>(
//       title: 'Choose Image Source',
//       content: Column(
//         children: [
//           TextButton(
//             onPressed: () async {
//               Get.back(
//                   result: await picker.pickImage(source: ImageSource.camera));
//             },
//             child: const Text('Camera'),
//           ),
//           TextButton(
//             onPressed: () async {
//               Get.back(
//                   result: await picker.pickImage(source: ImageSource.gallery));
//             },
//             child: const Text('Gallery'),
//           ),
//         ],
//       ),
//     );
//
//     if (pickedFile != null) {
//       image.value = File(pickedFile.path);
//       await uploadImageToFirebase();
//     }
//   }
//
//   Future<void> uploadImageToFirebase() async {
//     if (image.value == null) return;
//
//     try {
//       String fileName = image.value!.path.split('/').last;
//       Reference reference = _storage.ref().child("profile_images/$fileName");
//
//       await reference.putFile(image.value!);
//       String imageUrl = await reference.getDownloadURL();
//       await saveImageUrlToFirestore(imageUrl);
//     } catch (e) {
//       Get.snackbar('Error', 'Error uploading image: $e');
//     }
//   }
//
//   Future<void> saveImageUrlToFirestore(String imageUrl) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       await _firestore.collection('InstaUser').doc(user.uid).set(
//         {'imageUrl': imageUrl},
//         SetOptions(merge: true),
//       );
//       profileImageUrl.value = imageUrl;
//     }
//   }
//
//   Future<void> saveProfile() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       await _firestore.collection('InstaUser').doc(user.uid).set({
//         'username': usernameController.text,
//         'email': emailController.text,
//         'pronouns': pronounsController.text,
//         'bio': bioController.text,
//       }, SetOptions(merge: true));
//       Get.back();
//     }
//   }
//
//   void toggleSwitch(bool value) {
//     isSwitched.value = value;
//   }
// }
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileController extends GetxController {
  var isSwitched = false.obs;
  var image = Rx<File?>(null);
  var profileImageUrl = ''.obs;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final pronounsController = TextEditingController();
  final bioController = TextEditingController();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('InstaUser').doc(user.uid).get();
      if (userDoc.exists) {
        profileImageUrl.value = userDoc.get('imageUrl') ?? '';
        usernameController.text = userDoc.get('username') ?? '';
        emailController.text = userDoc.get('email') ?? '';
        pronounsController.text = userDoc.get('pronouns') ?? '';
        bioController.text = userDoc.get('bio') ?? '';
      }
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await Get.defaultDialog<XFile?>(
      title: 'Choose Image Source',
      content: Column(
        children: [
          TextButton(
            onPressed: () async {
              Get.back(
                  result: await picker.pickImage(source: ImageSource.camera));
            },
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () async {
              Get.back(
                  result: await picker.pickImage(source: ImageSource.gallery));
            },
            child: const Text('Gallery'),
          ),
        ],
      ),
    );

    if (pickedFile != null) {
      image.value = File(pickedFile.path);
      await uploadImageToFirebase();
    }
  }

  Future<void> uploadImageToFirebase() async {
    if (image.value == null) return;

    try {
      String fileName = image.value!.path.split('/').last;
      Reference reference = _storage.ref().child("profile_images/$fileName");

      await reference.putFile(image.value!);
      String imageUrl = await reference.getDownloadURL();
      await saveImageUrlToFirestore(imageUrl); // Save the image URL
    } catch (e) {
      Get.snackbar('Error', 'Error uploading image: $e');
    }
  }

  Future<void> saveImageUrlToFirestore(String imageUrl) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestore.collection('InstaUser').doc(user.uid).set(
        {'imageUrl': imageUrl},
        SetOptions(merge: true),
      );
      profileImageUrl.value = imageUrl;
    }
  }

  Future<void> saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestore.collection('InstaUser').doc(user.uid).set({
        'username': usernameController.text,
        'email': emailController.text,
        'pronouns': pronounsController.text,
        'bio': bioController.text,
      }, SetOptions(merge: true));

      Get.back();
    }
  }

  void toggleSwitch(bool value) {
    isSwitched.value = value;
  }
}
