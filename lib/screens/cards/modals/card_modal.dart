// lib/presentation/widgets/modals/card_modal.dart

import 'package:flutter/material.dart';
import '../../../data/models/card_model_item.dart';

class CardModal extends StatelessWidget {
  final CardModalItem card;

  const CardModal({
    Key? key,
    required this.card,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Card View',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blue[400],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: card.picture != null
                    ? Image.network(
                        card.picture!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported,
                            size: 60,
                            color: Colors.white,
                          );
                        },
                      )
                    : const Icon(
                        Icons.image_not_supported,
                        size: 60,
                        color: Colors.white,
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              card.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            if (card.voice != null) // Only show button if voice URL exists
              ElevatedButton.icon(
                onPressed: () {
                  // Add audio playback functionality here
                  // You can use just_audio or audioplayers package
                },
                icon: const Icon(Icons.volume_up),
                label: const Text('Dengarkan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ejaan:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  card.spelling,
                  style: const TextStyle(
                    fontSize: 18,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
