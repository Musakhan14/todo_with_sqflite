import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../Utils/data_base_helper.dart';
import '../models/task.dart';
import 'todo_detail_page.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<StatefulWidget> createState() {
    return TodoListState();
  }
}

class TodoListState extends State<TodoList> {
  DataBaseHelper databaseHelper = DataBaseHelper();
  List<Todo>? noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = <Todo>[];
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "My Tasks",
          style: TextStyle(
            color: Color(0xffEC9E37),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2),
        child: ListView.builder(
          itemCount: count,
          itemBuilder: (BuildContext context, int position) {
            return Dismissible(
              key: UniqueKey(),
              background: Container(
                color: Colors.red[200],
                alignment: AlignmentDirectional.center,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (direction) {
                // Remove the item from the data source
                _delete(context, noteList![position]);
              },
              child: Card(
                color: Colors.white,
                elevation: 4,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        getPriorityColor(noteList![position].priority),
                    child: getPriorityIcon(noteList![position].priority),
                  ),
                  title: Text(
                    noteList![position].title,
                    style: noteList![position].isCompleted == true
                        ? const TextStyle(
                            decorationThickness: 3,
                            decorationColor: Color(0xffEC9E37),
                            decoration: TextDecoration.lineThrough,
                            fontSize: 20)
                        : const TextStyle(),
                  ),
                  subtitle: Text(
                    noteList![position].description,
                  ),
                  trailing: Switch(
                    activeColor: const Color(0xffEC9E37),
                    value: noteList![position].isCompleted,
                    onChanged: (value) async {
                      // Update the isCompleted property in the database
                      noteList![position].isCompleted = value;
                      await databaseHelper.updateNote(noteList![position]);

                      // Trigger a rebuild of the widget
                      setState(() {});
                    },
                  ),
                  onTap: () {
                    debugPrint("ListTile tapped");
                    navigateToDetail(
                        (noteList![position]), "Edit Todo", 'Update');
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff1E3C64),
        onPressed: () {
          debugPrint("FAB clicked");
          navigateToDetail(Todo('', '', 2, "", false), "Add Todo", 'Save');
        },
        tooltip: "Add Note",
        child: const Icon(Icons.add),
      ),
    );
  }

  getNoteListView() {}

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return const Icon(Icons.play_arrow);
        break;
      case 2:
        return const Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return const Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Todo note) async {
    int? result = await databaseHelper.deleteNote(note.id!);
    if (result != 0) {
      _showSnackBar(context, 'Task Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> navigateToDetail(
      Todo note, String title, String buttonText) async {
    var result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      debugPrint(title);
      debugPrint("$note");
      return NoteDetail(note, title, buttonText);
    }));

    if (result == true) {
      updateListView();
    } else {
      debugPrint("updated list view using else statement");
      updateListView();
    }
  }

  void updateListView() {
    debugPrint("update listView called");
    final Future<Database?> dbFuture = databaseHelper.initializedDataBase();
    dbFuture.then((database) {
      debugPrint("$noteList");
      Future<List<Todo>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          count = noteList.length;
        });
      });
    });
  }
}
