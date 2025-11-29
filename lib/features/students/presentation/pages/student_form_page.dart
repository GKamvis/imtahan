import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/student_form_cubit.dart';

class StudentFormPage extends StatefulWidget {
  const StudentFormPage({super.key});

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomreController = TextEditingController();
  final _adiController = TextEditingController();
  final _soyadiController = TextEditingController();
  final _sinifController = TextEditingController();

  @override
  void dispose() {
    _nomreController.dispose();
    _adiController.dispose();
    _soyadiController.dispose();
    _sinifController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final state = context.read<StudentFormCubit>().state;

    if (state.isEditing) {
      _nomreController.text = state.nomre ?? '';
      _adiController.text = state.adi ?? '';
      _soyadiController.text = state.soyadi ?? '';
      _sinifController.text = state.sinif ?? '';
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentFormCubit, StudentFormState>(
      listener: (context, state) {
        if (state.status == StudentFormStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }

        if (state.status == StudentFormStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.isEditing
                  ? "Şagird yeniləndi."
                  : "Şagird əlavə olundu."),
            ),
          );
          Navigator.pop(context, true);
        }
      },
      builder: (context, state) {
        final isSubmitting = state.status == StudentFormStatus.submitting;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              state.isEditing ? "Şagirdi yenilə" : "Yeni şagird əlavə et",
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nomreController,
                    decoration: const InputDecoration(
                      labelText: "Nömrə",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                    v == null || v.isEmpty ? "Nömrə daxil edin" : null,
                    onChanged: (v) =>
                        context.read<StudentFormCubit>().changeNomre(v),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _adiController,
                    decoration: const InputDecoration(
                      labelText: "Ad",
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                    v == null || v.isEmpty ? "Ad daxil edin" : null,
                    onChanged: (v) =>
                        context.read<StudentFormCubit>().changeAdi(v),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _soyadiController,
                    decoration: const InputDecoration(
                      labelText: "Soyad",
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                    v == null || v.isEmpty ? "Soyad daxil edin" : null,
                    onChanged: (v) =>
                        context.read<StudentFormCubit>().changeSoyadi(v),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _sinifController,
                    decoration: const InputDecoration(
                      labelText: "Sinif",
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                    v == null || v.isEmpty ? "Sinif daxil edin" : null,
                    keyboardType: TextInputType.number,
                    onChanged: (v) =>
                        context.read<StudentFormCubit>().changeSinif(v),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: isSubmitting
                        ? null
                        : () {
                      if (_formKey.currentState?.validate() ?? false) {
                        context.read<StudentFormCubit>().submit();
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
                        : Text(state.isEditing ? "Yenilə" : "Əlavə et"),
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
