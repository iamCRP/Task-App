import 'package:cloud_firestore/cloud_firestore.dart';

class Todomodel {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final Timestamp timeStamp;

  Todomodel({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.timeStamp,
  });
}
