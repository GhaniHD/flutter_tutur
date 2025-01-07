import 'package:flutter/material.dart';
import '../../../data/models/album_item.dart';
import './album_item.dart';

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
