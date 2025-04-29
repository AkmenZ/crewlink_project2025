import 'package:crewlink/models/advert.dart';
import 'package:flutter/material.dart';

class AdvertCard extends StatelessWidget {
  const AdvertCard({
    super.key,
    required this.advert,
  });

  final Advert advert;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Image.network(
              advert.imgUrl ?? '',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.error)),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  advert.name ?? 'Unknown',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
