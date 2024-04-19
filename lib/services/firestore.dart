import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get collection of collections
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  // CREATE: create new note

  Future<void> addNote(String note) {
    return notes.add({'note': note, 'timestamp': DateTime.now()});
  }

  // READ: get notes form docs

  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        notes.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
  }

  // UPDATE: update notes given the doc id
  Future<void> updateNotes(String docID, String newNote) {
    return notes
        .doc(docID)
        .update({'note': newNote, 'timestamp': DateTime.now()});
  }

  // DELETE: delete notes given the doc id
  Future<void> deleteNotes(String docID) {
    return notes.doc(docID).delete();
  }
}
