import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_care/LoginScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;

  Future<Map<String, dynamic>?> _getUserData() async {
    if (user == null) return null;

    final uid = user!.uid;
    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final doc = await docRef.get();

    if (!doc.exists) return null;
    return doc.data();
  }

  Future<void> _addPetDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Pet'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Pet Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('pets')
          .add({'name': result, 'createdAt': Timestamp.now()});
    }
  }

  Future<void> _deletePet(String petId) async {
    if (user == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('pets')
        .doc(petId)
        .delete();
  }

  Widget buildProfilePicture(String? photoUrl, {String? name}) {
    String? initial;
    if (name != null && name.isNotEmpty) {
      initial = name[0].toUpperCase();
    }
    return Center(
      child: CircleAvatar(
        radius: 48,
        backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
            ? NetworkImage(photoUrl)
            : null,
        child: (photoUrl == null || photoUrl.isEmpty)
            ? Text(
                initial ?? '',
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              )
            : null,
      ),
    );
  }

  Widget buildBox(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Not logged in")),
      );
    }

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: theme.appBarTheme.backgroundColor,
          foregroundColor: theme.appBarTheme.foregroundColor,
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<Map<String, dynamic>?>(
                future: _getUserData(),
                builder: (context, snapshot) {
                  final profileWidgets = <Widget>[
                    if (snapshot.connectionState == ConnectionState.waiting)
                      const Center(child: CircularProgressIndicator())
                    else if (!snapshot.hasData || snapshot.data == null)
                      buildBox("Email", user!.email ?? "Unknown email")
                    else ...[
                      buildProfilePicture(
                        snapshot.data!['photoUrl'],
                        name: snapshot.data!['Name'],
                      ),
                      const SizedBox(height: 16),
                      buildBox("Name", snapshot.data!['Name'] ?? 'N/A'),
                      buildBox("Email",
                          snapshot.data!['Email'] ?? user!.email ?? 'N/A'),
                      buildBox("Mobile", snapshot.data!['Mobile'] ?? 'N/A'),
                    ],
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Your Pets',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _addPetDialog,
                        ),
                      ],
                    ),
                  ];

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ...profileWidgets,
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(user!.uid)
                                .collection('pets')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Center(
                                    child: Text('No pets found.'));
                              }
                              final pets = snapshot.data!.docs;
                              return ListView.builder(
                                itemCount: pets.length,
                                itemBuilder: (context, index) {
                                  final pet = pets[index];
                                  final data =
                                      pet.data() as Map<String, dynamic>;
                                  return ListTile(
                                    leading: Icon(Icons.pets,
                                        color: theme.iconTheme.color),
                                    title: Text(data['name'] ?? 'Unnamed Pet'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () => _deletePet(pet.id),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (val) => false,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
