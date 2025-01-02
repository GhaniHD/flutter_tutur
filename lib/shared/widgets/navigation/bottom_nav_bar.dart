import 'package:flutter/material.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavigationWidget({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Specific sizes for different screen widths
    double navHeight;
    double iconSize;
    double containerPadding;

    // Tablet specific sizes (around 912px)
    if (screenWidth >= 900 && screenWidth < 1200) {
      navHeight = 90;
      iconSize = 50;
      containerPadding = 16;
    }
    // Desktop sizes
    else if (screenWidth >= 1200) {
      navHeight = 80;
      iconSize = 38;
      containerPadding = 12;
    }
    // Mobile sizes
    else if (screenWidth > 600) {
      navHeight = 70;
      iconSize = 32;
      containerPadding = 10;
    }
    // Small mobile sizes
    else {
      navHeight = 65;
      iconSize = 32;
      containerPadding = 8;
    }

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
              _buildNavItem(
                'assets/images/add_new.png',
                0,
                iconSize,
                containerPadding,
              ),
              _buildNavItem(
                'assets/images/sentence.png',
                1,
                iconSize,
                containerPadding,
              ),
              _buildNavItem(
                'assets/images/favorite.png',
                2,
                iconSize,
                containerPadding,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    String imagePath,
    int index,
    double iconSize,
    double padding,
  ) {
    bool isSelected = selectedIndex == index;

 return GestureDetector(
  onTap: () => onTap(index),
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
}
