import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/campus_models.dart';

class CampusRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<StudentProfile> getProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null) {
        return StudentProfile(
          name: data['name'] as String? ?? 'Student',
          studentId: data['studentId'] as String? ?? 'MC-2026-001',
          department: data['department'] as String? ?? 'Computer Science',
          semester: data['semester'] as String? ?? '5th Semester',
          email: data['email'] as String? ?? '',
        );
      }
    } catch (_) {}
    return demoProfile;
  }

  Future<List<ClassSession>> getClasses(String uid) async {
    try {
      final snap = await _firestore
          .collection('users')
          .doc(uid)
          .collection('classes')
          .orderBy('startTime')
          .get();

      if (snap.docs.isNotEmpty) {
        return snap.docs.map((doc) {
          final d = doc.data();
          return ClassSession(
            title: d['title'] as String? ?? 'Class',
            instructor: d['instructor'] as String? ?? 'Instructor',
            room: d['room'] as String? ?? 'TBA',
            startTime: d['startTime'] as String? ?? '10:00 AM',
            endTime: d['endTime'] as String? ?? '11:00 AM',
          );
        }).toList();
      }
    } catch (_) {}
    return demoClasses;
  }

  Future<List<AssignmentItem>> getAssignments(String uid) async {
    try {
      final snap = await _firestore
          .collection('users')
          .doc(uid)
          .collection('assignments')
          .get();

      if (snap.docs.isNotEmpty) {
        return snap.docs.map((doc) {
          final d = doc.data();
          return AssignmentItem(
            title: d['title'] as String? ?? 'Assignment',
            course: d['course'] as String? ?? 'Course',
            dueDate: d['dueDate'] as String? ?? 'Soon',
            priority: d['priority'] as String? ?? 'Medium',
            completed: d['completed'] as bool? ?? false,
          );
        }).toList();
      }
    } catch (_) {}
    return demoAssignments;
  }

  Future<List<NoticeItem>> getNotices(String uid) async {
    try {
      final snap = await _firestore
          .collection('users')
          .doc(uid)
          .collection('notices')
          .get();

      if (snap.docs.isNotEmpty) {
        return snap.docs.map((doc) {
          final d = doc.data();
          return NoticeItem(
            title: d['title'] as String? ?? 'Campus Notice',
            description: d['description'] as String? ?? '',
            category: d['category'] as String? ?? 'General',
            date: d['date'] as String? ?? 'Today',
            important: d['important'] as bool? ?? false,
          );
        }).toList();
      }
    } catch (_) {}
    return demoNotices;
  }

  static const demoProfile = StudentProfile(
    name: 'Aarav Rahman',
    studentId: 'MC-2026-0142',
    department: 'Computer Science & Engineering',
    semester: '5th Semester',
    email: 'aarav@mycampus.edu',
  );

  static const demoClasses = [
    ClassSession(
      title: 'Database Systems',
      instructor: 'Dr. Sarah Ahmed',
      room: 'Room 402',
      startTime: '10:00 AM',
      endTime: '11:15 AM',
    ),
    ClassSession(
      title: 'Software Engineering',
      instructor: 'Prof. Tanvir Hasan',
      room: 'Lab 3',
      startTime: '12:00 PM',
      endTime: '01:15 PM',
    ),
    ClassSession(
      title: 'Computer Networks',
      instructor: 'Dr. Nadia Karim',
      room: 'Room 305',
      startTime: '03:00 PM',
      endTime: '04:15 PM',
    ),
  ];

  static const demoAssignments = [
    AssignmentItem(
      title: 'ER Diagram & SQL Queries',
      course: 'Database Systems',
      dueDate: 'Sep 30',
      priority: 'High',
      completed: false,
    ),
    AssignmentItem(
      title: 'Architecture Case Study',
      course: 'Software Engineering',
      dueDate: 'Oct 02',
      priority: 'Medium',
      completed: false,
    ),
    AssignmentItem(
      title: 'TCP/IP Lab Report',
      course: 'Computer Networks',
      dueDate: 'Oct 05',
      priority: 'Low',
      completed: true,
    ),
  ];

  static const demoNotices = [
    NoticeItem(
      title: 'Midterm examination schedule published',
      description: 'Check your department portal for the complete schedule.',
      category: 'Academic',
      date: 'Today',
      important: true,
    ),
    NoticeItem(
      title: 'Campus innovation week',
      description: 'Registration is now open for workshops and competitions.',
      category: 'Events',
      date: 'Sep 27',
      important: false,
    ),
    NoticeItem(
      title: 'Library hours extended',
      description: 'The central library will remain open until 10 PM.',
      category: 'Campus',
      date: 'Sep 25',
      important: false,
    ),
  ];
}
