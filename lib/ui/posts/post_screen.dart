import 'package:firebase_2/ui/auth/login_screen.dart';
import 'package:firebase_2/ui/posts/add_post.dart';
import 'package:firebase_2/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  final auth = FirebaseAuth.instance;
  final databaseRef = FirebaseDatabase(databaseURL: "https://fir-1-9dbff-default-rtdb.asia-southeast1.firebasedatabase.app").ref('Post');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();

  Future<void> updateFun(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Update"),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: InputDecoration(
                  hintText: "Edit",
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                  databaseRef.child(id).update({
                    'desc': editController.text.toString(),
                  }).then((value){
                    Utils(success: true).toastMessage("Updated successfully");
                  }).onError((error, stackTrace){
                    Utils(success: false).toastMessage("Some error occurred");
                  });
                },
                child: Text("Update"),
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              auth.signOut().then((value){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              }).onError((error, stackTrace) {
                Utils(success: false).toastMessage(error.toString());
              });
            },
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 10,)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPostScreen()));
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              autofocus: false,
              controller: searchFilter,
              onChanged: (String value){
                setState(() {

                });
              },
              decoration: const InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: databaseRef,
              defaultChild: const Text("Loading"),
              itemBuilder: (context, snapshot, animation, index){

                final title = snapshot.child('desc').value.toString();

                if(searchFilter.text.isEmpty){
                  return ListTile(
                    title: Text(snapshot.child('desc').value.toString()),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: (){
                              Navigator.pop(context);
                              updateFun(title,snapshot.child('id').value.toString());
                            },
                            leading: Icon(Icons.edit),
                            title: Text("Edit"),
                          )
                        ),
                        PopupMenuItem(
                            value: 1,
                            onTap: (){
                              databaseRef.child(snapshot.child('id').value.toString()).remove();
                            },
                            child: ListTile(
                              leading: Icon(Icons.delete),
                              title: Text("Delete"),
                            )
                        )
                      ],
                      icon: const Icon(Icons.more_vert),
                    ),
                  );
                } else if(title.toLowerCase().contains(searchFilter.text.toLowerCase())){
                  return ListTile(
                    title: Text(snapshot.child('desc').value.toString()),
                  );
                } else{
                  return Container();
                }
              }
            ),
          ),
        ],
      ),
    );
  }
}

// either use FirebaseAnimatedList or this
// Expanded(
// child: StreamBuilder(
// stream: databaseRef.onValue,
// builder: (context, AsyncSnapshot<DatabaseEvent> snapshot){
// if(!snapshot.hasData){
// return CircularProgressIndicator();
// } else{
// Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
// List<dynamic> list = [];
// list.clear();
// list = map.values.toList();
// return ListView.builder(
// itemCount: snapshot.data!.snapshot.children.length,
// itemBuilder: (context, index){
// return ListTile(
// title: Text(list[index]['desc']),
// );
// });
// }
// },
// ),
// ),