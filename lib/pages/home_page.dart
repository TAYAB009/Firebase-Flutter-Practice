import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_all/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirestoreService firestoreService = FirestoreService();

  //--01 Add text controller

  TextEditingController notesController = TextEditingController();

  //--02: Open dialog box

  void openNoteDialog({String? docId}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: TextField(
            controller: notesController,
          ),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  if (docId == null) {
                    await firestoreService.addNote(notesController.text);
                  } else {
                    firestoreService.updateNotes(docId, notesController.text);
                  }
                  notesController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('Add'))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          // if we have data, get all notes
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                //--01: get each document
                DocumentSnapshot document = notesList[index];
                String docId = document.id;
                //--02: get note from each doc
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                return Card(
                  child: ListTile(
                    title: Text(data['note']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton.outlined(
                            onPressed: () {
                              openNoteDialog(docId: docId);
                            },
                            icon: const Icon(Icons.settings)),
                        IconButton.outlined(
                            onPressed: () {
                              firestoreService.deleteNotes(docId);
                            },
                            icon: const Icon(Icons.delete)),
                      ],
                    ),
                  ),
                );

                //--03: display in listtile
              },
            );
          } else {
            return const Center(
              child: Text('No Notes!'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openNoteDialog();
        },
        child: const Icon(
          Icons.add,
          size: 20.0,
        ),
      ),
    );
  }
}
