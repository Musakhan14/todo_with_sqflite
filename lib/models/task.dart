class Todo {
  int? _id;
  var _title;
  var _description;
  var _date;
  var _priority;
  bool? _isCompleted;

  Todo(this._title, this._date, this._priority, this._description,
      this._isCompleted);

  Todo.withId(this._id, this._title, this._date, this._priority,
      this._description, this._isCompleted);

  int? get id => _id;

  String get title => _title!;

  String get description => _description!;

  int get priority => _priority!;

  String get date => _date!;

  bool get isCompleted => _isCompleted!;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      _description = newDescription;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      _priority = newPriority;
    }
  }

  set date(String newDate) {
    _date = newDate;
  }

  set isCompleted(bool isComplete) {
    _isCompleted = isComplete;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;
    map['isCompleted'] = _isCompleted! ? 1 : 0;

    return map;
  }

  // Extract a Note object from a Map object
  Todo.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _title = map['title'];
    _description = map['description'];
    _priority = map['priority'];
    _date = map['date'];
    _isCompleted = map['isCompleted'] != null ? map['isCompleted'] == 1 : null;

    // _isCompleted = map['isCompleted'];
  }
}
