import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch subjects from Firestore matching the search query
  Future<List<String>> searchSubjects(String query) async {
    if (query.isEmpty) return [];

    QuerySnapshot snapshot = await _firestore
        .collection('subjects') // Adjust the collection name as needed
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: query + '\uf8ff')
        .get();

    return snapshot.docs.map((doc) => doc['name'].toString()).toList();
  }
}
