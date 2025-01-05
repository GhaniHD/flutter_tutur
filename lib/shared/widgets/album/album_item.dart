import 'package:flutter/material.dart';
import '../../../data/models/album_item.dart';

class AlbumItemWidget extends StatelessWidget {
  final AlbumItem album;

  const AlbumItemWidget({
    super.key,
    required this.album,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/cardscreen',
          arguments: album,
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
