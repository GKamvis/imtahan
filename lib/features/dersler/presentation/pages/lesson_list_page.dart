import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../cubit/lesson_list_cubit.dart';
import '../cubit/lesson_form_cubit.dart';
import '../../domain/entities/lesson.dart';
import 'lesson_form_page.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/lesson_remote_data_source.dart';
import '../../data/repositories/lesson_repository_impl.dart';
import '../../domain/repositories/lesson_repository.dart';

class LessonListPage extends StatefulWidget {
  const LessonListPage({super.key});

  @override
  State<LessonListPage> createState() => _LessonListPageState();
}

class _LessonListPageState extends State<LessonListPage> {
  late final LessonRepository _lessonRepository;

  @override
  void initState() {
    super.initState();
    // İlk açılışda dərsləri yüklə
    context.read<LessonListCubit>().loadLessons();

    final apiClient = ApiClient();
    final remote = LessonRemoteDataSourceImpl(apiClient);
    _lessonRepository = LessonRepositoryImpl(remote);
  }

  Future<void> _openCreateLessonForm() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => LessonFormCubit(repository: _lessonRepository),
          child: const LessonFormPage(),
        ),
      ),
    );

    if (result == true) {
      context.read<LessonListCubit>().loadLessons();
    }
  }

  Future<void> _openEditLessonForm(Lesson lesson) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => LessonFormCubit(
            repository: _lessonRepository,
            initialLesson: lesson,
          ),
          child: const LessonFormPage(),
        ),
      ),
    );

    if (result == true) {
      context.read<LessonListCubit>().loadLessons();
    }
  }

  Future<void> _deleteLesson(Lesson lesson) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Dərsi sil'),
        content: Text('${lesson.dersAdi} (${lesson.dersKodu}) silinsin?'),
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

    if (confirm == true) {
      try {
        await _lessonRepository.deleteLesson(lesson.dersKodu);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dərs silindi')),
        );
        context.read<LessonListCubit>().loadLessons();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Bu dərsə aid imtahanlar mövcuddur. Dərsi silmək mümkün olmadı.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dərslər'),
      ),
      body: BlocBuilder<LessonListCubit, LessonListState>(
        builder: (context, state) {
          switch (state.status) {
            case LessonListStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case LessonListStatus.failure:
              return Center(
                child: Text(state.errorMessage ?? 'Xəta baş verdi'),
              );
            case LessonListStatus.success:
              if (state.lessons.isEmpty) {
                return const Center(child: Text('Dərs yoxdur'));
              }
              return RefreshIndicator(
                onRefresh: () =>
                    context.read<LessonListCubit>().loadLessons(),
                child: ListView.separated(
                  itemCount: state.lessons.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, index) {
                    final Lesson l = state.lessons[index];
                    final muellim =
                    '${l.muellimAdi} ${l.muellimSoyadi}'.trim();

                    return Slidable(
                      key: ValueKey(l.dersKodu),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) => _deleteLesson(l),
                            icon: Icons.delete,
                            label: 'Sil',
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            l.dersKodu,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                        title: Text(l.dersAdi),
                        subtitle: Text(
                          'Sinif: ${l.sinif} · Müəllim: $muellim',
                        ),
                        onTap: () => _openEditLessonForm(l),
                      ),
                    );
                  },
                ),
              );
            case LessonListStatus.initial:
            default:
              return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateLessonForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
