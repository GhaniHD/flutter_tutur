// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import '../../core/constants/size_config.dart';
import '../../shared/widgets/headers/profile_header_widget.dart';
import '../../shared/widgets/album/menu_grid_item.dart';
import '../../data/models/album_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final List<AlbumItem> _albums = List.generate(
    18,
    (index) => AlbumItem(
      title: 'Buah-buahan',
      backgroundPath: 'assets/images/blue.png',
      iconPath: 'assets/images/buah_buahan.png',
    ),
  );

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: Column(
        children: [
          ProfileHeaderWidget(
            name: 'Rifky Adi taqwim',
          ),
          Expanded(
            child: AlbumGridWidget(albums: _albums),
          ),
        ],
      ),
    );
  }
}
