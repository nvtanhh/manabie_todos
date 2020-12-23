import 'package:get_it/get_it.dart';
import 'package:todos/core/providers/todo_provider.dart';
import 'package:todos/core/services/auth_service.dart';

import 'core/providers/tab_index_provider.dart';

GetIt locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton(() => TodoProvider());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => TabIndexProvider());
}
