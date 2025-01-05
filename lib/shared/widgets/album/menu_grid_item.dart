import 'package:flutter/material.dart';
import '../../../data/models/album_item.dart';
import '../../../screens/cards/cards_screen.dart';

class AlbumGridWidget extends StatelessWidget {
  final List<AlbumItem> albums;

  const AlbumGridWidget({
    super.key,
    required this.albums,
  });

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
              constraints: const BoxConstraints(
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
    super.key,
    required this.album,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Add GestureDetector to handle taps
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CardsScreen(album: album), // Pass the album to CardsScreen
          ),
        );
      },
      child: Stack(
        children: [
          Image.asset(
            'assets/images/blue.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.maxWidth;
                final imageSize = size * 0.5;
                final fontSize = size * 0.11;

                return Transform.translate(
                  offset: Offset(-size * 0.02, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: size * 0.09),
                      Image.asset(
                        'assets/images/buah_buahan.png',
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: size * 0.02),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: size * 0.1),
                        child: Text(
                          album.title,
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
