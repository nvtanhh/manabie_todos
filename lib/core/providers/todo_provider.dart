import 'package:flutter/cupertino.dart';
import 'package:rxdart/subjects.dart';
import 'package:todos/core/models/todo.dart';
import 'package:todos/core/services/todo_service.dart';

class TodoProvider extends ChangeNotifier {
  TodoService _service = TodoService();

  var _subject = BehaviorSubject<List<Todo>>();
  List<Todo> _todos = [];

  int total = 0;
  int complete = 0;

  TodoProvider() {
    _service.todos().listen((todos) {
      _todos = todos.reversed.toList();
      _subject.add(_todos);
      this.total = todos.length;
      this.complete = todos.where((todo) => todo.isCompleted).length;
    });
    _service.todos();
  }

  get stream => _subject.stream;

  void addNewTodo(Todo todo) {
    _service.addNewTodo(todo);
    notifyListeners();
  }

  void deleteTodo(Todo todo) async {
    _service.deleteTodo(todo);
    notifyListeners();
  }

  void updateTodo(Todo todo) {
    _service.updateTodo(todo);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _subject.close();
  }

  void changeTap(int index) {
    switch (index) {
      case 0:
        List<Todo> completeTodos =
            _todos.where((todo) => todo.isCompleted).toList();
        _subject.add(completeTodos);
        break;
      case 1:
        _subject.add(_todos);
        break;
      case 2:
        List<Todo> incompleteTodos =
            _todos.where((todo) => !todo.isCompleted).toList();
        _subject.add(incompleteTodos);
        break;
    }
  }
}
