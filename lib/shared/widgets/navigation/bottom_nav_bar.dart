import 'package:flutter/material.dart';
import '../../../data/models/favorite_item.dart';
import 'favorite.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final List<FavoriteItem> favorites;

  const BottomNavigationWidget({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.favorites,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double navHeight = _getNavHeight(screenWidth);
    double iconSize = _getIconSize(screenWidth);
    double containerPadding = _getContainerPadding(screenWidth);

    return Container(
      width: double.infinity,
      height: navHeight,
      color: const Color(0xFF3F51B5),
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: screenWidth > 600 ? 800 : double.infinity,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, 'assets/images/add_new.png', 0, iconSize,
                  containerPadding),
              _buildNavItem(context, 'assets/images/sentence.png', 1, iconSize,
                  containerPadding),
              _buildNavItem(context, 'assets/images/favorite.png', 2, iconSize,
                  containerPadding),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String imagePath, int index,
      double iconSize, double padding) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        onTap(index);
        if (index == 0) {
          Navigator.pushNamed(context, '/addscreen'); // Navigasi ke AddScreen
        } else if (index == 2) {
          _showFavoriteDialog(context);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: isSelected
              ? Color.fromRGBO(255, 255, 255, 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(
          imagePath,
          width: iconSize,
          height: iconSize,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  void _showFavoriteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Favorite(favorites: favorites),
    );
  }

  double _getNavHeight(double screenWidth) {
    if (screenWidth >= 900 && screenWidth < 1200) return 90;
    if (screenWidth >= 1200) return 80;
    if (screenWidth > 600) return 70;
    return 65;
  }

  double _getIconSize(double screenWidth) {
    if (screenWidth >= 900 && screenWidth < 1200) return 50;
    if (screenWidth >= 1200) return 38;
    return 32;
  }

  double _getContainerPadding(double screenWidth) {
    if (screenWidth >= 900 && screenWidth < 1200) return 16;
    if (screenWidth >= 1200) return 12;
    if (screenWidth > 600) return 10;
    return 8;
  }
}
