import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/constant/app_string.dart';
import 'package:instagram/helper/helper.dart';
import 'package:instagram/ui/main/bottombar/bottom_nav_bar.dart';

class AddPostController extends GetxController {
  final Rx<XFile?> image = Rx<XFile?>(null);
  final Rx<XFile?> video = Rx<XFile?>(null);
  final RxBool isUploading = false.obs;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadMedia(XFile mediaFile, BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Helper.dialogCall.showToast(
          context,
          AppString.userNotAuthenticate,
          Colors.black,
          Colors.white,
        );
        return;
      }

      String? mimeType = mediaFile.mimeType;

      if (mimeType == null) {
        String fileExtension = mediaFile.path.split('.').last.toLowerCase();
        mimeType = _getMimeType(fileExtension);
        if (mimeType == null) {
          Helper.dialogCall.showToast(
            context,
            AppString.unsupportedFileType,
            Colors.black,
            Colors.white,
          );

          return;
        }
      }

      DocumentSnapshot snapshot =
          await _firestore.collection('InstaUser').doc(user.uid).get();

      String username = snapshot.exists && snapshot.data() != null
          ? (snapshot.data() as Map<String, dynamic>)['username'] ??
              AppString.unknownUser
          : AppString.unknownUser;

      String userProfileImageUrl = snapshot.exists && snapshot.data() != null
          ? (snapshot.data() as Map<String, dynamic>)['imageUrl'] ?? ''
          : '';

      String filePath =
          'media/${DateTime.now().millisecondsSinceEpoch}.$mimeType';
      Reference ref = FirebaseStorage.instance.ref().child(filePath);

      await ref.putFile(File(mediaFile.path));

      String downloadUrl = await ref.getDownloadURL();

      if (mimeType.startsWith('image/')) {
        await FirebaseFirestore.instance.collection('posts').add({
          'mediaUrl': downloadUrl,
          'uid': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
          'username': username,
          'userProfileImageUrl': userProfileImageUrl,
        });
        Helper.dialogCall.showToast(
          context,
          AppString.imageUploadSuccess,
          Colors.black,
          Colors.white,
        );
      } else if (mimeType.startsWith('video/')) {
        await FirebaseFirestore.instance.collection('reels').add({
          'mediaUrl': downloadUrl,
          'uid': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
          'username': username,
          'userProfileImageUrl': userProfileImageUrl,
        });
        Helper.dialogCall.showToast(
            context, AppString.videoUploadSuccess, Colors.black, Colors.white);
      }

      Get.offAll(() => BottomNavBar());
    } catch (e) {
      Helper.dialogCall.showToast(
        context,
        '${AppString.error} ${e.toString()}',
        Colors.black,
        Colors.white,
      );
    }
  }

  String? _getMimeType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';

      default:
        return null;
    }
  }
}
