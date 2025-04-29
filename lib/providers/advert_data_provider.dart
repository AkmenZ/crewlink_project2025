import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crewlink/models/advert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'advert_data_provider.g.dart';

@riverpod
Future<List<Advert>> adverts(Ref ref) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('adverts')
      .orderBy('date')
      .get();

  return snapshot.docs.map((doc) => Advert.fromFirestore(doc)).toList();
}
