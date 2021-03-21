import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:todos/core/models/todo.dart';
import 'package:todos/core/providers/todo_provider.dart';
import 'package:todos/locator.dart';

class TodoDetail extends StatefulWidget {
  final Todo todo;

  TodoDetail(this.todo);

  @override
  _TodoDetailState createState() => _TodoDetailState();
}

class _TodoDetailState extends State<TodoDetail> {
  var _titleController = TextEditingController();
  var _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: sliverAppBar(context),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(18, 30, 18, 0),
          child: Column(
            children: [titleUI(), SizedBox(height: 20), descriptionUI()],
          ),
        ));
  }

  titleUI() {
    return TextField(
      enableSuggestions: false,
      controller: _titleController..text = widget.todo.title,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      cursorColor: Theme.of(context).primaryColor,
      // cursorHeight: 30,
      style: TextStyle(
          fontSize: 24,
          height: 1.2,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w600),
      decoration: InputDecoration.collapsed(
        hintStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(.2)),
        hintText: "Enter title",
      ),
      maxLines: 1,
      onChanged: (value) {},
      onSubmitted: (value) {},
    );
  }

  descriptionUI() {
    return TextField(
      enableSuggestions: false,
      controller: _descriptionController..text = widget.todo.description,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      cursorColor: Theme.of(context).primaryColor,
      // cursorHeight: 30,
      style: TextStyle(fontSize: 16, height: 1.2, color: Colors.black87),
      decoration: InputDecoration.collapsed(
        hintText: "Enter description",
        hintStyle: TextStyle(
            fontSize: 16, height: 1.2, color: Colors.black.withOpacity(.2)),
      ),
      maxLines: 1,
      onSubmitted: (value) {},
    );
  }

  Widget sliverAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: _checkSave,
        child: Icon(
          Icons.arrow_back,
          color: Theme.of(context).primaryColor,
        ),
      ),
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 18),
          child: GestureDetector(
            onTap: () async {
              Navigator.pop(context);
              await saveTodo();
              EasyLoading.showSuccess('Saved!');
              Future.delayed(new Duration(seconds: 1), () {});
            },
            child: Icon(
              Icons.save_rounded,
              color: Theme.of(context).primaryColor,
            ),
          ),
        )
      ],
      title: Text(
        'Todo detail',
        style: Theme.of(context)
            .textTheme
            .headline5
            .copyWith(color: Colors.black87, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _checkSave() {
    var isChange = _titleController.text != widget.todo.title ||
        _descriptionController.text != widget.todo.description;
    if (isChange) {
      _showSaveConfirmDialog();
    } else
      Navigator.pop(context);
  }

  void _showSaveConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text("Save confirm?"),
          content: Text(
            "Do you want to save this change?",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          actions: <Widget>[
            ButtonTheme(
              //minWidth: double.infinity,
              child: RaisedButton(
                elevation: 3.0,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('No'),
                color: Colors.grey[400],
                textColor: const Color(0xffffffff),
              ),
            ),
            ButtonTheme(
              //minWidth: double.infinity,
              child: RaisedButton(
                elevation: 3.0,
                onPressed: () async {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  await saveTodo();
                  EasyLoading.showToast("Saved!",
                      duration: new Duration(seconds: 1));
                },
                child: Text('SAVE'),
                color: Theme.of(context).primaryColor,
                textColor: const Color(0xffffffff),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveTodo() async {
    await locator.get<TodoProvider>().updateTodo(widget.todo.copyWith(
        title: _titleController.text,
        description: _descriptionController.text));
  }
}
