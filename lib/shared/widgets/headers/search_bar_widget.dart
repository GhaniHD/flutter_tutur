import 'package:flutter/material.dart';
import '../../../core/constants/size_config.dart';

class SearchBarWidget extends StatelessWidget {
  final bool isVisible;
  final VoidCallback? onClose;

  const SearchBarWidget({
    super.key,
    this.isVisible = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    // Calculate constrained width for desktop
    double containerWidth = SizeConfig.getProportionateScreenWidth(320);
    if (containerWidth > 500) {
      // Max width for desktop
      containerWidth = 500;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: isVisible ? 80 : 0,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: containerWidth,
              minWidth: 280, // Minimum width for small screens
            ),
            child: Container(
              height: 80,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
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
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
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
                        horizontal: 16,
                        vertical: 12,
                      ),
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
      ),
    );
  }
}
