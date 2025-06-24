import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_care/profilescreen.dart';

class Pet {
  final String id;
  final String name;
  final Timestamp createdAt;

  Pet({required this.id, required this.name, required this.createdAt});

  factory Pet.fromDoc(DocumentSnapshot doc) {
    return Pet(
      id: doc.id,
      name: doc['name'],
      createdAt: doc['createdAt'],
    );
  }
}

class PetManagerScreen extends StatelessWidget {
  final Function(Pet) onPetSelected;
  const PetManagerScreen({super.key, required this.onPetSelected});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Center(child: Text('User not logged in'));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.account_circle),
          tooltip: 'Profile',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
        ),
        title: const Text('Your Pets'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('pets')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final pets =
              snapshot.data!.docs.map((doc) => Pet.fromDoc(doc)).toList();
          return ListView.builder(
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];
              return Card(
                child: ListTile(
                  title: Text(pet.name),
                  onTap: () => onPetSelected(pet),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
