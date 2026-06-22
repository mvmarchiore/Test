class Task {
  int? id;
  String task;
  int done;
  String created;

  Task({
    this.id,
    required this.task,
    required this.done,
    required this.created,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'done': done,
      'created': created,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      task: map['task'],
      done: map['done'],
      created: map['created'],
    );
  }
}