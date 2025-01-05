import 'package:flutter/material.dart';
import '../../../screens/add_new/modals/add_album_modal.dart';
import '../../../screens/add_new/add_new_card.dart';

class AddNewHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const AddNewHeader({
    super.key,
    required this.title,
    required this.icon,
  });

  void _showAddOptions(BuildContext context, RenderBox button, Offset offset) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(
          Offset(button.size.width - 280, button.size.height - 10),
          ancestor: overlay,
        ),
        button.localToGlobal(
          Offset(button.size.width + 20, button.size.height - 10),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    // Store context in local variable
    final currentContext = context;

    showMenu<String>(
      context: currentContext,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: const Color(0xFF9BADF3),
      constraints: const BoxConstraints(
        minWidth: 300,
        maxWidth: 300,
      ),
      items: [
        _buildCustomMenuItem('Tambah Kartu'),
        _buildCustomMenuItem('Tambah Album'),
      ],
    ).then((String? value) {
      if (value != null && currentContext.mounted) {
        if (value == 'Tambah Kartu') {
          Navigator.push(
            currentContext,
            MaterialPageRoute(
              builder: (context) => const AddNewCardScreen(),
            ),
          );
        } else if (value == 'Tambah Album') {
          showDialog(
            context: currentContext,
            barrierDismissible: true,
            barrierColor: Colors.black
                .withAlpha(128), // Using withAlpha instead of withOpacity
            builder: (BuildContext context) {
              return const AddAlbumModal();
            },
          );
        }
      }
    });
  }

  PopupMenuItem<String> _buildCustomMenuItem(String text) {
    return PopupMenuItem<String>(
      value: text,
      padding: EdgeInsets.zero,
      height: 60,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              Colors.white.withAlpha(77), // 0.3 opacity = 77 alpha
              Colors.white.withAlpha(26), // 0.1 opacity = 26 alpha
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    double scaleFactor = devicePixelRatio > 2.5 ? 1.2 : 1.0;
    double iconSize = (screenWidth * 0.1) * scaleFactor;
    double fontSize = (screenWidth * 0.045) * scaleFactor;

    if (screenWidth >= 1024 && screenWidth < 1200) {
      iconSize = 50 * scaleFactor;
      fontSize = 20 * scaleFactor;
    } else if (screenWidth >= 1200) {
      iconSize = 60 * scaleFactor;
      fontSize = 24 * scaleFactor;
    } else if (screenWidth < 600) {
      iconSize = 40 * scaleFactor;
      fontSize = 16 * scaleFactor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF3F51B5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Image.asset(
                'assets/images/home.png',
                width: iconSize,
                height: iconSize,
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  final RenderBox button =
                      context.findRenderObject() as RenderBox;
                  _showAddOptions(context, button, details.globalPosition);
                },
                child: Image.asset(
                  'assets/images/plus.png',
                  width: iconSize,
                  height: iconSize,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
