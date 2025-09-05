import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_app/model/todoModel.dart';

class Databaseservices {
  final CollectionReference todoCollection = FirebaseFirestore.instance
      .collection("todos");

  User? user = FirebaseAuth.instance.currentUser;

  //add todo task
  Future<DocumentReference> addTodoTask(
    String title,
    String description,
  ) async {
    return await todoCollection.add({
      'uid': user!.uid,
      'title': title,
      'description': description,
      'completed': false,
      'createedAt': FieldValue.serverTimestamp(),
    });
  }

  //Update todo task
  Future<void> updateTodoTask(
    String id,
    String title,
    String description,
  ) async {
    final updatetodoCollection = FirebaseFirestore.instance
        .collection("todos")
        .doc(id);
    return await updatetodoCollection.update({
      'title': title,
      'description': description,
    });
  }

  //Update todo status
  Future<void> updateTodoStatus(String id, bool completed) async {
    return await todoCollection.doc(id).update({'completed': completed});
  }

  //Update todo status
  Future<void> deleteTodoTask(String id) async {
    return await todoCollection.doc(id).delete();
  }

  //get pending task
  Stream<List<Todomodel>> get todos {
    return todoCollection
        .where('uid', isEqualTo: user!.uid)
        .where('completed', isEqualTo: false)
        .snapshots()
        .map(_toListFromSnapshot);
  }

  //get completed task
  Stream<List<Todomodel>> get completedtodos {
    return todoCollection
        .where('uid', isEqualTo: user!.uid)
        .where('completed', isEqualTo: true)
        .snapshots()
        .map(_toListFromSnapshot);
  }

  List<Todomodel> _toListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Todomodel(
        id: doc.id,
        title: doc['title'] ?? '',
        description: doc['description'] ?? '',
        completed: doc['completed'] ?? false,
        timeStamp: doc['createdAt'] ?? '',
      );
    }).toList();
  }
}
