import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// Cubit + entity
import '../../../dersler/presentation/cubit/exam_form_cubit.dart';
import '../../../dersler/presentation/pages/exam_form_page.dart';
import '../cubit/exam_list_cubit.dart';
import '../../domain/entities/exam.dart';

// Form üçün lazım olanlar (yalnız CREATE üçün)
import '../../../students/data/datasources/student_remote_data_source.dart';
import '../../../students/data/repositories/student_repository_impl.dart';
import '../../../students/domain/repositories/student_repository.dart';

import '../../../dersler/data/datasources/lesson_remote_data_source.dart';
import '../../../dersler/data/repositories/lesson_repository_impl.dart';
import '../../../dersler/domain/repositories/lesson_repository.dart';

import '../../data/datasources/exam_remote_data_source.dart';
import '../../data/repositories/exam_repository_impl.dart';
import '../../domain/repositories/exam_repository.dart';

// İmtahan formu (yalnız əlavə etmək üçün)


import '../../../../core/network/api_client.dart';

enum ExamListMode { all, byStudent, byLesson }

class ExamListPage extends StatefulWidget {
  final ExamListMode mode;
  final int? sagirdNomresi;
  final String? dersKodu;

  const ExamListPage.all({super.key})
      : mode = ExamListMode.all,
        sagirdNomresi = null,
        dersKodu = null;

  const ExamListPage.byStudent({
    super.key,
    required int sagirdNomresi,
  })  : mode = ExamListMode.byStudent,
        sagirdNomresi = sagirdNomresi,
        dersKodu = null;

  const ExamListPage.byLesson({
    super.key,
    required String dersKodu,
  })  : mode = ExamListMode.byLesson,
        sagirdNomresi = null,
        dersKodu = dersKodu;

  @override
  State<ExamListPage> createState() => _ExamListPageState();
}

class _ExamListPageState extends State<ExamListPage> {
  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final cubit = context.read<ExamListCubit>();
    switch (widget.mode) {
      case ExamListMode.all:
        await cubit.loadAll();
        break;
      case ExamListMode.byStudent:
        await cubit.loadByStudent(widget.sagirdNomresi!);
        break;
      case ExamListMode.byLesson:
        await cubit.loadByLesson(widget.dersKodu!);
        break;
    }
  }

  /// Yeni imtahan əlavə etmək üçün formu aç
  Future<void> _openCreateExam() async {
    final apiClient = ApiClient();

    final StudentRepository studentRepository =
    StudentRepositoryImpl(StudentRemoteDataSourceImpl(apiClient));

    final LessonRepository lessonRepository =
    LessonRepositoryImpl(LessonRemoteDataSourceImpl(apiClient));

    final ExamRepository examRepository =
    ExamRepositoryImpl(ExamRemoteDataSourceImpl(apiClient));

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => ExamFormCubit(
            examRepository: examRepository,
            studentRepository: studentRepository,
            lessonRepository: lessonRepository,
            // initialExam YOXDUR → create mode
          ),
          child: const ExamFormPage(),
        ),
      ),
    );

    if (result == true) {
      await _reload();
    }
  }

  Future<void> _deleteExam(Exam exam) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('İmtahanı sil'),
        content: Text(
          '${exam.dersAdi ?? exam.dersKodu} · Şagird №${exam.sagirdNomresi} (${exam.qiymet}) silinsin?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Ləğv et'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final examRepository = context.read<ExamListCubit>().repository;
      await examRepository.deleteExam(exam.id);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İmtahan silindi')),
      );

      await _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silinmə xətası: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = 'İmtahanlar';
    if (widget.mode == ExamListMode.byStudent) {
      title = 'Şagird imtahanları';
    } else if (widget.mode == ExamListMode.byLesson) {
      title = 'Dərs üzrə imtahanlar';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocBuilder<ExamListCubit, ExamListState>(
        builder: (context, state) {
          switch (state.status) {
            case ExamListStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case ExamListStatus.failure:
              return Center(
                child: Text(state.errorMessage ?? 'Xəta baş verdi'),
              );
            case ExamListStatus.success:
              if (state.exams.isEmpty) {
                return const Center(child: Text('İmtahan tapılmadı'));
              }
              return RefreshIndicator(
                onRefresh: _reload,
                child: ListView.separated(
                  itemCount: state.exams.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, index) {
                    final Exam exam = state.exams[index];

                    final studentText = (exam.sagirdAdi != null &&
                        exam.sagirdSoyadi != null)
                        ? '${exam.sagirdAdi} ${exam.sagirdSoyadi} (№${exam.sagirdNomresi})'
                        : 'Şagird №${exam.sagirdNomresi}';

                    final lessonText = (exam.dersAdi != null &&
                        exam.dersAdi!.isNotEmpty)
                        ? '${exam.dersAdi} (${exam.dersKodu})'
                        : exam.dersKodu;

                    final dateText =
                        '${exam.imtahanTarixi.day.toString().padLeft(2, '0')}.${exam.imtahanTarixi.month.toString().padLeft(2, '0')}.${exam.imtahanTarixi.year}';

                    return Slidable(
                      key: ValueKey(exam.id),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) => _deleteExam(exam),
                            icon: Icons.delete,
                            label: 'Sil',
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(studentText),
                        subtitle: Text('$lessonText · $dateText'),
                        trailing: CircleAvatar(
                          radius: 16,
                          child: Text(
                            exam.qiymet.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            case ExamListStatus.initial:
            default:
              return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateExam,
        child: const Icon(Icons.add),
      ),
    );
  }
}
