import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_app/model/todoModel.dart';
import 'package:task_app/services/databaseServices.dart';

class Newtask extends StatefulWidget {
  const Newtask({super.key});

  @override
  State<Newtask> createState() => _NewtaskState();
}

class _NewtaskState extends State<Newtask> {
  User? user = FirebaseAuth.instance.currentUser;
  late String uid;
  final Databaseservices _databaseservices = Databaseservices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Todomodel>>(
      stream: _databaseservices.todos,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Todomodel> todos = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              Todomodel todomodel = todos[index];
              final DateTime dt = todomodel.timeStamp.toDate();
              return Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Slidable(
                  key: ValueKey(todomodel.id),
                  endActionPane: ActionPane(
                    motion: DrawerMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        icon: Icons.done,
                        label: "Mark",
                        onPressed: (context) {
                          _databaseservices.updateTodoStatus(
                            todomodel.id,
                            true,
                          );
                        },
                      ),
                    ],
                  ),
                  startActionPane: ActionPane(
                    motion: DrawerMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: "Edit",
                        onPressed: (context) {
                          _showTaskDialog(context, todo: todomodel);
                        },
                      ),
                      SlidableAction(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: "delete",
                        onPressed: (context) async {
                          await _databaseservices.deleteTodoTask(todomodel.id);
                        },
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      todomodel.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(todomodel.description),
                    trailing: Text(
                      '${dt.day}/${dt.month}/${dt.year}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator(color: Colors.white));
        }
      },
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
