import 'package:flutter/material.dart';

class AddNewComponent extends StatelessWidget {
  const AddNewComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
