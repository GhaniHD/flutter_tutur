import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../core/constants/size_config.dart';
import '../../shared/widgets/headers/profile_header_widget.dart';
import '../../shared/widgets/navigation/bottom_nav_bar.dart';
import '../../shared/widgets/navigation/favorite.dart';
import '../../shared/widgets/album/album_grid.dart';
import '../../data/models/album_item.dart';
import '../../core/api/api_provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final ApiProvider _apiProvider = ApiProvider();
  List<AlbumItem> _albums = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlbums();
  }

  Future<void> _loadAlbums() async {
    try {
      await _apiProvider.init();
      final response = await _apiProvider.get('/albums');

      setState(() {
        _albums =
            (response as List).map((item) => AlbumItem.fromJson(item)).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading albums: $e');
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memuat album')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: Column(
        children: [
          ProfileHeaderWidget(
            name: context.watch<AuthProvider>().user?.name ?? 'User',
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadAlbums,
                    child: AlbumGridWidget(albums: _albums),
                  ),
          ),
          BottomNavigationWidget(
            selectedIndex: _selectedIndex,
            favorites: favorites,
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
