// lib/core/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_guide_app/core/constants/firebase_names.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // قراءة مستند واحد
  Future<DocumentSnapshot> getDocument(String collectionPath, String docId) {
    return _firestore.collection(collectionPath).doc(docId).get();
  }

  // قراءة مجموعة مع فلترة وترتيب
  Stream<QuerySnapshot> streamCollection(String collectionPath,
      {String? orderBy, bool descending = false, List<QueryFilter>? filters}) {
    Query query = _firestore.collection(collectionPath);
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }
    if (filters != null) {
      for (var filter in filters) {
        query = query.where(filter.field, isEqualTo: filter.value);
      }
    }
    return query.snapshots();
  }

  // إنشاء مستند (مع ID تلقائي)
  Future<DocumentReference> addDocument(String collectionPath, Map<String, dynamic> data) {
    return _firestore.collection(collectionPath).add(data);
  }

  // تحديث مستند
  Future<void> updateDocument(String collectionPath, String docId, Map<String, dynamic> data) {
    return _firestore.collection(collectionPath).doc(docId).update(data);
  }

  // حذف مستند
  Future<void> deleteDocument(String collectionPath, String docId) {
    return _firestore.collection(collectionPath).doc(docId).delete();
  }
}

class QueryFilter {
  final String field;
  final dynamic value;
  QueryFilter(this.field, this.value);
}
