import 'package:flutter/material.dart';
import '../../../data/models/album_item.dart';
import './album_item.dart';

class AlbumGridWidget extends StatelessWidget {
  final List<AlbumItem> albums;

  const AlbumGridWidget({super.key, required this.albums});

  @override
  Widget build(BuildContext context) {
    print(albums); // Verifikasi data yang diterima

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        double childAspectRatio = 3;

        if (constraints.maxWidth >= 600 && constraints.maxWidth < 900) {
          // Tablet
          crossAxisCount = 2;
          childAspectRatio = 2;
        } else if (constraints.maxWidth >= 900 && constraints.maxWidth < 1024) {
          // Desktop kecil
          crossAxisCount = 3;
          childAspectRatio = 1.5;
        } else if (constraints.maxWidth >= 1024) {
          // Desktop besar
          crossAxisCount = 4;
          childAspectRatio = 1.5;
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: albums.length,
          itemBuilder: (context, index) {
            return AlbumItemWidget(album: albums[index]);
          },
        );
      },
    );
  }
}
