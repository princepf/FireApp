import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Fireapp_Page_List extends StatelessWidget {
  const Fireapp_Page_List({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<TaskModel>>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<TaskModel> list = [];
              if (snapshot.hasData) {
                list = snapshot.data!;
                return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) => ListTile(
                          title: Text("${list[index].title}"),
                        ));
              }
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Future<List<TaskModel>> getData() async {
    List<TaskModel> taskList = [];
    CollectionReference tasksTable =
        FirebaseFirestore.instance.collection('Fireapp');
    var tableData = await tasksTable.get();

    if (tableData.docs.isNotEmpty) {
      tableData.docs.forEach((element) {
        var json = element.data() as Map;
        taskList.add(TaskModel(id: element.id, title: json["title"]));
      });
    }
    return taskList;
  }
}

class TaskModel {
  final String? id;
  final String? title;

  TaskModel({this.id, this.title});
}
