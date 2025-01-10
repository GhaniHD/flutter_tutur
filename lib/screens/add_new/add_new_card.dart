import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/api/api_provider.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({super.key});

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _spellingController = TextEditingController();
  File? _imageFile;
  String? _audioPath;
  String? _albumName;
  bool _isRecording = false;

  final ImagePicker _picker = ImagePicker();
  late final recorder;

  @override
  void initState() {
    super.initState();
    recorder = AudioRecorder();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    try {
      final status = await Permission.microphone.request();
      final isPermitted = status.isGranted;

      if (isPermitted) {
        debugPrint('Audio recorder initialized.');
      } else {
        debugPrint('Recording permission not granted');
      }
    } catch (e) {
      debugPrint('Error initializing recorder: $e');
    }
  }

  @override
  void dispose() {
    recorder.dispose();
    _wordController.dispose();
    _spellingController.dispose();
    super.dispose();
  }

  Future<void> _toggleRecord() async {
    if (!_isRecording) {
      try {
        final tempDir = await getTemporaryDirectory();
        final path = '${tempDir.path}/audio_record.m4a';

        await recorder.start(
          path: path,
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          samplingRate: 44100,
        );

        setState(() {
          _isRecording = true;
        });
      } catch (e) {
        debugPrint('Error starting recording: $e');
      }
    } else {
      try {
        String? path = await recorder.stop();
        if (path != null) {
          setState(() {
            _isRecording = false;
            _audioPath = path;
          });
        }
      } catch (e) {
        debugPrint('Error stopping recording: $e');
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickAlbum() async {
    setState(() {
      _albumName = 'Album 1'; // Replace with actual album selection
    });
  }

  void _saveCard() async {
    if (_wordController.text.isEmpty ||
        _spellingController.text.isEmpty ||
        _imageFile == null ||
        _albumName == null ||
        _audioPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Semua field harus diisi dan gambar, album, serta suara harus dipilih'),
      ));
      return;
    }

    FormData formData = FormData.fromMap({
      'word': _wordController.text,
      'spelling': _spellingController.text,
      'image': await MultipartFile.fromFile(_imageFile!.path),
      'audio': await MultipartFile.fromFile(_audioPath!),
      'album': _albumName,
    });

    try {
      await ApiProvider().postFormData('/cards', formData);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Kartu berhasil disimpan'),
      ));
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Terjadi kesalahan, coba lagi'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEFF6FF),
      appBar: AppBar(
        title: const Text(
          'Buat Kartu Baru',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Unggah Gambar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: _imageFile == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    size: 48,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Klik untuk mengunggah gambar',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _imageFile!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Kata/Keterangan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBE6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _wordController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan kata/keterangan',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Ejaan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBE6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _spellingController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan ejaan',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Pilih Album',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4, // Number of albums
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _albumName = 'Buah-buahan';
                              });
                            },
                            child: Container(
                              width: 100,
                              margin: EdgeInsets.only(
                                right: index != 3 ? 12 : 0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color:
                                      _albumName == 'Buah-buahan' && index == 0
                                          ? const Color(0xFF4460F1)
                                          : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/buah_buahan.png', // Add your fruit image
                                    width: 48,
                                    height: 48,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Buah-buahan',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Rekam Suara',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _toggleRecord,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4460F1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.mic,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isRecording
                                  ? 'Sedang Merekam...'
                                  : 'Mulai Rekam',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_audioPath != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green.shade400,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Audio telah direkam',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (_audioPath != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Audio telah direkam: $_audioPath',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF354EAB),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveCard,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF354EAB),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
