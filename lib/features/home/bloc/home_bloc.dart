import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/campus_models.dart';
import '../../../data/repositories/campus_repository.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.profile,
    this.classes = const [],
    this.assignments = const [],
    this.notices = const [],
    this.errorMessage,
  });

  final HomeStatus status;
  final StudentProfile? profile;
  final List<ClassSession> classes;
  final List<AssignmentItem> assignments;
  final List<NoticeItem> notices;
  final String? errorMessage;

  @override
  List<Object?> get props =>
      [status, profile, classes, assignments, notices, errorMessage];
}

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeLoadRequested extends HomeEvent {
  const HomeLoadRequested({required this.uid});

  final String uid;

  @override
  List<Object?> get props => [uid];
}

class HomeDemoLoadRequested extends HomeEvent {
  const HomeDemoLoadRequested();
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._repository) : super(const HomeState()) {
    on<HomeLoadRequested>(_onLoad);
    on<HomeDemoLoadRequested>(_onDemoLoad);
  }

  final CampusRepository _repository;

  Future<void> _onLoad(
    HomeLoadRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeState(status: HomeStatus.loading));
    try {
      final results = await Future.wait([
        _repository.getProfile(event.uid),
        _repository.getClasses(event.uid),
        _repository.getAssignments(event.uid),
        _repository.getNotices(event.uid),
      ]);

      emit(HomeState(
        status: HomeStatus.success,
        profile: results[0] as StudentProfile,
        classes: results[1] as List<ClassSession>,
        assignments: results[2] as List<AssignmentItem>,
        notices: results[3] as List<NoticeItem>,
      ));
    } catch (_) {
      emit(const HomeState(
        status: HomeStatus.failure,
        errorMessage: 'Unable to load campus data.',
      ));
    }
  }

  Future<void> _onDemoLoad(
    HomeDemoLoadRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeState(status: HomeStatus.loading));
    await Future<void>.delayed(const Duration(milliseconds: 350));

    emit(HomeState(
      status: HomeStatus.success,
      profile: const StudentProfile(
        name: 'Aarav Rahman',
        studentId: 'MC-2026-0142',
        department: 'Computer Science & Engineering',
        semester: '5th Semester',
        email: 'aarav@mycampus.edu',
      ),
      classes: CampusRepository.demoClasses,
      assignments: CampusRepository.demoAssignments,
      notices: CampusRepository.demoNotices,
    ));
  }
}
