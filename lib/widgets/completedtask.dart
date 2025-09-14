import 'package:firebase_auth/firebase_auth.dart';
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
      stream: _databaseservices.completedtodos,
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
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Slidable(
                  key: ValueKey(todomodel.id),
                  endActionPane: ActionPane(
                    motion: DrawerMotion(),
                    children: [
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    subtitle: Text(
                      todomodel.description,
                      style: TextStyle(decoration: TextDecoration.lineThrough),
                    ),
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
}
