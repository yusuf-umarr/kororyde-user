import 'package:flutter/material.dart';
import 'package:kororyde_user/common/app_colors.dart';

class CustomSwitch extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    Key? key,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  late bool isOn;

  @override
  void initState() {
    super.initState();
    isOn = widget.initialValue;
  }

  void toggleSwitch() {
    setState(() {
      isOn = !isOn;
    });
    widget.onChanged(isOn);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleSwitch,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 70,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isOn ? AppColors.primary : AppColors.green,
        ),
        child: Stack(
          children: [
            // Align(
            //   alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 5.0),
            //     child: Text(
            //       isOn ? 'B' : 'N',
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontWeight: FontWeight.bold,
            //         fontSize: 10,
            //       ),
            //     ),
            //   ),
            // ),
            AnimatedAlign(
              duration: Duration(milliseconds: 300),
              alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.all(5),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
