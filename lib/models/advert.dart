import 'package:cloud_firestore/cloud_firestore.dart';

class Advert {
  final String? id;
  final String? name;
  final DateTime? date;
  final String? url;
  final String? imgUrl;

  Advert({
    this.id,
    this.name,
    this.date,
    this.url,
    this.imgUrl,
  });

  factory Advert.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Advert(
      id: doc.id,
      name: data['name'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      url: data['url'] ?? '',
      imgUrl: data['imgUrl'] ?? '',
    );
  }
}