import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_care/AddTaskPage.dart';
import 'package:pet_care/PetManagerScreen.dart';
import 'package:pet_care/Tasklistpage.dart';
import 'package:pet_care/profilescreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Pet? selectedPet;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectPet();
    });
  }

  void _selectPet() async {
    final pet = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PetManagerScreen(
          onPetSelected: (pet) {
            Navigator.pop(context, pet);
          },
        ),
      ),
    );
    if (pet != null && mounted) {
      setState(() {
        selectedPet = pet;
      });
    }
  }

  void _navigateToAppointments() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskListPage(selectedPet: selectedPet!),
      ),
    );
  }

  void _navigateToMedicationReminders() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Medication Reminders feature coming soon!')),
    );
  }

  void _navigateToFeedingSchedule() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feeding Schedule feature coming soon!')),
    );
  }

  void _addNewSchedule() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskPage(selectedPet: selectedPet!),
      ),
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    if (selectedPet == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${selectedPet!.name}!'),
        backgroundColor: Colors.teal,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                _navigateToProfile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.pets),
              title: const Text('Change Pet'),
              onTap: () {
                Navigator.pop(context);
                _selectPet();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                _logout();
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Pet Care Scheduler!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.pets, color: Colors.teal),
                title: const Text('Upcoming Pet Appointments'),
                subtitle: const Text('Tap to view or add appointments'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: _navigateToAppointments,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.medical_services, color: Colors.teal),
                title: const Text('Medication Reminders'),
                subtitle: const Text('No reminders set.'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: _navigateToMedicationReminders,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.fastfood, color: Colors.teal),
                title: const Text('Feeding Schedule'),
                subtitle: const Text('No feeding times set.'),
                trailing: const Icon(Icons.arrow_forward_ios),
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
