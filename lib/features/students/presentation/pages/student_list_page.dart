import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../cubit/student_list_cubit.dart';
import '../../domain/entities/student.dart';

import '../../data/datasources/student_remote_data_source.dart';
import '../../data/repositories/student_repository_impl.dart';
import '../../domain/repositories/student_repository.dart';

import '../cubit/student_form_cubit.dart';
import 'student_form_page.dart';

import '../../../../core/network/api_client.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  late final StudentRepository _studentRepository;

  @override
  void initState() {
    super.initState();
    final apiClient = ApiClient();
    final remote = StudentRemoteDataSourceImpl(apiClient);
    _studentRepository = StudentRepositoryImpl(remote);

    context.read<StudentListCubit>().loadStudents();
  }

  Future<void> _reload() async {
    await context.read<StudentListCubit>().loadStudents();
  }

  Future<void> _openCreateStudent() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => StudentFormCubit(repository: _studentRepository),
          child: const StudentFormPage(),
        ),
      ),
    );

    if (result == true) {
      await _reload();
    }
  }

  Future<void> _openEditStudent(Student student) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => StudentFormCubit(
            repository: _studentRepository,
            initialStudent: student,
          ),
          child: const StudentFormPage(),
        ),
      ),
    );

    if (result == true) {
      await _reload();
    }
  }

  Future<void> _deleteStudent(Student student) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Şagirdi sil'),
        content: Text(
          '${student.adi} ${student.soyadi} (№${student.nomre}) silinsin?',
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
      await _studentRepository.deleteStudent(student.nomre);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şagird silindi')),
      );

      await _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şagirdlər'),
      ),
      body: BlocBuilder<StudentListCubit, StudentListState>(
        builder: (context, state) {
          switch (state.status) {
            case StudentListStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case StudentListStatus.failure:
              return Center(
                child: Text(state.errorMessage ?? 'Xəta baş verdi'),
              );
            case StudentListStatus.success:
              if (state.students.isEmpty) {
                return const Center(child: Text('Şagird yoxdur'));
              }
              return RefreshIndicator(
                onRefresh: _reload,
                child: ListView.separated(
                  itemCount: state.students.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, index) {
                    final Student s = state.students[index];

                    return Slidable(
                      key: ValueKey(s.nomre),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) => _openEditStudent(s),
                            icon: Icons.edit,
                            label: 'Yenilə',
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          SlidableAction(
                            onPressed: (_) => _deleteStudent(s),
                            icon: Icons.delete,
                            label: 'Sil',
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ],
                      ),
                      child: ListTile(
                        onTap: () => _openEditStudent(s),
                        title: Text('${s.adi} ${s.soyadi}'),
                        subtitle: Text('№ ${s.nomre} · Sinif: ${s.sinif}'),
                      ),
                    );
                  },
                ),
              );
            case StudentListStatus.initial:
            default:
              return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateStudent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
