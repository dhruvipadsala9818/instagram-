import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class MoreStories extends StatefulWidget {
  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  final StoryController storyController = StoryController();
  final List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();
    fetchStories(); // Fetch stories when the widget initializes
  }

  void fetchStories() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('stories').get();
    for (var doc in snapshot.docs) {
      storyItems.add(StoryItem.pageImage(
        url: doc['imageUrl'],
        caption: Text(
          "Story by ${doc['uid']}", // Assuming you want to show user ID as caption
          style: TextStyle(fontSize: 15, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        controller: storyController,
      ));
    }
    setState(() {}); // Update the UI
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("More Stories"),
      ),
      body: StoryView(
        storyItems: storyItems,
        onStoryShow: (storyItem, index) {
          print("Showing a story");
        },
        onComplete: () {
          print("Completed a cycle");
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
        controller: storyController,
      ),
    );
  }
}
