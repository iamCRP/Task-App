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
                  endActionPane: ActionPane(
                    motion: DrawerMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        icon: Icons.done,
                        onPressed: (context) {
                          _databaseservices.updateTodoStatus(
                            todomodel.id,
                            true,
                          );
                        },
                      ),
                    ],
                  ),
                  key: ValueKey(todomodel.id),
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
}
