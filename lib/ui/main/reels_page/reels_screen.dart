import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ReelsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> videoUrls = [];
  bool isLoading = true;
  String? error;

  @override
  void onInit() {
    super.onInit();
    fetchReels();
  }

  Future<void> fetchReels() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('reels').get();
      videoUrls =
          snapshot.docs.map((doc) => doc['mediaUrl'] as String).toList();
      isLoading = false;
    } catch (e) {
      error = e.toString();
      isLoading = false;
    }
    update();
  }
}

class ReelsScreen extends StatelessWidget {
  const ReelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ReelsController());

    return Scaffold(
      appBar: AppBar(title: const Text('Reels')),
      body: GetBuilder<ReelsController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.error != null) {
            return Center(child: Text('Error: ${controller.error}'));
          } else if (controller.videoUrls.isEmpty) {
            return const Center(child: Text('No videos found.'));
          }

          // Use a PageView for vertical scrolling between videos
          return PageView.builder(
            scrollDirection: Axis.vertical, // Vertical swipe direction
            itemCount: controller.videoUrls.length,
            itemBuilder: (context, index) {
              return VideoPlayerWidget(videoUrl: controller.videoUrls[index]);
            },
          );
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _isPlaying = true;
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _togglePlayPause,
                child: _isPlaying
                    ? Container()
                    : Icon(
                        Icons.play_arrow,
                        size: 64.0,
                        color: Colors.white.withOpacity(0.7),
                      ),
              ),
            ],
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
