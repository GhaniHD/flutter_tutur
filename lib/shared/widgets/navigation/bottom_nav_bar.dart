// lib/screens/home/widgets/bottom_navigation_widget.dart
import 'package:flutter/material.dart';
import '../../../core/constants/size_config.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavigationWidget({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.getProportionateScreenHeight(12),
        horizontal: SizeConfig.getProportionateScreenWidth(24),
      ),
      decoration: BoxDecoration(
        color: Color(0xFF3F51B5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.edit, 0),
          _buildNavItem(Icons.download, 1),
          _buildNavItem(Icons.star, 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: SizeConfig.getProportionateScreenWidth(28),
        ),
      ),
    );
  }
}
