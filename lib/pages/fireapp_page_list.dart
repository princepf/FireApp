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
        title: Text("Friend List"),
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
                    itemBuilder: (context, index) => Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  color: Colors.amber.withOpacity(0.7))),
                          child: ListTile(
                            onLongPress: () {
                              fn = list[index].fname!;
                              ln = list[index].lname!;
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text(
                                          "Update data",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        actions: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                border: Border.all(
                                                    color: Colors.amber
                                                        .withOpacity(0.7),
                                                    width: 1.5)),
                                            height: 50,
                                            width: double.infinity,
                                            child: TextFormField(
                                              initialValue: list[index].fname,
                                              decoration: InputDecoration(
                                                  icon: Icon(Icons
                                                      .person_pin_circle_rounded),
                                                  fillColor: Colors.amber,
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  hintText: "fname",
                                                  hintStyle: TextStyle(
                                                      color: Colors.amber)),
                                              onChanged: (v) => fn = v,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                border: Border.all(
                                                    color: Colors.amber
                                                        .withOpacity(0.7),
                                                    width: 1.5)),
                                            height: 50,
                                            width: double.infinity,
                                            child: TextFormField(
                                              initialValue: list[index].lname,
                                              decoration: InputDecoration(
                                                  icon: Icon(Icons
                                                      .person_pin_circle_outlined),
                                                  fillColor: Colors.amber,
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  hintText: "lname",
                                                  hintStyle: TextStyle(
                                                      color: Colors.amber)),
                                              onChanged: (v) => ln = v,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                              onTap: () {
                                                updateTask(list[index].id);
                                              },
                                              child: Container(
                                                  margin: EdgeInsets.all(20),
                                                  alignment: Alignment.center,
                                                  height: 40,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: Colors.amber,
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          color: Colors.grey,
                                                          blurRadius: 15,
                                                          offset: Offset(4, 4),
                                                          spreadRadius: 1),
                                                      BoxShadow(
                                                          color: Colors.white12,
                                                          blurRadius: 15,
                                                          offset:
                                                              Offset(-4, -4),
                                                          spreadRadius: 1)
                                                    ],
                                                  ),
                                                  child: Text(
                                                    "Update",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ))),
                                        ],
                                      ));
                            },
                            title: Container(
                              child: Text(
                                  "${list[index].fname}  ${list[index].lname}"),
                            ),
                            onTap: () {},
                            trailing: GestureDetector(
                              onTap: () {
                                setState(() {
                                  tasksTable.doc('${list[index].id}').delete();
                                });
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.amber[400],
                              ),
                            ),
                          ),
                        ));
              }
            }
            return Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text(
                      "Friend data",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    actions: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: Colors.amber.withOpacity(0.7),
                                width: 1.5)),
                        height: 50,
                        width: double.infinity,
                        child: TextField(
                          decoration: InputDecoration(
                              icon: Icon(Icons.person_pin_circle_rounded),
                              fillColor: Colors.amber,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: "fname",
                              hintStyle: TextStyle(color: Colors.amber)),
                          onChanged: (v) => fn = v,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: Colors.amber.withOpacity(0.7),
                                width: 1.5)),
                        height: 50,
                        width: double.infinity,
                        child: TextField(
                          decoration: InputDecoration(
                              icon: Icon(Icons.person_pin_circle_outlined),
                              fillColor: Colors.amber,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: "lname",
                              hintStyle: TextStyle(color: Colors.amber)),
                          onChanged: (v) => ln = v,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                          onTap: () {},
                          child: Container(
                              margin: EdgeInsets.all(20),
                              alignment: Alignment.center,
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.amber,
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 15,
                                      offset: Offset(4, 4),
                                      spreadRadius: 1),
                                  BoxShadow(
                                      color: Colors.white12,
                                      blurRadius: 15,
                                      offset: Offset(-4, -4),
                                      spreadRadius: 1)
                                ],
                              ),
                              child: Text(
                                "Add",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ))),
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

  void updateTask(String? id) async {
    CollectionReference tasksTable =
        FirebaseFirestore.instance.collection('tasks');
    await tasksTable.doc(id).set({
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
