// ignore_for_file: prefer_final_fields, unused_field

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'PetManagerScreen.dart';
import 'EditTaskPage.dart';

class TaskListPage extends StatefulWidget {
  final Pet selectedPet;
  const TaskListPage({super.key, required this.selectedPet});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final user = FirebaseAuth.instance.currentUser;
  int _selectedTab = 0; // 0: Upcoming, 1: History

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(child: Text('Not logged in'));
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tasks for ${widget.selectedPet.name}'),
          bottom: const TabBar(
            tabs: [
              Tab(
                  child:
                      Text('Upcoming', style: TextStyle(color: Colors.white))),
              Tab(
                  child:
                      Text('History', style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTaskList('pending'),
            _buildTaskList('done'),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('pets')
          .doc(widget.selectedPet.id)
          .collection('tasks')
          .where('status', isEqualTo: status)
          // Removed .orderBy('dateTime')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(status == 'pending'
                ? 'No upcoming tasks.'
                : 'No completed tasks.'),
          );
        }

        final tasks = snapshot.data!.docs;

        // ✅ Sort locally by dateTime
        tasks.sort((a, b) {
          final aDate = (a['dateTime'] as Timestamp?)?.toDate();
          final bDate = (b['dateTime'] as Timestamp?)?.toDate();
          return (aDate ?? DateTime(0)).compareTo(bDate ?? DateTime(0));
        });

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            final data = task.data() as Map<String, dynamic>;
            final dateTime = (data['dateTime'] as Timestamp?)?.toDate();
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                leading: Icon(_iconForType(data['type'])),
                title: Text(data['type'] ?? 'Task'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (dateTime != null)
                      Text(DateFormat('EEE, MMM d, yyyy – h:mm a')
                          .format(dateTime)),
                    if (data['notes'] != null &&
                        data['notes'].toString().isNotEmpty)
                      Text(data['notes']),
                  ],
                ),
                trailing: status == 'pending'
                    ? PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'complete') _markComplete(task.id);
                          if (value == 'edit') _editTask(task.id, data);
                          if (value == 'delete') _deleteTask(task.id);
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                              value: 'complete', child: Text('Complete')),
                          const PopupMenuItem(
                              value: 'edit', child: Text('Edit')),
                          const PopupMenuItem(
                              value: 'delete', child: Text('Delete')),
                        ],
                      )
                    : IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Delete Task',
                        onPressed: () => _deleteTask(task.id),
                      ),
              ),
            );
          },
        );
      },
    );
  }

  IconData _iconForType(String? type) {
    switch (type) {
      case 'Feeding':
        return Icons.fastfood;
      case 'Vet':
        return Icons.pets;
      case 'Medication':
        return Icons.medical_services;
      default:
        return Icons.event_note;
    }
  }

  void _markComplete(String taskId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('pets')
        .doc(widget.selectedPet.id)
        .collection('tasks')
        .doc(taskId)
        .update({'status': 'done'});
  }

  void _editTask(String taskId, Map<String, dynamic> data) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskPage(
          selectedPet: widget.selectedPet,
          taskId: taskId,
          taskData: data,
        ),
      ),
    );
    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task edited successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _deleteTask(String taskId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('pets')
          .doc(widget.selectedPet.id)
          .collection('tasks')
          .doc(taskId)
          .delete();
    }
  }
}
