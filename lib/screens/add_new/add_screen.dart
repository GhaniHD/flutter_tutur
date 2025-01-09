import 'package:flutter/material.dart';
import '../../data/models/album_item.dart';
import '../../shared/widgets/album/album_grid.dart';
import '../../shared/widgets/headers/add_new_header.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  // Daftar album statis untuk tampilan Add Cards
  final List<AlbumItem> albums = [
    AlbumItem(
      id: 1,
      name: 'Buah-buahan',
      userId: 1,
      picture: 'assets/images/buah_buahan.png', // Menggunakan asset lokal
    ),
    // Tambahkan item statis lainnya sesuai kebutuhan
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AddNewHeader(
              title: 'Tambah Album & kartu',
              icon: Icons.add,
            ),
            Expanded(
              child: AlbumGridWidget(
                albums: albums, // Menggunakan daftar statis
              ),
            ),
          ],
        ),
      ),
    );
  }
}
