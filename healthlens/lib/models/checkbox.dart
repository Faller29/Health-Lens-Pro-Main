import 'package:flutter/material.dart';

class ImageCheckbox extends StatefulWidget {
  final String label;
  final String imagePath;
  final String selectedImagePath;
  final ValueChanged<String> onSelected;

  const ImageCheckbox({
    required this.label,
    required this.imagePath,
    required this.selectedImagePath,
    required this.onSelected,
  });

  @override
  _ImageCheckboxState createState() => _ImageCheckboxState();
}

class _ImageCheckboxState extends State<ImageCheckbox> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isSelected = !isSelected;
            });
            widget.onSelected(widget.label);
          },
          child: Image.asset(
            isSelected ? widget.selectedImagePath : widget.imagePath,
            width: 50,
            height: 50,
          ),
        ),
        Text(widget.label),
      ],
    );
  }
}
