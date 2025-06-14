import 'package:flutter/material.dart';
import 'package:pet_care/AddTaskPage.dart';
import 'package:pet_care/TaskListPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _navigateToAppointments() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TaskListPage()),
    );
  }

  void _navigateToMedicationReminders() {
    // TODO: Implement actual medication reminders page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Medication Reminders feature coming soon!')),
    );
  }

  void _navigateToFeedingSchedule() {
    // TODO: Implement actual feeding schedule page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feeding Schedule feature coming soon!')),
    );
  }

  void _addNewSchedule() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Care Scheduler'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to Pet Care Scheduler!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(Icons.pets, color: Colors.teal),
                title: Text('Upcoming Pet Appointments'),
                subtitle: Text('No appointments scheduled.'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: _navigateToAppointments,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(Icons.medical_services, color: Colors.teal),
                title: Text('Medication Reminders'),
                subtitle: Text('No reminders set.'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: _navigateToMedicationReminders,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(Icons.fastfood, color: Colors.teal),
                title: Text('Feeding Schedule'),
                subtitle: Text('No feeding times set.'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: _navigateToFeedingSchedule,
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Add New Schedule'),
                onPressed: _addNewSchedule,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
