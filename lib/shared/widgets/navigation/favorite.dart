import 'package:flutter/material.dart';
import '../../../data/models/favorite_item.dart';

class Favorite extends StatelessWidget {
  final List<FavoriteItem> favorites;

  const Favorite({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = MediaQuery.of(context).size.width;
          // Refined breakpoints
          final isDesktop = width >= 1200;
          final isLargeTablet = width >= 800 && width < 1200;
          final isSmallTablet = width >= 500 && width < 800;
          final isMobile = width < 500;

          // Dynamic sizing based on screen width
          final containerHeight = isDesktop
              ? 800.0
              : isLargeTablet
                  ? 750.0
                  : isSmallTablet
                      ? 650.0
                      : 600.0;

          final gridColumns = isDesktop
              ? 6
              : isLargeTablet
                  ? 4
                  : isSmallTablet
                      ? 4
                      : 3;

          final spacing = isDesktop
              ? 20.0
              : isLargeTablet
                  ? 16.0
                  : isSmallTablet
                      ? 12.0
                      : 8.0;

          return Container(
            width: double.infinity,
            height: containerHeight,
            constraints: BoxConstraints(
              maxHeight: containerHeight,
              maxWidth: isDesktop
                  ? 1200
                  : isLargeTablet
                      ? 1000
                      : double.infinity,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF87CEEB),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: isDesktop || isLargeTablet ? 16 : 8,
                  ),
                  child: Text(
                    'Favorit Kalimat Kartu',
                    style: TextStyle(
                      fontSize: isDesktop
                          ? 24
                          : isLargeTablet
                              ? 22
                              : isSmallTablet
                                  ? 18
                                  : 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                      spacing,
                      0,
                      spacing,
                      spacing,
                    ),
                    padding: EdgeInsets.all(spacing),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F8E2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: favorites.isEmpty
                        ? const SizedBox.expand()
                        : GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: gridColumns,
                              childAspectRatio: 1,
                              crossAxisSpacing: spacing,
                              mainAxisSpacing: spacing,
                            ),
                            itemCount: favorites.length,
                            itemBuilder: (context, index) {
                              return FavoriteItemWidget(
                                favorite: favorites[index],
                                screenWidth: width,
                              );
                            },
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: spacing),
                  child: SizedBox(
                    width: isDesktop
                        ? 150
                        : isLargeTablet
                            ? 130
                            : isSmallTablet
                                ? 110
                                : 100,
                    height: isDesktop
                        ? 48
                        : isLargeTablet
                            ? 44
                            : isSmallTablet
                                ? 40
                                : 36,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3F51B5),
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isDesktop
                                ? 24
                                : isLargeTablet
                                    ? 22
                                    : isSmallTablet
                                        ? 20
                                        : 18,
                          ),
                        ),
                      ),
                      child: Text(
                        'Tutup',
                        style: TextStyle(
                          fontSize: isDesktop
                              ? 18
                              : isLargeTablet
                                  ? 16
                                  : isSmallTablet
                                      ? 15
                                      : 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FavoriteItemWidget extends StatelessWidget {
  final FavoriteItem favorite;
  final double screenWidth;

  const FavoriteItemWidget({
    super.key,
    required this.favorite,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamic sizing based on screen width
    final isDesktop = screenWidth >= 1200;
    final isLargeTablet = screenWidth >= 800 && screenWidth < 1200;
    final isSmallTablet = screenWidth >= 500 && screenWidth < 800;

    final imageSize = isDesktop
        ? 90.0
        : isLargeTablet
            ? 85.0
            : isSmallTablet
                ? 65.0
                : screenWidth <= 360
                    ? 40.0
                    : 45.0;

    final fontSize = isDesktop
        ? 16.0
        : isLargeTablet
            ? 15.0
            : isSmallTablet
                ? 13.0
                : screenWidth <= 360
                    ? 9.0
                    : 10.0;

    final spacing = isDesktop || isLargeTablet
        ? 8.0
        : isSmallTablet
            ? 4.0
            : 2.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/blue.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  favorite.image,
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: spacing),
                Text(
                  favorite.title,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final List<FavoriteItem> favorites = List.generate(
  16, // Jumlah item yang diinginkan
  (index) => FavoriteItem(
    title: 'Buah-buahan',
    image: 'assets/images/buah_buahan.png',
  ),
);
