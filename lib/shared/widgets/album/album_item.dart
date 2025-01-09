import 'package:flutter/material.dart';
import '../../../data/models/album_item.dart';
import '../../../core/api/api_provider.dart';

class AlbumItemWidget extends StatelessWidget {
  final AlbumItem album;

  const AlbumItemWidget({
    super.key,
    required this.album,
  });

  String? _getImageUrl(String? picturePath) {
    if (picturePath == null) return null;

    // Jika URL sudah dari Google Cloud Storage, gunakan langsung
    if (picturePath.startsWith('https://storage.googleapis.com')) {
      debugPrint('Using GCS URL directly: $picturePath');
      return picturePath;
    }

    // Jika URL dimulai dengan http atau https, gunakan langsung
    if (picturePath.startsWith('http://') ||
        picturePath.startsWith('https://')) {
      debugPrint('Using full URL directly: $picturePath');
      return picturePath;
    }

    // Untuk URL relatif, tambahkan base URL
    final baseUrl = ApiProvider().dio.options.baseUrl.replaceAll('/api', '');
    final fullUrl = '$baseUrl$picturePath' '/';
    debugPrint('Constructed URL: $fullUrl');
    return fullUrl;
  }

  Widget _buildImageWidget(double imageSize, String? imageUrl) {
    if (imageUrl == null) {
      return Container(
        color: Colors.grey[200],
        child: Icon(
          Icons.photo_library,
          size: imageSize * 0.5,
          color: Colors.grey[400],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        // Tambahkan headers untuk CORS jika diperlukan
        headers: const {
          'Access-Control-Allow-Origin': '*',
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error loading image from $imageUrl: $error');
          debugPrint('Stack trace: $stackTrace');
          return Container(
            color: Colors.grey[200],
            child: Icon(
              Icons.image_not_supported,
              size: imageSize * 0.5,
              color: Colors.grey[400],
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            debugPrint('Image loaded successfully from: $imageUrl');
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

  Widget _buildAlbumContent(BuildContext context, double size) {
    final imageSize = size * 0.5;
    final fontSize = size * 0.11;

    return Transform.translate(
      offset: Offset(-size * 0.02, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: size * 0.09),
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: _buildImageWidget(imageSize, _getImageUrl(album.picture)),
          ),
          SizedBox(height: size * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size * 0.1),
            child: Text(
              album.name,
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
  }

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
                return _buildAlbumContent(context, constraints.maxWidth);
              },
            ),
          ),
        ],
      ),
    );
  }
}
