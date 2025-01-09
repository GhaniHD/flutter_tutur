import 'package:flutter/material.dart';
import '../../../data/models/album_item.dart';
import '../../../core/api/api_provider.dart';

class AlbumItemWidget extends StatelessWidget {
  final AlbumItem album;

  const AlbumItemWidget({super.key, required this.album});
  

  String? _getImageUrl(String? picturePath) {
    if (picturePath == null) return null;

    if (picturePath.startsWith('https://storage.googleapis.com')) {
      return picturePath;
    }

    if (picturePath.startsWith('http://') ||
        picturePath.startsWith('https://')) {
      return picturePath;
    }

    final baseUrl = ApiProvider().dio.options.baseUrl.replaceAll('/api', '');
    final fullUrl = '$baseUrl$picturePath' '/';
    return fullUrl;
  }

  Widget _buildImageWidget(double size, String? imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl ?? '',
        width: size,
        height: size,
        fit: BoxFit.cover,
        headers: const {'Access-Control-Allow-Origin': '*'},
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            width: size,
            height: size,
            child: const Icon(Icons.image, size: 40, color: Colors.grey),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/cardscreen', arguments: album);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          double imageSize;
          double fontSize;

          if (constraints.maxWidth < 600) {
            imageSize = 80.0;
            fontSize = 18.0;
          } else if (constraints.maxWidth < 900) {
            imageSize = 120.0;
            fontSize = 24.0;
          } else {
            imageSize = 150.0;
            fontSize = 28.0;
          }

          return Container(
            decoration: BoxDecoration(
              color:
                  Colors.primaries[album.id % Colors.primaries.length].shade200,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 4),
                  blurRadius: 6,
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.pushNamed(context, '/cardscreen', arguments: album);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: imageSize,
                      height: imageSize,
                      child: _buildImageWidget(
                          imageSize, _getImageUrl(album.picture)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        album.name,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
