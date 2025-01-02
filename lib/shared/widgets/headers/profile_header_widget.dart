import 'package:flutter/material.dart';
import 'search_bar_widget.dart';

class ProfileHeaderWidget extends StatefulWidget {
  final String name;

  const ProfileHeaderWidget({
    super.key,
    required this.name,
  });

  @override
  State<ProfileHeaderWidget> createState() => _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends State<ProfileHeaderWidget> {
  bool _isSearchVisible = false;

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Specific sizes for different screen widths
    double headerHeight;
    double profileSize;
    double searchSize;
    double fontSize;

    // Tablet specific sizes
    if (screenWidth >= 900 && screenWidth < 1200) {
      headerHeight = 110;
      profileSize = 46;
      searchSize = 42;
      fontSize = 20;
    }
    // Desktop sizes
    else if (screenWidth >= 1200) {
      headerHeight = 100;
      profileSize = 42;
      searchSize = 38;
      fontSize = 18;
    }
    // Mobile sizes
    else if (screenWidth > 600) {
      headerHeight = 90;
      profileSize = 38;
      searchSize = 34;
      fontSize = 16;
    }
    // Small mobile sizes
    else {
      headerHeight = 80;
      profileSize = 38;
      searchSize = 34;
      fontSize = 16;
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: headerHeight,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth > 600 ? 16 : 12,
            vertical: screenWidth > 600 ? 12 : 8,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF354EAB),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildHeaderTitle(widget.name, fontSize),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth > 600 ? 800 : double.infinity,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildProfileImage(profileSize),
                      _buildSearchButton(searchSize),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        SearchBarWidget(
          isVisible: _isSearchVisible,
          onClose: _toggleSearch,
        ),
      ],
    );
  }

  Widget _buildHeaderTitle(String name, double fontSize) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Text(
        name,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildProfileImage(double size) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: ClipOval(
        child: Image.asset(
          'assets/images/profile.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSearchButton(double size) {
    return GestureDetector(
      onTap: _toggleSearch,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(
          'assets/images/search.png',
          width: size,
          height: size,
        ),
      ),
    );
  }
}
