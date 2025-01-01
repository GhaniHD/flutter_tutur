// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import '../../core/constants/size_config.dart';
import '../../shared/widgets/headers/profile_header_widget.dart';
import '../../shared/widgets/album/menu_grid_item.dart';
import '../../shared/widgets/navigation/bottom_nav_bar.dart';
import '../../data/models/album_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
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
            onSearchTap: () {
              print('Search tapped');
            },
          ),
          Expanded(
            child: AlbumGridWidget(albums: _albums),
          ),
          BottomNavigationWidget(
            selectedIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}
