import 'package:flutter/material.dart';
import '../../../data/models/album_item.dart';
import '../../../data/models/favorite_item.dart';
import '../../shared/widgets/cards/card_item.dart'; // Import model CardItem
import '../../shared/widgets/navigation/bottom_nav_bar.dart';
import '../../shared/widgets/cards/card_grid.dart';
import 'package:dio/dio.dart';

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
  late List<CardItem> _cardItems = [];
  bool _isLoading = true; // Menambahkan variabel loading

  @override
  void initState() {
    super.initState();
    _fetchCards();
  }

  // Fungsi untuk mengambil kartu berdasarkan albumId
  Future<void> _fetchCards() async {
    try {
      // Mengubah status loading menjadi true saat memulai pengambilan data
      setState(() {
        _isLoading = true;
      });

      final response =
          await Dio().get('https://example.com/api/cards', queryParameters: {
        'album_id': widget.album.id, // Filter berdasarkan albumId
      });

      // Misalkan response.data adalah list kartu yang ter-filter
      setState(() {
        _cardItems = (response.data as List)
            .map((data) => CardItem.fromJson(data))
            .toList();
        _isLoading =
            false; // Mengubah status loading setelah data selesai diambil
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Mengubah status loading jika terjadi error
      });
      print('Error fetching cards: $e');
    }
  }

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
          'Album ${widget.album.name}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Pastikan ada pengecekan untuk memastikan data kartu sudah ada
          Expanded(
            child: _isLoading
                ? const Center(
                    child:
                        CircularProgressIndicator()) // Menampilkan loading saat data sedang diambil
                : _cardItems.isNotEmpty
                    ? CardGrid(cardItems: _cardItems)
                    : const Center(
                        child: Text(
                            'Tidak ada kartu')), // Menampilkan teks jika tidak ada kartu
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
