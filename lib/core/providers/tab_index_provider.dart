import 'dart:async';

import 'package:flutter/material.dart';

import '../../locator.dart';
import 'todo_provider.dart';

class TabIndexProvider extends ChangeNotifier {
  int currentIndex = 1;
  final StreamController _controller = StreamController<int>();
  var _todoProvider = locator<TodoProvider>();

  TabIndexProvider() {
    currentIndex = 1;
    _controller.sink.add(currentIndex);
  }

  int get index => currentIndex;

  Stream<int> get stream => _controller.stream;

  void setCurrentIndex(int index) {
    if (currentIndex != index) {
      currentIndex = index;
      _controller.sink.add(index);
      _todoProvider.changeTap(index);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }
}
