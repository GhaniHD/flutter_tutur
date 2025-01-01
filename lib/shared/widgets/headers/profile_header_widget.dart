// lib/screens/home/widgets/profile_header_widget.dart
import 'package:flutter/material.dart';
import '../../../core/constants/size_config.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String name;
  final VoidCallback? onSearchTap;

  const ProfileHeaderWidget({
    Key? key,
    required this.name,
    this.onSearchTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.getProportionateScreenWidth(16),
        vertical: SizeConfig.getProportionateScreenHeight(20),
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF354EAB),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final profileSize = constraints.maxWidth > 360
                ? SizeConfig.getProportionateScreenWidth(52)
                : SizeConfig.getProportionateScreenWidth(45);

            final searchSize = constraints.maxWidth > 360
                ? SizeConfig.getProportionateScreenWidth(45)
                : SizeConfig.getProportionateScreenWidth(40);

            final fontSize = constraints.maxWidth > 360
                ? SizeConfig.getProportionateScreenWidth(20)
                : SizeConfig.getProportionateScreenWidth(16);

            return Stack(
              alignment: Alignment.center,
              children: [
                _HeaderTitle(
                  name: name,
                  fontSize: fontSize,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.getProportionateScreenWidth(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ProfileImage(size: profileSize),
                      _SearchButton(
                        size: searchSize,
                        onTap: onSearchTap,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  final String name;
  final double fontSize;

  const _HeaderTitle({
    required this.name,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
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
}

class _ProfileImage extends StatelessWidget {
  final double size;

  const _ProfileImage({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(6)),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
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
}

class _SearchButton extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;

  const _SearchButton({
    required this.size,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(8)),
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
