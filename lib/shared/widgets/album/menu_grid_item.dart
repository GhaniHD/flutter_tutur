import 'package:flutter/material.dart';
import '../../../data/models/album_item.dart';

class AlbumGridWidget extends StatelessWidget {
  final List<AlbumItem> albums;

  const AlbumGridWidget({
    Key? key,
    required this.albums,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double padding;
        double spacing;

        if (constraints.maxWidth > 1200) {
          crossAxisCount = 5;
          padding = 12;
          spacing = 12;
        } else if (constraints.maxWidth > 800) {
          crossAxisCount = 4;
          padding = 10;
          spacing = 10;
        } else {
          crossAxisCount = 3;
          padding = 8;
          spacing = 8;
        }

        return GridView.builder(
          padding: EdgeInsets.all(padding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.0,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
          ),
          itemCount: albums.length,
          itemBuilder: (context, index) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 120,
                maxHeight: 120,
              ),
              child: AlbumItemWidget(album: albums[index]),
            );
          },
        );
      },
    );
  }
}

class AlbumItemWidget extends StatelessWidget {
  final AlbumItem album;

  const AlbumItemWidget({
    Key? key,
    required this.album,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Image.asset(
          'assets/images/blue.png',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
        // Content
        Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = constraints.maxWidth;
              final imageSize = size * 0.5; // 50% dari container
              final fontSize = size * 0.11; // Ukuran font diperkecil

              return Transform.translate(
                offset: Offset(-size * 0.02, 0), // Geser ke kiri sedikit
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Adjusted for alignment
                  children: [
                    SizedBox(height: size * 0.09), // Space atas
                    Image.asset(
                      'assets/images/buah_buahan.png',
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                        height: size * 0.02), // Jarak antara gambar dan teks
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size * 0.1),
                      child: Text(
                        album.title,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold, // Sedikit lebih tipis
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
