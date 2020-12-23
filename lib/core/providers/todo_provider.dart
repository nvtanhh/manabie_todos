import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:todos/core/models/todo.dart';
import 'package:todos/core/services/todo_service.dart';

class TodoProvider extends ChangeNotifier {
  TodoService _service = TodoService();
  StreamController todosController =
      new StreamController<List<Todo>>.broadcast();

  List<Todo> todos = [];
  int total = 0;
  int complete = 0;

  TodoProvider() {
    _service.todos().asBroadcastStream().listen((todos) {
      this.todos = todos;
      todosController.sink.add(todos);
      this.total = todos.length;
      this.complete = todos.where((todo) => todo.isCompleted).length;
    });
    _service.todos();
  }

  Future<void> addNewTodo(Todo todo) {
    return _service.addNewTodo(todo);
  }

  Future<void> deleteTodo(Todo todo) async {
    return _service.deleteTodo(todo);
  }

  Future<void> updateTodo(Todo todo) {
    return _service.updateTodo(todo);
  }

  var completeTodos = StreamTransformer<List<Todo>, List<Todo>>.fromHandlers(
      handleData: (data, sink) {
    List<Todo> todos = data.where((todo) => todo.isCompleted).toList();
    sink.add(todos);
  });

  var incompleteTodos = StreamTransformer<List<Todo>, List<Todo>>.fromHandlers(
      handleData: (data, sink) {
    List<Todo> todos = data.where((todo) => !todo.isCompleted).toList();
    sink.add(todos);
  });

  Stream<List<Todo>> fetchAllTodoAsStream() {
    return _service.todos();
  }

  Stream<List<Todo>> get completeTodosStream =>
      todosController.stream.transform(completeTodos);

  Stream<List<Todo>> get incompleteTodosStream =>
      todosController.stream.transform(incompleteTodos);

  Stream<List<Todo>> get allTodosStream => todosController.stream;

  Stream<List<Todo>> getStream(tabIndex) {
    switch (tabIndex) {
      case 0:
        return completeTodosStream;
        break;
      case 1:
        return allTodosStream;
        break;
      case 2:
        return incompleteTodosStream;
        break;
      default:
        return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    todosController.close();
  }

  void sinkStream() {
    print('sink');
    todosController.sink.add(this.todos);
  }
}
