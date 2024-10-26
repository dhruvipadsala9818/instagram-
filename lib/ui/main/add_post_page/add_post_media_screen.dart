import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/constant/app_string.dart';
import 'package:instagram/controllers/add_post_controller.dart';
import 'package:instagram/ui/main/add_post_page/video_player.dart';

class MediaPreviewScreen extends StatelessWidget {
  final XFile mediaFile;
  final AddPostController _controller = Get.put(AddPostController());

  MediaPreviewScreen({required this.mediaFile});

  @override
  Widget build(BuildContext context) {
    bool isImage =
        mediaFile.mimeType != null && mediaFile.mimeType!.startsWith('image/');

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Center(
            child: isImage
                ? Container(
                    height: 400,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(mediaFile.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : VideoPlayerScreen(videoFile: mediaFile),
          ),
          SizedBox(
            height: 10,
          ),
          MaterialButton(
            height: 50,
            minWidth: 100,
            color: Colors.grey,
            child: Text(
              AppString.post,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              _controller.uploadMedia(mediaFile, context);
            },
          ),
        ],
      ),
    );
  }
}
