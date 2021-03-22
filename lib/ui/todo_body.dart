import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:todos/core/models/todo.dart';
import 'package:todos/core/providers/todo_provider.dart';
import 'package:todos/locator.dart';
import 'package:todos/ui/widgets/todo_item.dart';

class TodoBody extends StatefulWidget {
  final int tapIndex;
  TodoBody(this.tapIndex);

  @override
  _TodoBodyState createState() => _TodoBodyState();
}

class _TodoBodyState extends State<TodoBody> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder<List<Todo>>(
            stream: locator.get<TodoProvider>().stream,
            initialData: [],
            builder:
                (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
              if (snapshot.connectionState == ConnectionState.active &&
                  snapshot.data != null) {
                return Column(children: [
                  _appBarUI(),
                  _summaryPart(),
                  _listTotosUI(snapshot.data)
                ]);
              } else
                return Center();
            }),

        //
        floatingActionButton:
            widget.tapIndex == 1 ? _floadtingButton() : SizedBox(),
      ),
    );
  }

  Widget _appBarUI() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 56,
      alignment: Alignment.center,
      child: Image.asset('assets/mtodo_logo.png'),
    );
  }

  Widget _summaryPart() {
    int total = locator.get<TodoProvider>().total;
    int numComplete = locator.get<TodoProvider>().complete;
    var text1;
    var text2;
    switch (widget.tapIndex) {
      case 0:
        text1 = "My Todos";
        text2 = numComplete.toString() + " complete todos";
        break;
      case 1:
        text1 = "My Todos";
        text2 = numComplete.toString() + " of " + total.toString() + " todos";
        break;
      case 2:
        text1 = "Incomplete";
        text2 = (total - numComplete).toString() + " incomplete todos";
        break;
      default:
    }
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Container(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: size.width * 0.2,
                  child: (widget.tapIndex == 1)
                      ? CircularPercentIndicator(
                          radius: 22,
                          lineWidth: 3,
                          percent: numComplete / total,
                          backgroundColor: Colors.grey[300],
                          progressColor: Theme.of(context).primaryColor,
                        )
                      : Container(),
                ),
                Text(
                  text1,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  style: Theme.of(context).textTheme.headline4.copyWith(
                      color: Colors.black87, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: size.width * 0.2,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(text2,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Divider(
                          color: Colors.grey[300],
                          height: 2,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _listTotosUI(List<Todo> todos) {
    return Expanded(
        child: todos.length > 0
            ? ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 20),
                itemCount: todos.length,
                itemBuilder: (BuildContext context, int index) {
                  Todo todo = todos[index];
                  return TodoItem(todo, editable: widget.tapIndex == 1);
                })
            : Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/empty.png',
                    width: size.width * 0.6,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Empty todo!',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.black54),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              )));
  }

  Widget _floadtingButton() {
    return new Container(
      width: 50.0,
      height: 50.0,
      decoration: new BoxDecoration(
        // border: ,
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(1, 1), // changes position of shadow
          ),
        ],
      ),
      child: new IconButton(
        icon: new Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: _showAddTodoDialog,
        iconSize: 30.0,
      ),
    );
  }

  _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new TextField(
                autofocus: true,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: Theme.of(context).primaryColor)),
                    labelText: "Title",
                    hintText: "",
                    contentPadding: EdgeInsets.only(
                        left: 16.0, top: 20.0, right: 16.0, bottom: 5.0)),
                controller: titleController,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                autofocus: false,
                maxLines: 4,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: Theme.of(context).primaryColor)),
                    labelText: "Desciption",
                    hintText: "",
                    contentPadding: EdgeInsets.only(
                        left: 16.0, top: 20.0, right: 16.0, bottom: 5.0)),
                controller: descriptionController,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
              )
            ],
          ),
          actions: <Widget>[
            ButtonTheme(
              //minWidth: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: RaisedButton(
                  elevation: 3.0,
                  onPressed: () async {
                    if (titleController.text.isNotEmpty) {
                      Navigator.of(context).pop();
                      Todo newTodo = new Todo(titleController.text,
                          description: descriptionController.text);
                      await locator.get<TodoProvider>().addNewTodo(newTodo);
                      titleController.clear();
                      descriptionController.clear();
                    } else {
                      EasyLoading.showToast("Title can't emplty");
                    }
                  },
                  child: Text('Add'),
                  color: Theme.of(context).primaryColor,
                  textColor: const Color(0xffffffff),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
