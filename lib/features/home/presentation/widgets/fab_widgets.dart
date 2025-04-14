import 'package:flutter/material.dart';

class FABButton extends StatefulWidget {
  final Color iconColor;
  final Color iconBgColor;
  final String containerText;
  final IconData? icon;
  final double? containerWidth;
  final Function()? onTapped;

  const FABButton({
    required this.iconColor,
    required this.iconBgColor,
    required this.icon,
    required this.containerText,
    required this.containerWidth,
    required this.onTapped,
    Key? key,
  }) : super(key: key);

  @override
  State<FABButton> createState() => _FABButtonState();
}

class _FABButtonState extends State<FABButton> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: widget.onTapped,
      child: Container(
        width: size.width * 0.55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: widget.iconBgColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    widget.icon,
                    color: widget.iconColor,
                    size: 14,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.containerText,
                style: const TextStyle(fontSize: 14),
              )
            ],
          ),
        ),
      ),
    );
  }
}
