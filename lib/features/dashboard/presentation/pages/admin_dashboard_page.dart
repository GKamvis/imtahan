import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/api_config.dart';

// Repos
import '../../../../features/students/domain/repositories/student_repository.dart';
import '../../../../features/imtahanlar/domain/repositories/exam_repository.dart';
import '../../../../features/dersler/domain/repositories/lesson_repository.dart';

// Şagirdlər
import '../../../../features/students/presentation/cubit/student_list_cubit.dart';
import '../../../../features/students/presentation/pages/student_list_page.dart';

// İmtahanlar
import '../../../../features/imtahanlar/presentation/cubit/exam_list_cubit.dart';
import '../../../../features/imtahanlar/presentation/pages/exam_list_page.dart';

// Dərslər
import '../../../../features/dersler/presentation/cubit/lesson_list_cubit.dart';
import '../../../../features/dersler/presentation/pages/lesson_list_page.dart';

// Dashboard button
import '../widgets/dashboard_button.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final baseUrl = ApiConfig.baseUrl;

    final studentRepository = context.read<StudentRepository>();
    final examRepository = context.read<ExamRepository>();
    final lessonRepository = context.read<LessonRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('İdarə paneli'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 4 / 3,
                children: [
                  DashboardButton(
                    icon: Icons.person,
                    label: 'Şagirdlər',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) =>
                                StudentListCubit(studentRepository),
                            child: const StudentListPage(),
                          ),
                        ),
                      );
                    },
                  ),
                  DashboardButton(
                    icon: Icons.list_alt,
                    label: 'İmtahanlar',
                    color: Colors.green,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => ExamListCubit(examRepository),
                            child: const ExamListPage.all(),
                          ),
                        ),
                      );
                    },
                  ),
                  DashboardButton(
                    icon: Icons.book,
                    label: 'Dərslər',
                    color: Colors.orange,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => LessonListCubit(lessonRepository),
                            child: const LessonListPage(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
