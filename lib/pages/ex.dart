import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Datapage extends StatefulWidget {
  const Datapage({Key? key}) : super(key: key);

  @override
  _DatapageState createState() => _DatapageState();
}

class _DatapageState extends State<Datapage> {
  List<Model> listdata = [];
  String fn = '';
  String ln = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase data"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Model>>(
          future: getdata(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                listdata = snapshot.data!;
                print(listdata);
                return ListView.builder(
                  itemCount: listdata.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                              "${listdata[index].fname} ${listdata[index].lname}"),
                          onTap: () {},
                        ),
                      ],
                    );
                  },
                );
              }
            }
            return Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    actions: [
                      TextFormField(
                        decoration: InputDecoration(hintText: 'fname'),
                        onChanged: (v) => fn = v,
                      ),
                      TextFormField(
                        decoration: InputDecoration(hintText: 'lname'),
                        onChanged: (v) => ln = v,
                      ),
                      TextButton(
                          onPressed: () {
                            addTask();
                          },
                          child: Text("Add"))
                    ],
                  ));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<List<Model>> getdata() async {
    List<Model> tasklist = [];
    CollectionReference taskTable =
        FirebaseFirestore.instance.collection('table');
    var tableData = await taskTable.get();
    if (tableData.docs.isNotEmpty) {
      tableData.docs.forEach((element) {
        var json = element.data() as Map;
        tasklist.add(
            Model(id: element.id, fname: json["fname"], lname: json["lname"]));
      });
    }
    return tasklist;
  }

  void addTask() async {
    CollectionReference taskTable =
        FirebaseFirestore.instance.collection('table');

    await taskTable.doc().set({
      "fname": fn,
      "lname": ln,
    });
    fn = '';
    ln = '';
    Navigator.pop(context);
    setState(() {
      getdata();
    });
  }
}

class Model {
  String? id;
  String? fname;
  String? lname;
  Model({this.id, this.fname, this.lname});
}
