import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todos/core/providers/tab_index_provider.dart';
import 'package:todos/core/services/auth_service.dart';
import 'package:todos/locator.dart';
import 'package:todos/ui/todo_body.dart';

import 'core/providers/todo_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();

  runApp(MyTodosApp());
}

class MyTodosApp extends StatelessWidget {
  final MaterialColor manabie = const MaterialColor(0xFF395AD2, {
    50: Color.fromRGBO(57, 90, 210, .1),
    100: Color.fromRGBO(57, 90, 210, .2),
    200: Color.fromRGBO(57, 90, 210, .3),
    300: Color.fromRGBO(57, 90, 210, .4),
    400: Color.fromRGBO(57, 90, 210, .5),
    500: Color.fromRGBO(57, 90, 210, .6),
    600: Color.fromRGBO(57, 90, 210, .7),
    700: Color.fromRGBO(57, 90, 210, .8),
    800: Color.fromRGBO(57, 90, 210, .9),
    900: Color.fromRGBO(57, 90, 210, 1),
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todos',
      theme: ThemeData(
          accentColor: Color(0xFF3ACD96),
          primarySwatch: manabie,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.montserratTextTheme()),
      home: MyHomePage(),
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    login();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void login() async {
    AuthService auth = locator.get<AuthService>();

    var isSignedIn = await auth.isAuthenticated();
    if (!isSignedIn) {
      await auth.authenticate();
    }
  }

  // List<Widget> bodies = [CompleteTodos(), AllTodos(), IncompleteTodos()];

  // final List<Stream<List<Todo>>> _streams = [
  //   locator.get<TodoProvider>().completeTodosStream,
  //   locator.get<TodoProvider>().allTodosStream,
  //   locator.get<TodoProvider>().incompleteTodosStream
  // ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: locator<AuthService>().userStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.data != null) {
          return StreamBuilder<int>(
              stream: locator.get<TabIndexProvider>().stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active &&
                    snapshot.data != null)
                  return Scaffold(
                      bottomNavigationBar: BottomNavigationBar(
                        unselectedItemColor: Colors.grey[400],
                        onTap: onTabTapped,
                        currentIndex: snapshot.data,
                        fixedColor:
                            Theme.of(context).primaryColor.withOpacity(.8),
                        items: <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                              icon:
                                  new Icon(FontAwesomeIcons.solidCalendarCheck),
                              label: "Complete"),
                          BottomNavigationBarItem(
                              icon: new Icon(FontAwesomeIcons.solidListAlt),
                              label: "All"),
                          BottomNavigationBarItem(
                              icon:
                                  new Icon(FontAwesomeIcons.solidCalendarTimes),
                              label: "Incomplete")
                        ],
                      ),
                      body: TodoBody(snapshot.data));
                else
                  return Container();
              });
        } else
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
      },
    );
  }

  void onTabTapped(int value) {
    locator.get<TabIndexProvider>().setCurrentIndex(value);
    Future.delayed(new Duration(milliseconds: 30),
        () => locator.get<TodoProvider>().sinkStream());
  }
}
