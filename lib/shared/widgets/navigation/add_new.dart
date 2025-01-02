import 'package:flutter/material.dart';

class AddNewComponent extends StatelessWidget {
  const AddNewComponent({
    super.key,
    });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Image.asset(
        'assets/images/add_new.png',
        height: 43,
        width: 43,
        fit: BoxFit.contain,
      ),
    );
  }
}
