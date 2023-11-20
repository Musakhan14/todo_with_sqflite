import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Utils/alert_dialog.dart';
import '../Utils/data_base_helper.dart';
import '../models/task.dart';
import '../widgets/textfeild.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final String buttonText;
  Todo note;

  NoteDetail(this.note, this.appBarTitle, this.buttonText, {super.key});

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  static final _priorities = ['High', 'Low'];
  DataBaseHelper helper = DataBaseHelper();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize note if it's null
    widget.note ??=
        Todo('', '', 1, '', false); // Adjust the default values as needed
    titleController.text = widget.note!.title;
    descriptionController.text = widget.note!.description;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          moveToLastScreen();
          return Future.value(true); // Return a completed future with false
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              widget.appBarTitle,
              style: const TextStyle(
                color: Color(0xffEC9E37),
              ),
            ),
            leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xffEC9E37),
                ),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: AppTextField(
                    onChanged: (value) {
                      updateTitle();
                      setState(() {});
                    },
                    controller: titleController,
                    hintText: 'Title',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: AppTextField(
                    onChanged: (value) {
                      updateDescription();
                      setState(() {});
                    },
                    controller: descriptionController,
                    hintText: 'Description',
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'Priority',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        // Adjust the border radius as needed
                        border: Border.all(
                            color: Colors.grey), // Set the border color
                      ),
                      child: DropdownButton(
                        underline: const SizedBox(),
                        dropdownColor: Colors.white,
                        items: _priorities.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        value: getPriorityAsString(widget.note.priority),
                        onChanged: (valueSelectedByUser) {
                          setState(() {
                            debugPrint('User selected $valueSelectedByUser');
                            updatePriorityAsInt(valueSelectedByUser!);
                          });
                        },
                      ),
                    ),
                  ],
                ),

                // Fourth Element
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            // color: Theme.of(context).primaryColorDark,
                            // textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              widget.buttonText,
                              style: const TextStyle(
                                color: Color(0xffEC9E37),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("Save button clicked");
                                _save(context);
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                color: Color(0xffEC9E37),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("Delete button clicked");
                                _delete(context);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        widget.note.priority = 1;
        break;
      case 'Low':
        widget.note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value) {
    switch (value) {
      case 1:
        return _priorities[0]; // 'High'
      case 2:
        return _priorities[1]; // 'Low'
      default:
        return _priorities[0]; // Default to 'High' if value is not recognized
    }
  }

  // Update the title of Note object
  void updateTitle() {
    widget.note.title = titleController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    widget.note?.description = descriptionController.text;
  }

  // Save data to database
  void _save(BuildContext context) async {
    // WidgetsFlutterBinding.ensureInitialized(); // Add this line
    moveToLastScreen();
    widget.note.date = DateFormat.yMMMd().format(DateTime.now());
    int? result;
    if (widget.note.id != null) {
      // Case 1: Update operation
      result = await helper.updateNote(widget.note);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertNote(widget.note);
    }
    if (result != 0) {
      // Success
      showAlertDialog('Status', 'Task Saved Successfully', context);
    } else {
      // Failure
      showAlertDialog('Status', 'Problem Saving Todo', context);
    }
  }

  void _delete(BuildContext context) async {
    moveToLastScreen();
    if (widget.note.id == null) {
      showAlertDialog('Status', 'No Task was deleted', context);
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int? result = await helper.deleteNote(widget.note.id!);
    if (result != 0) {
      showAlertDialog('Status', 'Task Deleted Successfully', context);
    } else {
      showAlertDialog('Status', 'Error Occured while Deleting Task', context);
    }
  }
}
