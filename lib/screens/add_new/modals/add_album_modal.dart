import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:dio/dio.dart';
import '../../../core/api/api_provider.dart';

class AddAlbumModal extends StatefulWidget {
  const AddAlbumModal({super.key});

  @override
  State<AddAlbumModal> createState() => _AddAlbumModalState();
}

class _AddAlbumModalState extends State<AddAlbumModal> {
  Uint8List? _imageBytes;
  File? _imageFile;
  final _albumNameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final ApiProvider _apiProvider = ApiProvider();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeApi();
  }

  Future<void> _initializeApi() async {
    await _apiProvider.init(); // Initialize with dummy token
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        // Check file size
        final bytes = await pickedFile.readAsBytes();
        if (bytes.length > 2 * 1024 * 1024) {
          // 2MB in bytes
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Ukuran gambar maksimal 2MB")),
          );
          return;
        }

        if (kIsWeb) {
          setState(() {
            _imageBytes = bytes;
            _imageFile = null;
          });
        } else {
          setState(() {
            _imageFile = File(pickedFile.path);
            _imageBytes = null;
          });
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memilih gambar: ${e.toString()}")),
      );
    }
  }

  Future<void> _saveAlbum() async {
    if (_albumNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap isi nama album")),
      );
      return;
    }

    if (_albumNameController.text.length > 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama album maksimal 12 karakter")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (kIsWeb && _imageBytes != null) {
        // Handle web image upload
        FormData formData = FormData.fromMap({
          'name': _albumNameController.text,
          'picture': MultipartFile.fromBytes(
            _imageBytes!,
            filename: 'album_picture.jpg',
          ),
        });

        final response =
            await _apiProvider.postFormData('/album/add', formData);
        _handleSuccess(response);
      } else if (_imageFile != null) {
        // Handle mobile image upload
        FormData formData = FormData.fromMap({
          'name': _albumNameController.text,
          'picture': await MultipartFile.fromFile(
            _imageFile!.path,
            filename: 'album_picture.jpg',
          ),
        });

        final response =
            await _apiProvider.postFormData('/album/add', formData);
        _handleSuccess(response);
      } else {
        // Create album without image
        final response = await _apiProvider.post('/album/add', {
          'name': _albumNameController.text,
        });
        _handleSuccess(response);
      }
    } catch (e) {
      _handleError(e);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleSuccess(dynamic response) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Album berhasil ditambahkan")),
    );
    Navigator.pop(context, response);
  }

  void _handleError(dynamic error) {
    if (!mounted) return;

    String errorMessage = "Gagal menambahkan album";

    if (error is DioException) {
      if (error.response?.data != null) {
        if (error.response?.data['error'] != null) {
          errorMessage = error.response?.data['error'];
        } else if (error.response?.data['message'] != null) {
          errorMessage = error.response?.data['message'];
        }
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final isLargeScreen = screenWidth > 768;

    final modalWidth = isLargeScreen ? 400.0 : screenWidth * 0.85;
    final imageSize = isLargeScreen ? 120.0 : screenWidth * 0.3;
    final titleSize = isLargeScreen ? 22.0 : 20.0;
    final labelSize = isLargeScreen ? 16.0 : 14.0;
    final buttonTextSize = isLargeScreen ? 16.0 : 14.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal:
            isLargeScreen ? (screenWidth - modalWidth) / 2 : screenWidth * 0.05,
        vertical: isLargeScreen ? 40 : screenSize.height * 0.05,
      ),
      child: Container(
        width: modalWidth,
        padding: EdgeInsets.all(isLargeScreen ? 24 : 20),
        decoration: BoxDecoration(
          color: const Color(0xFF9BADF3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tambah Album',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: isLargeScreen ? 24 : 20),
              GestureDetector(
                onTap: _isLoading ? null : _pickImage,
                child: Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildImagePreview(imageSize),
                ),
              ),
              SizedBox(height: isLargeScreen ? 24 : 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nama Album',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: labelSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: _albumNameController,
                      enabled: !_isLoading,
                      style: TextStyle(fontSize: labelSize),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: isLargeScreen ? 14 : 12,
                        ),
                      ),
                      maxLength: 12,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isLargeScreen ? 24 : 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                        onPressed:
                            _isLoading ? null : () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                            vertical: isLargeScreen ? 16 : 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Batal',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: buttonTextSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveAlbum,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F51B5),
                          padding: EdgeInsets.symmetric(
                            vertical: isLargeScreen ? 16 : 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Simpan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: buttonTextSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(double imageSize) {
    if (_imageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.memory(
          _imageBytes!,
          fit: BoxFit.cover,
        ),
      );
    } else if (_imageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.file(
          _imageFile!,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image,
            size: imageSize * 0.3,
            color: Colors.grey[400],
          ),
          SizedBox(height: imageSize * 0.05),
          Text(
            'Klik untuk\nmengunggah\ngambar',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: imageSize * 0.12,
            ),
          ),
        ],
      );
    }
  }

  @override
  void dispose() {
    _albumNameController.dispose();
    super.dispose();
  }
}
