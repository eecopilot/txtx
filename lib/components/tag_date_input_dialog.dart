// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tx_tx/models/home_list_notifier.dart';

class TagDateInputDialog extends ConsumerStatefulWidget {
  const TagDateInputDialog({super.key});
  @override
  _TagDateInputDialogState createState() => _TagDateInputDialogState();
}

class _TagDateInputDialogState extends ConsumerState<TagDateInputDialog> {
  final _tagController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String title = '';
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeListNotifier = ref.watch(homeListProvider.notifier);
    return AlertDialog(
      title: const Text('添加标签和日期'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _tagController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入标题';
                }
                return null;
              },
              onSaved: (value) {
                title = value!;
              },
              decoration: const InputDecoration(
                labelText: '标签',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('选择日期: ${_selectedDate.toString().split(' ')[0]}'),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () {
            // 在此处理用户输入的数据
            final tag = _tagController.text;
            final date = _selectedDate;
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              homeListNotifier.addItem(tag, date);
              // print('标签: $tag, 日期: $date');
              Navigator.pop(context);
            }
          },
          child: const Text('确定'),
        ),
      ],
    );
  }
}
