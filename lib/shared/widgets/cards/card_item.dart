// lib/shared/widgets/cards/card_item.dart

import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final double cardSize;
  final double imageSize;
  final double fontSize;
  final String title;
  final String imagePath;

  const CardItem({
    super.key,
    required this.cardSize,
    required this.imageSize,
    required this.fontSize,
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardSize,
      height: cardSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage('assets/images/cards.png'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: imageSize,
            height: imageSize,
            fit: BoxFit.contain,
          ),
          SizedBox(height: cardSize * 0.05),
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  factory CardItem.fromJson(Map<String, dynamic> json) {
    return CardItem(
      cardSize: json['cardSize']?.toDouble() ?? 150.0,
      imageSize: json['imageSize']?.toDouble() ?? 60.0,
      fontSize: json['fontSize']?.toDouble() ?? 14.0,
      title: json['title'] ?? 'Untitled',
      imagePath: json['imagePath'] ?? 'assets/images/default.png',
    );
  }
}
