import 'package:flutter/material.dart';

import '../../../data/models/quest_model.dart';
import '../controller/quest_controller.dart';

class AddQuestScreen extends StatefulWidget {
  const AddQuestScreen({super.key, required this.controller});

  final QuestController controller;

  @override
  State<AddQuestScreen> createState() => _AddQuestScreenState();
}

class _AddQuestScreenState extends State<AddQuestScreen> {
  static const double _fieldGap = 16;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _xpController = TextEditingController(text: '50');
  QuestType _selectedType = QuestType.daily;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _xpController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final bool success = await widget.controller.addQuest(
      title: _titleController.text,
      description: _descriptionController.text,
      xpReward: int.parse(_xpController.text),
      type: _selectedType,
    );

    if (!mounted) {
      return;
    }
    if (success) {
      Navigator.of(context).pop();
      return;
    }

    final String message =
        widget.controller.errorMessage ?? 'Unable to create quest.';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Quest')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: _fieldGap),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: _fieldGap),
              TextFormField(
                controller: _xpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'XP Reward'),
                validator: (value) {
                  final int? parsed = int.tryParse(value ?? '');
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a valid positive XP value';
                  }
                  return null;
                },
              ),
              const SizedBox(height: _fieldGap),
              DropdownButtonFormField<QuestType>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Quest Type'),
                items: QuestType.values
                    .map(
                      (QuestType type) => DropdownMenuItem<QuestType>(
                        value: type,
                        child: Text(type.name),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (QuestType? value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedType = value;
                  });
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: widget.controller.isLoading ? null : _save,
                  child: const Text('Create Quest'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
