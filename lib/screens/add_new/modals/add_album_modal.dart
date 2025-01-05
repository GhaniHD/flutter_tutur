import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddAlbumModal extends StatefulWidget {
  const AddAlbumModal({super.key});

  @override
  State<AddAlbumModal> createState() => _AddAlbumModalState();
}

class _AddAlbumModalState extends State<AddAlbumModal> {
  File? _image;
  final _albumNameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final isLargeScreen = screenWidth > 768;

    // Calculate modal width based on screen size
    final modalWidth = isLargeScreen
        ? 400.0 // Fixed width for large screens
        : screenWidth * 0.85; // 85% width for smaller screens

    // Calculate other dimensions
    final imageSize = isLargeScreen
        ? 120.0 // Fixed size for large screens
        : screenWidth * 0.3;

    // Calculate font sizes
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
              // Image picker container
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
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
                                fontSize: labelSize * 0.8,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(height: isLargeScreen ? 24 : 20),
              // Album name input
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
                      style: TextStyle(fontSize: labelSize),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: isLargeScreen ? 14 : 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isLargeScreen ? 24 : 20),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Cancel button
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
                  // Save button
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle save logic here
                          Navigator.pop(context);
                        },
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

  @override
  void dispose() {
    _albumNameController.dispose();
    super.dispose();
  }
}
