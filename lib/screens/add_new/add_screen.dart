import 'package:flutter/material.dart';
import '../../data/models/album_item.dart';
import '../../shared/widgets/album/album_grid.dart';
import '../../shared/widgets/headers/add_new_header.dart';

class AddScreen extends StatelessWidget {
  final List<AlbumItem> albums = List.generate(
    18,
    (index) => AlbumItem(
      title: 'Buah-buahan',
      backgroundPath: 'assets/images/blue.png',  // gunakan backgroundPath
      iconPath: 'assets/images/buah_buahan.png', // gunakan iconPath
    ),
  );
  AddScreen({super.key});

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
                albums: albums,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
