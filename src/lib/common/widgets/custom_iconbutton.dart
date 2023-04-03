import 'package:flutter/material.dart';
import '../themes/comfy_theme.dart';

class CustomIconButton extends StatefulWidget {
  final Icon icon;
  final bool isSelected;
  final VoidCallback onPressed;

  const CustomIconButton({
    super.key,
    this.isSelected = false,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: IconButton(
        icon: widget.icon,
        color: _isHovering
            ? themeData.extension<CustomPalette>()!.hover
            : widget.isSelected
                ? themeData.extension<CustomPalette>()!.selected
                : themeData.extension<CustomPalette>()!.unselected,
        onPressed: widget.onPressed,
      ),
    );
  }
}
