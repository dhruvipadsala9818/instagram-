import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/add_post_controller.dart';

class AddPostScreen extends StatelessWidget {
  final AddPostController _controller = Get.put(AddPostController());

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final appBar = AppBar(
      title: Text('Add Post'),
      actions: [
        Obx(() => IconButton(
              icon: Icon(Icons.upload_file),
              onPressed: _controller.isUploading.value
                  ? null
                  : () {
                      if (_controller.image.value != null) {
                        _controller.uploadImage();
                      } else if (_controller.video.value != null) {
                        _controller.uploadVideo();
                      }
                    },
            )),
      ],
    );
    final availableHeight =
        height - appBar.preferredSize.height - mediaQuery.padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Center(
          child: Obx(() {
            if (_controller.isUploading.value) {
              return SizedBox(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_controller.image.value != null)
                    Column(
                      children: [
                        Container(
                          height: availableHeight * 0.4,
                          width: width * 0.9,
                          child: Image.file(
                            File(_controller.image.value!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: availableHeight * 0.02),
                      ],
                    ),
                  if (_controller.video.value != null)
                    Column(
                      children: [
                        Text(
                          "Video selected",
                          style: TextStyle(fontSize: width * 0.05),
                        ),
                        SizedBox(height: availableHeight * 0.02),
                      ],
                    ),
                  if (_controller.image.value == null &&
                      _controller.video.value == null)
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.add_a_photo),
                          iconSize: width * 0.15,
                          onPressed: _controller.pickImage,
                        ),
                        SizedBox(height: availableHeight * 0.02),
                        IconButton(
                          icon: Icon(Icons.video_collection_outlined),
                          iconSize: width * 0.15,
                          onPressed: _controller.pickVideo,
                        ),
                      ],
                    ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}
