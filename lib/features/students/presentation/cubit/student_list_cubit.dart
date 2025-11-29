import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';

part 'student_list_state.dart';

class StudentListCubit extends Cubit<StudentListState> {
  final StudentRepository repository;

  StudentListCubit(this.repository) : super(const StudentListState());

  Future<void> loadStudents() async {
    emit(state.copyWith(status: StudentListStatus.loading));

    try {
      final students = await repository.getStudents();
      emit(state.copyWith(
        status: StudentListStatus.success,
        students: students,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StudentListStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
