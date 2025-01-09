import 'package:flutter/material.dart';
import '../../../core/api/api_provider.dart';
import '../../../data/models/album_item.dart';
import '../../widgets/album/album_grid.dart';

class SearchBarWidget extends StatefulWidget {
  final bool isVisible;
  final VoidCallback? onClose;
  final String searchType;

  const SearchBarWidget({
    super.key,
    this.isVisible = false,
    this.onClose,
    this.searchType = 'album',
  });

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  List<AlbumItem> _searchResults = []; // Daftar hasil pencarian

  Future<void> _search(String query) async {
    try {
      final result = await ApiProvider().search(query);

      // Parsing data yang diterima dari API
      List<AlbumItem> fetchedAlbums =
          (result['albums'] ?? []).map<AlbumItem>((album) {
        return AlbumItem.fromJson(album);
      }).toList();

      // Menyaring album berdasarkan query pencarian
      setState(() {
        _searchResults = fetchedAlbums.where((album) {
          return album.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: widget.isVisible ? 80 : 0, // Menentukan tinggi container
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Center(
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xff4762C8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xffF9F8E2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(fontSize: 14),
                  onChanged: (query) {
                    if (query.isNotEmpty) {
                      _search(query); // Memulai pencarian saat mengetik
                    } else {
                      setState(() {
                        _searchResults
                            .clear(); // Membersihkan hasil pencarian jika query kosong
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 14),
                    suffixIcon: Container(
                      width: 40,
                      padding: const EdgeInsets.all(8),
                      child: const Center(
                        child: Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 24,
                        ),
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    filled: true,
                    fillColor: const Color(0xffF9F8E2),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Menampilkan album terurut di AlbumGridWidget
  Widget _buildAlbumGrid() {
    return AlbumGridWidget(
      albums: _searchResults, // Mengirimkan album yang sudah terurut
    );
  }
}
