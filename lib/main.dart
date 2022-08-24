import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'alert box.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(scaffoldBackgroundColor: Colors.black),
      home: pgone(),
    );
  }
}

class pgone extends StatefulWidget {
  @override
  State<pgone> createState() => _pgoneState();
}

class _pgoneState extends State<pgone> {
  final Tea = FirebaseFirestore.instance;
  TextEditingController Body = TextEditingController();
  String Note = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Notes'),
        centerTitle: true,
        backgroundColor: Colors.black,
        shape: Border(bottom: BorderSide(color: Colors.white, width: 5)),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        splashColor: Colors.amber,
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('Add Your Notes'),
                    content: TextField(
                      controller: Body,
                      decoration:
                          InputDecoration(hintText: 'Enter discription here'),
                      autofocus: true,
                    ),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            final firestore = FirebaseFirestore.instance
                                .collection('notes')
                                .doc();
                            Map<String, dynamic> data = {"Note": Body.text};
                            await firestore.set(data);
                            Navigator.pop(context);
                            Body.text='';
                          },
                          child: Text('Submit')),
                    ],
                  ));
        },
      ),
      body: StreamBuilder(
          stream: Tea.collection('notes').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return GridView.builder(
                itemCount: snapshot.data.docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,childAspectRatio: 0.8,mainAxisSpacing:8,crossAxisSpacing:8),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.amber,
                    child: Text(
                      snapshot.data.docs[index]['Note'],
                      style: TextStyle(fontSize: 25),
                    ),
                  );
                });
          }),
    );
  }
}
