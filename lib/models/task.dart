


class Task {
  int? id;
  String? title;
  String? note;
  //If task is Completed it will be 1 otherwise 0 or any value
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;

  Task({
    this.id,
    this.title,
    this.note,
    this.isCompleted,
    this.date,
    this.startTime,
    this.endTime,
    this.color,
    this.remind,
    this.repeat
  });

  Map<String, dynamic> toJson () {
    return {
      'id': id,
      'title': title,
      'note': note,
      'isCompleted': isCompleted,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'color': color,
      'remind': remind,
      'repeat': repeat,
    };
  }

  Task.fromJson(Map<String, dynamic> json) {
    print('JSON Data: $json');
    id          = json['id'] as int?;
    title       = json['title'] as String?;
    note        = json['note'] as String?;
    date        = json['date'] as String?;
    startTime   = json['startTime'] as String?;
    endTime     = json['endTime'] as String?;
    remind      = json['remind'] as int?;
    repeat      = json['repeat'] as String?;
    color       = json['color'] as int?;
    isCompleted = json['isCompleted'] as int?;
  }
}
