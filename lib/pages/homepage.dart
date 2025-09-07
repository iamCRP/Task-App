import 'package:flutter/material.dart';
import 'package:task_app/model/todoModel.dart';
import 'package:task_app/pages/loginpage.dart';
import 'package:task_app/services/authServices.dart';
import 'package:task_app/services/databaseServices.dart';
import 'package:task_app/widgets/completedtask.dart';
import 'package:task_app/widgets/newtask.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _buttonIndex = 0;
  final _widgets = [
    //New Task Widget
    Newtask(),
    //Completed Task Widget
    Completedtask(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "TODO",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthServices().signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Loginpage()),
                (route) => false,
              );
            },
            icon: Icon(Icons.exit_to_app, size: 40, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      _buttonIndex = 0;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.2,
                    decoration: BoxDecoration(
                      color: _buttonIndex == 0
                          ? Colors.blueAccent
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "New Task",
                        style: TextStyle(
                          fontSize: _buttonIndex == 0 ? 16 : 14,
                          fontWeight: FontWeight.bold,
                          color: _buttonIndex == 0
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      _buttonIndex = 1;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.2,
                    decoration: BoxDecoration(
                      color: _buttonIndex == 1
                          ? Colors.blueAccent
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Completed Task",
                        style: TextStyle(
                          fontSize: _buttonIndex == 1 ? 16 : 14,
                          fontWeight: FontWeight.bold,
                          color: _buttonIndex == 1
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            _widgets[_buttonIndex],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.add, size: 40, color: Colors.black),
        onPressed: () {
          _showTaskDialog(context);
        },
      ),
    );
  }

  void _showTaskDialog(BuildContext context, {Todomodel? todo}) {
    final TextEditingController _titlecontroller = TextEditingController(
      text: todo?.title,
    );
    final TextEditingController _descriptioncontroller = TextEditingController(
      text: todo?.description,
    );
    final Databaseservices _databaseService = Databaseservices();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            todo == null ? "Add task" : "Edit Task",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  TextField(
                    controller: _titlecontroller,
                    decoration: InputDecoration(
                      labelText: "title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _descriptioncontroller,
                    decoration: InputDecoration(
                      labelText: "description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (todo == null) {
                  await _databaseService.addTodoTask(
                    _titlecontroller.text,
                    _descriptioncontroller.text,
                  );
                } else {
                  await _databaseService.updateTodoTask(
                    todo.id,
                    _titlecontroller.text,
                    _descriptioncontroller.text,
                  );
                }
                Navigator.pop(context);
              },
              child: Text(todo == null ? "Add" : "Edit"),
            ),
          ],
        );
      },
    );
  }
}
