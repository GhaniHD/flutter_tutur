// lib/screens/cards/cards_screen.dart

import 'package:flutter/material.dart';
import '../../../data/models/album_item.dart';
import '../../../data/models/favorite_item.dart';
import '../../shared/widgets/navigation/bottom_nav_bar.dart';
import '../../shared/widgets/cards/card_grid.dart';

class CardsScreen extends StatefulWidget {
  final AlbumItem album;

  const CardsScreen({
    super.key,
    required this.album,
  });

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  int _selectedIndex = 0;
  final List<FavoriteItem> _favorites = [];

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Album ${widget.album.title}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          const Expanded(
            child: CardGrid(),
          ),
          BottomNavigationWidget(
            selectedIndex: _selectedIndex,
            onTap: _onNavTap,
            favorites: _favorites,
          ),
        ],
      ),
    );
  }
}
