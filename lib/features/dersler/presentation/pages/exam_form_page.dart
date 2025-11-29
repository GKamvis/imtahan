import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dersler/domain/entities/lesson.dart';
import '../../../students/domain/entities/student.dart';
import '../cubit/exam_form_cubit.dart';

class ExamFormPage extends StatefulWidget {
  const ExamFormPage({super.key});

  @override
  State<ExamFormPage> createState() => _ExamFormPageState();
}

class _ExamFormPageState extends State<ExamFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _qiymetController = TextEditingController();

  @override
  void dispose() {
    _qiymetController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ExamFormCubit>().loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExamFormCubit, ExamFormState>(
      listener: (context, state) {
        if (state.status == ExamFormStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }

        if (state.status == ExamFormStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.isEditing ? 'İmtahan yeniləndi' : 'İmtahan əlavə olundu',
              ),
            ),
          );
          Navigator.of(context).pop(true); // geri qayıt və refresh üçün true
        }

        if (state.qiymet != null &&
            _qiymetController.text != state.qiymet.toString()) {
          _qiymetController.text = state.qiymet.toString();
        }
      },
      builder: (context, state) {
        final isLoading =
            state.status == ExamFormStatus.loading || state.status == ExamFormStatus.initial;
        final isSubmitting = state.status == ExamFormStatus.submitting;

        return Scaffold(
          appBar: AppBar(
            title: Text(state.isEditing ? 'İmtahanı redaktə et' : 'Yeni imtahan'),
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Dərs seçimi
                  DropdownButtonFormField<Lesson>(
                    decoration: const InputDecoration(
                      labelText: 'Dərs',
                      border: OutlineInputBorder(),
                    ),
                    value: state.selectedLesson,
                    items: state.lessons
                        .map(
                          (lesson) => DropdownMenuItem<Lesson>(
                        value: lesson,
                        child: Text(
                            '${lesson.dersAdi} (${lesson.dersKodu})'),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      context.read<ExamFormCubit>().changeLesson(value);
                    },
                    validator: (value) =>
                    value == null ? 'Dərs seçin' : null,
                  ),
                  const SizedBox(height: 16),

                  // Şagird seçimi
                  DropdownButtonFormField<Student>(
                    decoration: const InputDecoration(
                      labelText: 'Şagird',
                      border: OutlineInputBorder(),
                    ),
                    value: state.selectedStudent,
                    items: state.students
                        .map(
                          (student) => DropdownMenuItem<Student>(
                        value: student,
                        child: Text(
                            '${student.adi} ${student.soyadi} (№${student.nomre})'),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      context.read<ExamFormCubit>().changeStudent(value);
                    },
                    validator: (value) =>
                    value == null ? 'Şagird seçin' : null,
                  ),
                  const SizedBox(height: 16),

                  // Tarix seçimi
                  InkWell(
                    onTap: () async {
                      final now = DateTime.now();
                      final initialDate =
                          state.selectedDate ?? now;
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        context
                            .read<ExamFormCubit>()
                            .changeDate(picked);
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'İmtahan tarixi',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        state.selectedDate != null
                            ? '${state.selectedDate!.day.toString().padLeft(2, '0')}.${state.selectedDate!.month.toString().padLeft(2, '0')}.${state.selectedDate!.year}'
                            : 'Tarix seçin',
                        style: TextStyle(
                          color: state.selectedDate != null
                              ? null
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Qiymət
                  TextFormField(
                    controller: _qiymetController,
                    decoration: const InputDecoration(
                      labelText: 'Qiymət',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Qiymət daxil edin';
                      }
                      final q = int.tryParse(value);
                      if (q == null) return 'Yalnız rəqəm';
                      if (q < 1 || q > 10) {
                        return 'Qiymət 1–10 arası olmalıdır';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      final q = int.tryParse(value);
                      context.read<ExamFormCubit>().changeQiymet(q);
                    },
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () {
                        if (_formKey.currentState?.validate() ??
                            false) {
                          context
                              .read<ExamFormCubit>()
                              .submit();
                        }
                      },
                      child: isSubmitting
                          ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : Text(
                        state.isEditing
                            ? 'Yenilə'
                            : 'Əlavə et',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
