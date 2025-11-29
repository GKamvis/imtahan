import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/lesson_form_cubit.dart';

class LessonFormPage extends StatefulWidget {
  const LessonFormPage({super.key});

  @override
  State<LessonFormPage> createState() => _LessonFormPageState();
}

class _LessonFormPageState extends State<LessonFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _dersKoduController = TextEditingController();
  final _dersAdiController = TextEditingController();
  final _sinifController = TextEditingController();
  final _muellimAdiController = TextEditingController();
  final _muellimSoyadiController = TextEditingController();

  @override
  void dispose() {
    _dersKoduController.dispose();
    _dersAdiController.dispose();
    _sinifController.dispose();
    _muellimAdiController.dispose();
    _muellimSoyadiController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final state = context.read<LessonFormCubit>().state;
    if (state.isEditing) {
      _dersKoduController.text = state.dersKodu ?? '';
      _dersAdiController.text = state.dersAdi ?? '';
      _sinifController.text = state.sinif ?? '';
      _muellimAdiController.text = state.muellimAdi ?? '';
      _muellimSoyadiController.text = state.muellimSoyadi ?? '';
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LessonFormCubit, LessonFormState>(
      listener: (context, state) {
        if (state.status == LessonFormStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }

        if (state.status == LessonFormStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.isEditing ? 'Dərs yeniləndi.' : 'Dərs əlavə olundu.',
              ),
            ),
          );
          Navigator.pop(context, true);
        }
      },
      builder: (context, state) {
        final isSubmitting = state.status == LessonFormStatus.submitting;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              state.isEditing ? 'Dərsi yenilə' : 'Yeni dərs əlavə et',
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _dersKoduController,
                    decoration: const InputDecoration(
                      labelText: 'Dərs kodu (məs: MAT)',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.characters,
                    validator: (v) =>
                    v == null || v.isEmpty ? 'Dərs kodu daxil edin' : null,
                    onChanged: (v) =>
                        context.read<LessonFormCubit>().changeDersKodu(v),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _dersAdiController,
                    decoration: const InputDecoration(
                      labelText: 'Dərs adı',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                    v == null || v.isEmpty ? 'Dərs adı daxil edin' : null,
                    onChanged: (v) =>
                        context.read<LessonFormCubit>().changeDersAdi(v),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _sinifController,
                    decoration: const InputDecoration(
                      labelText: 'Sinif',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                    v == null || v.isEmpty ? 'Sinif daxil edin' : null,
                    onChanged: (v) =>
                        context.read<LessonFormCubit>().changeSinif(v),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _muellimAdiController,
                    decoration: const InputDecoration(
                      labelText: 'Müəllim adı',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) =>
                        context.read<LessonFormCubit>().changeMuellimAdi(v),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _muellimSoyadiController,
                    decoration: const InputDecoration(
                      labelText: 'Müəllim soyadı',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => context
                        .read<LessonFormCubit>()
                        .changeMuellimSoyadi(v),
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: isSubmitting
                        ? null
                        : () {
                      if (_formKey.currentState?.validate() ?? false) {
                        context.read<LessonFormCubit>().submit();
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
                        : Text(state.isEditing ? 'Yenilə' : 'Əlavə et'),
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
