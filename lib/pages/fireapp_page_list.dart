import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireappPageList extends StatefulWidget {
  FireappPageList({Key? key}) : super(key: key);

  @override
  _FireappPageListState createState() => _FireappPageListState();
}

class _FireappPageListState extends State<FireappPageList> {
  CollectionReference tasksTable =
      FirebaseFirestore.instance.collection('tasks');
  List<TaskModel> list = [];
  String fn = '';
  String ln = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FireApp"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<TaskModel>>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                list = snapshot.data!;
                return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) => Column(
                          children: [
                            ListTile(
                              onLongPress: () {
                                setState(() async {
                                  await tasksTable
                                      .doc('${list[index].id}')
                                      .update({});
                                });
                              },
                              title: Text(
                                  "${list[index].fname}  ${list[index].lname}"),
                              onTap: () {},
                              trailing: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tasksTable
                                        .doc('${list[index].id}')
                                        .delete();
                                  });
                                },
                                child: Icon(Icons.delete),
                              ),
                            ),
                          ],
                        ));
              }
            }
            return Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("User data"),
                    backgroundColor: Colors.blue[50],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    actions: [
                      TextField(
                        decoration: InputDecoration(hintText: "fname"),
                        onChanged: (v) => fn = v,
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: "lname"),
                        onChanged: (v) => ln = v,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            addTask();
                          },
                          child: Text("submit")),
                    ],
                  ));
        },
      ),
    );
  }

  Future<List<TaskModel>> getData() async {
    List<TaskModel> taskList = [];

    var tableData = await tasksTable.get();

    if (tableData.docs.isNotEmpty) {
      tableData.docs.forEach((element) {
        var json = element.data() as Map;
        taskList.add(TaskModel(
          id: element.id,
          fname: json["fname"],
          lname: json["lname"],
        ));
      });
    }
    return taskList;
  }

  void addTask() async {
    CollectionReference tasksTable =
        FirebaseFirestore.instance.collection('tasks');
    await tasksTable.doc().set({
      "fname": fn,
      "lname": ln,
    });
    fn = '';
    ln = '';
    Navigator.pop(context);
    setState(() {});
  }
}

class TaskModel {
  final String? id;
  final String? fname;
  final String? lname;

  TaskModel({
    this.id,
    this.fname,
    this.lname,
  });
}
