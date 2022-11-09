import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fire_app/Utils/utils.dart';
import 'package:fire_app/Widgets/roundButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPostFireStore extends StatefulWidget {
  const AddPostFireStore({super.key});

  @override
  State<AddPostFireStore> createState() => _AddPostFireStoreState();
}

class _AddPostFireStoreState extends State<AddPostFireStore> {
  bool loading = false;
  final postController = TextEditingController();
  // Reference to the collection Users
  final firestore = FirebaseFirestore.instance.collection("Posts");
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Firestore is a noSQL DB whereas Realtime DB is the Sql DB
      // FIrestore is a bit better DB so it is preferred
      appBar: AppBar(
        title: const Text("Add Something on the Firestore"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            TextFormField(
              controller: postController,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: "What's on your mind ?",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
              title: "Add",
              isLoading: loading,
              onPress: () {
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                setState(() {
                  loading = true;
                });

                final currentUserId = FirebaseAuth.instance.currentUser?.uid;
                // Inserting data into the doc with ID
                firestore.doc(id).set({
                  // Same Map Form main data ayega yahan bhi
                  "title": postController.text.toString(),
                  "id": id,
                  "uId": currentUserId.toString(),
                  "user": auth.currentUser?.displayName,
                }).then((value) {
                  setState(() {
                    loading = false;
                  });
                  postController.clear();
                  Utils.toastsMessage("Post Added");
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  Utils.toastsMessage("Something went wrong");
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
