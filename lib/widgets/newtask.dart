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
  final Databaseservices _databaseservices = Databaseservices();
  late String uid;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Todomodel>>(
      stream: _databaseservices.todos,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        List<Todomodel> todos = snapshot.data!;

        if (todos.isEmpty) {
          return Center(child: Text("No tasks yet. Add one!"));
        }

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
                        _databaseservices.updateTodoStatus(todomodel.id, true);
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
                      label: "Delete",
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
            todo == null ? "Add Task" : "Edit Task",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _titlecontroller,
                  decoration: InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _descriptioncontroller,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
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
