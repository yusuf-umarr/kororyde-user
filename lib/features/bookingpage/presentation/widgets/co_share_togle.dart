import 'package:flutter/material.dart';
import 'package:kororyde_user/common/app_colors.dart';

class CoShare extends StatefulWidget {
  @override
  _CoShareState createState() => _CoShareState();
}

class _CoShareState extends State<CoShare> {
  bool isChecked = false;

  void toggleCheckbox() {
    setState(() {
      isChecked = !isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Text(
            'Co Share',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
          Checkbox(
            activeColor: AppColors.green,
            value: isChecked,
            onChanged: (bool? value) {
              toggleCheckbox();
            },
          ),
        ],
      ),
    );
  }
}
