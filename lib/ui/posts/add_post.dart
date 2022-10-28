import 'package:firebase_2/utils/utils.dart';
import 'package:firebase_2/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  bool loading = false;
  final databaseRef = FirebaseDatabase(databaseURL: "https://fir-1-9dbff-default-rtdb.asia-southeast1.firebasedatabase.app").ref('Post');
  final postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add post"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30,),
            TextFormField(
              controller: postController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "What's on your mind?",
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 30,),
            RoundButton(title: "Add", onTap: (){
              setState(() {
                loading = true;
              });
              String id = DateTime.now().millisecondsSinceEpoch.toString();
              databaseRef.child(id).set({
                'id' : id,
                'desc' : postController.text.toString(),
              }).then((value){
                setState(() {
                  loading = false;
                });
                Utils(success: true).toastMessage("Posted successfully");
              }).onError((error, stackTrace){
                setState(() {
                  loading = false;
                });
                Utils(success: false).toastMessage(error.toString());
              });
            },
            loading: loading,
            ),
          ],
        ),
      ),
    );
  }
}
