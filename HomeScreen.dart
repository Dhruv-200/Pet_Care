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
    final theme = Theme.of(context);
    if (selectedPet == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome, ${selectedPet!.name}!'),
          backgroundColor: theme.appBarTheme.backgroundColor,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration:
                    BoxDecoration(color: theme.appBarTheme.backgroundColor),
                child: const Text('Menu',
                    style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(
                leading: Icon(Icons.person, color: theme.iconTheme.color),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToProfile();
                },
              ),
              ListTile(
                leading: Icon(Icons.pets, color: theme.iconTheme.color),
                title: const Text('Change Pet'),
                onTap: () {
                  Navigator.pop(context);
                  _selectPet();
                },
              ),
              ListTile(
                leading: Icon(Icons.logout, color: theme.iconTheme.color),
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
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Card(
                elevation: theme.cardTheme.elevation,
                shape: theme.cardTheme.shape,
                child: ListTile(
                  leading: Icon(Icons.pets, color: theme.iconTheme.color),
                  title: const Text('Upcoming Pet Appointments'),
                  subtitle: const Text('Tap to view or add appointments'),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: theme.iconTheme.color),
                  onTap: _navigateToAppointments,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: theme.cardTheme.elevation,
                shape: theme.cardTheme.shape,
                child: ListTile(
                  leading: Icon(Icons.medical_services,
                      color: theme.iconTheme.color),
                  title: const Text('Medication Reminders'),
                  subtitle: const Text('No reminders set.'),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: theme.iconTheme.color),
                  onTap: _navigateToMedicationReminders,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: theme.cardTheme.elevation,
                shape: theme.cardTheme.shape,
                child: ListTile(
                  leading: Icon(Icons.fastfood, color: theme.iconTheme.color),
                  title: const Text('Feeding Schedule'),
                  subtitle: const Text('No feeding times set.'),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: theme.iconTheme.color),
                  onTap: _navigateToFeedingSchedule,
                ),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
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
      ),
    );
  }
}
