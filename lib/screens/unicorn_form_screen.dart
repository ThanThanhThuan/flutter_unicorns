// lib/screens/unicorn_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/unicorn_notifier.dart';
import '../models/unicorn.dart';

class UnicornFormScreen extends ConsumerStatefulWidget {
  final Unicorn? unicorn; // if null → create; otherwise update
  const UnicornFormScreen({this.unicorn, super.key});

  @override
  ConsumerState<UnicornFormScreen> createState() => _UnicornFormScreenState();
}

class _UnicornFormScreenState extends ConsumerState<UnicornFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name, _color;
  late int _age;

  @override
  void initState() {
    super.initState();
    _name = widget.unicorn?.name ?? '';
    _age = widget.unicorn?.age ?? 0;
    _color = widget.unicorn?.colour ?? 'blue';
  }

  @override
  Widget build(BuildContext context) {
    final isUpdate = widget.unicorn != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdate ? 'Edit Unicorn' : 'Create Unicorn'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                onSaved: (v) => _name = v!,
              ),
              TextFormField(
                initialValue: _age.toString(),
                decoration: const InputDecoration(labelText: 'Age'),
                validator: (v) {
                  final age = int.tryParse(v ?? '0');
                  return age == null || age <= 0 ? 'Required' : null;
                },
                onSaved: (v) => _age = int.parse(v!),
              ),
              TextFormField(
                initialValue: _color,
                decoration: const InputDecoration(labelText: 'Color (Name)'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                onSaved: (v) => _color = v!,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () async {
                  if (_formKey.currentState?.validate() != true) return;
                  _formKey.currentState?.save();
                  if (isUpdate) {
                    final u = Unicorn(
                      id: widget.unicorn!.id,
                      age: _age,
                      name: _name,
                      colour: _color,
                    );
                    await ref
                        .read(unicornNotifierProvider.notifier)
                        .updateUnicorn(u);
                  } else {
                    await ref
                        .read(unicornNotifierProvider.notifier)
                        .create(_name, _age, _color);
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
