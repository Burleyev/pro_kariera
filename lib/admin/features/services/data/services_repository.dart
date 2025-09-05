import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pro_kariera/admin/schared/services/firestore_paths.dart';
import '../domain/service_model.dart';

class ServicesRepository {
  final _db = FirebaseFirestore.instance;

  Stream<List<ServiceModel>> watch() => _db
      .collection(FP.services)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (s) => s.docs.map((d) => ServiceModel.fromMap(d.id, d.data())).toList(),
      );

  Future<void> create(ServiceModel s) => _db.collection(FP.services).add({
    ...s.toMap(),
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  });

  Future<void> update(String id, Map<String, dynamic> data) => _db
      .collection(FP.services)
      .doc(id)
      .update({...data, 'updatedAt': FieldValue.serverTimestamp()});

  Future<void> toggleActive(String id, bool v) => update(id, {'active': v});
}
