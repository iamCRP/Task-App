import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_app/model/todoModel.dart';
import 'package:task_app/services/databaseServices.dart';

class Completedtask extends StatefulWidget {
  const Completedtask({super.key});

  @override
  State<Completedtask> createState() => _CompletedtaskState();
}

class _CompletedtaskState extends State<Completedtask> {
  final Databaseservices _databaseservices = Databaseservices();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Todomodel>>(
      stream: _databaseservices.completedtodos,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        List<Todomodel> todos = snapshot.data!;

        if (todos.isEmpty) {
          return Center(child: Text("No completed tasks yet ✅"));
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
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Slidable(
                key: ValueKey(todomodel.id),
                startActionPane: ActionPane(
                  motion: DrawerMotion(),
                  children: [
                    SlidableAction(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      icon: Icons.refresh,
                      label: "Unmark",
                      onPressed: (context) {
                        _databaseservices.updateTodoStatus(
                          todomodel.id,
                          false, // move back to "New Task"
                        );
                      },
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: DrawerMotion(),
                  children: [
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration:
                          TextDecoration.lineThrough, // ✅ strike-through
                    ),
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
}
