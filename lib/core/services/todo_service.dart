import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todos/core/models/todo.dart';

import 'auth_service.dart';

class TodoService {
  final todoCollection = FirebaseFirestore.instance.collection('todos');

  Future<void> addNewTodo(Todo todo) {
    return todoCollection.add(todo.toDocument());
  }

  Future<void> deleteTodo(Todo todo) async {
    return todoCollection.doc(todo.id).delete();
  }

  Future<void> updateTodo(Todo todo) {
    return todoCollection.doc(todo.id).update(todo.toDocument());
  }

  Stream<List<Todo>> todos() {
    return todoCollection
        .where('uid', isEqualTo: AuthService().getUserId())
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Todo.fromSnapshot(doc)).toList();
    });
  }

  int getNumComplete() {}
}
