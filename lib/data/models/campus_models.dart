class StudentProfile {
  const StudentProfile({
    required this.name,
    required this.studentId,
    required this.department,
    required this.semester,
    required this.email,
  });

  final String name;
  final String studentId;
  final String department;
  final String semester;
  final String email;
}

class ClassSession {
  const ClassSession({
    required this.title,
    required this.instructor,
    required this.room,
    required this.startTime,
    required this.endTime,
  });

  final String title;
  final String instructor;
  final String room;
  final String startTime;
  final String endTime;
}

class AssignmentItem {
  const AssignmentItem({
    required this.title,
    required this.course,
    required this.dueDate,
    required this.priority,
    required this.completed,
  });

  final String title;
  final String course;
  final String dueDate;
  final String priority;
  final bool completed;
}

class NoticeItem {
  const NoticeItem({
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.important,
  });

  final String title;
  final String description;
  final String category;
  final String date;
  final bool important;
}
