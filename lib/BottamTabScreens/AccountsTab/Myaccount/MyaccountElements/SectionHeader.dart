import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onEdit;
  final VoidCallback? onAdd;
  final bool showEdit;
  final bool showAdd;

  const SectionHeader({
    super.key,
    required this.title,
    this.onEdit,
    this.onAdd,
    this.showEdit = false,
    this.showAdd = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double widthScale = size.width / 360;
    final double fontScale = widthScale.clamp(0.98, 1.02);
    final double sizeScale = widthScale.clamp(0.98, 1.02);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18 * fontScale,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF003840),
          ),
        ),
        Row(
          children: [
            if (showEdit && onEdit != null)
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: const Color(0xFF005E6A),
                  size: 20 * sizeScale,
                ),
                onPressed: onEdit,
              ),
            if (showAdd && onAdd != null)
              TextButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add, size: 20, color: Color(0xFF005E6A)),
                label: Text(
                  "Add",
                  style: TextStyle(
                    color: const Color(0xFF005E6A),
                    fontSize: 16 * fontScale,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF005E6A), width: 1.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30 * sizeScale),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12 * sizeScale,
                    vertical: 6 * sizeScale,
                  ),
                  minimumSize: const Size(10, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
          ],
        ),
      ],
    );
  }
}