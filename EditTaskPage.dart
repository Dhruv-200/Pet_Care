import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'PetManagerScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditTaskPage extends StatefulWidget {
  final Pet selectedPet;
  final String taskId;
  final Map<String, dynamic> taskData;
  const EditTaskPage(
      {super.key,
      required this.selectedPet,
      required this.taskId,
      required this.taskData});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late String _type;
  DateTime? _dateTime;
  late TextEditingController _notesController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _type = widget.taskData['type'] ?? 'Feeding';
    _dateTime = (widget.taskData['dateTime'] as Timestamp?)?.toDate();
    _notesController =
        TextEditingController(text: widget.taskData['notes'] ?? '');
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _dateTime ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: _dateTime != null
          ? TimeOfDay.fromDateTime(_dateTime!)
          : TimeOfDay.now(),
    );
    if (time == null) return;
    setState(() {
      _dateTime =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate() || _dateTime == null) return;
    setState(() => _saving = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('pets')
        .doc(widget.selectedPet.id)
        .collection('tasks')
        .doc(widget.taskId)
        .update({
      'type': _type,
      'dateTime': Timestamp.fromDate(_dateTime!),
      'notes': _notesController.text,
    });
    setState(() => _saving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task updated successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(value: 'Feeding', child: Text('Feeding')),
                  DropdownMenuItem(
                      value: 'Vet', child: Text('Vet Appointment')),
                  DropdownMenuItem(
                      value: 'Medication', child: Text('Medication')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (val) => setState(() => _type = val ?? 'Feeding'),
                decoration: const InputDecoration(
                  labelText: 'Task Type',
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(_dateTime == null
                    ? 'Pick Date & Time'
                    : DateFormat('EEE, MMM d, yyyy – h:mm a')
                        .format(_dateTime!)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDateTime,
              ),
              if (_dateTime == null)
                const Padding(
                  padding: EdgeInsets.only(left: 12.0, top: 4),
                  child: Text('Please pick a date and time',
                      style: TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                ),
                maxLines: 3,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Please enter notes' : null,
              ),
              const SizedBox(height: 24),
              _saving
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Update Task'),
                      onPressed: _saveTask,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
