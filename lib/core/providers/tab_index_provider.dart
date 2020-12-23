import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todos/core/providers/todo_provider.dart';
import 'package:todos/locator.dart';

class TabIndexProvider extends ChangeNotifier {
  int currentIndex = 1;
  final StreamController _controller = new StreamController<int>();

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
    }
  }
}
