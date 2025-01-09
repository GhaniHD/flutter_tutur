import 'package:flutter/material.dart';
import 'card_item.dart';

class CardGrid extends StatelessWidget {
  final List<CardItem> cardItems; // Mengambil cardItems dari luar

  const CardGrid({super.key, required this.cardItems});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        // Calculate responsive values
        final ResponsiveValues values = _getResponsiveValues(screenWidth);

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth >= 1200 ? 1200 : double.infinity,
            ),
            child: cardItems.isEmpty
                ? Center(
                    child: Text(
                      'Tidak ada kartu',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.all(values.padding),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: values.crossAxisCount,
                      childAspectRatio: 1,
                      crossAxisSpacing: values.spacing,
                      mainAxisSpacing: values.spacing,
                    ),
                    itemCount:
                        cardItems.length, // Menggunakan panjang cardItems
                    itemBuilder: (context, index) {
                      return cardItems[
                          index]; // Menampilkan CardItem sesuai data
                    },
                  ),
          ),
        );
      },
    );
  }

  ResponsiveValues _getResponsiveValues(double screenWidth) {
    // Desktop
    if (screenWidth >= 1200) {
      return ResponsiveValues(
        crossAxisCount: 6,
        padding: 24.0,
        spacing: 20.0,
        cardSize: 180.0,
        imageSize: 80.0,
        fontSize: 14.0,
      );
    }
    // Tablet Landscape
    else if (screenWidth >= 900) {
      return ResponsiveValues(
        crossAxisCount: 5,
        padding: 20.0,
        spacing: 16.0,
        cardSize: 160.0,
        imageSize: 70.0,
        fontSize: 13.0,
      );
    }
    // Tablet Portrait
    else if (screenWidth >= 600) {
      return ResponsiveValues(
        crossAxisCount: 4,
        padding: 16.0,
        spacing: 14.0,
        cardSize: 140.0,
        imageSize: 60.0,
        fontSize: 12.0,
      );
    }
    // Mobile
    return ResponsiveValues(
      crossAxisCount: 3,
      padding: 12.0,
      spacing: 12.0,
      cardSize: 120.0,
      imageSize: 50.0,
      fontSize: 11.0,
    );
  }
}

class ResponsiveValues {
  final int crossAxisCount;
  final double padding;
  final double spacing;
  final double cardSize;
  final double imageSize;
  final double fontSize;

  ResponsiveValues({
    required this.crossAxisCount,
    required this.padding,
    required this.spacing,
    required this.cardSize,
    required this.imageSize,
    required this.fontSize,
  });
}
