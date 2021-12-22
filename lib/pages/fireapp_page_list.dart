import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Fireapp_Page_List extends StatelessWidget {
  const Fireapp_Page_List({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("FireApp")),
      ),
      body: FutureBuilder<List<TaskModel>>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<TaskModel> list = [];
              if (snapshot.hasData) {
                list = snapshot.data!;
                return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) => Column(
                          children: [
                            ListTile(
                              title: Text("${list[index].username}"),
                            ),
                            ListTile(
                              title: Text("${list[index].email}"),
                            ),
                            ListTile(
                              title: Text("${list[index].password}"),
                            )
                          ],
                        ));
              }
            }
            return Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text(""),
                  ));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<List<TaskModel>> getData() async {
    List<TaskModel> taskList = [];
    CollectionReference tasksTable =
        FirebaseFirestore.instance.collection('tasks');
    var tableData = await tasksTable.get();

    if (tableData.docs.isNotEmpty) {
      tableData.docs.forEach((element) {
        var json = element.data() as Map;
        taskList.add(TaskModel(
          id: element.id,
          username: json["username"],
          email: json["email"],
          password: json["password"],
        ));
      });
    }
    return taskList;
  }
}

class TaskModel {
  final String? id;
  final String? username;
  final String? email;
  final String? password;

  TaskModel({
    this.id,
    this.username,
    this.email,
    this.password,
  });
}
