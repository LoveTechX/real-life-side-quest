import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_service.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> setDocument({
    required String path,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    await FirebaseService.instance.initialize();
    await _firestore.doc(path).set(data, SetOptions(merge: merge));
  }

  Future<Map<String, dynamic>?> getDocument({required String path}) async {
    await FirebaseService.instance.initialize();
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
        .doc(path)
        .get();
    return snapshot.data();
  }

  Future<void> updateDocument({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    await FirebaseService.instance.initialize();
    await _firestore.doc(path).update(data);
  }

  Future<void> deleteDocument({required String path}) async {
    await FirebaseService.instance.initialize();
    await _firestore.doc(path).delete();
  }

  Future<String> addDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    await FirebaseService.instance.initialize();
    final DocumentReference<Map<String, dynamic>> ref = await _firestore
        .collection(collectionPath)
        .add(data);
    return ref.id;
  }

  Stream<List<Map<String, dynamic>>> watchCollection({
    required String collectionPath,
    String? orderByField,
    bool descending = false,
    int? limit,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(collectionPath);

    if (orderByField != null && orderByField.isNotEmpty) {
      query = query.orderBy(orderByField, descending: descending);
    }
    if (limit != null && limit > 0) {
      query = query.limit(limit);
    }

    return query.snapshots().map(
      (QuerySnapshot<Map<String, dynamic>> snapshot) => snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            return <String, dynamic>{'id': doc.id, ...doc.data()};
          })
          .toList(growable: false),
    );
  }
}
