import 'package:flutter/material.dart';

import '../themes/comfy_theme.dart';

class CustomTab extends StatelessWidget {
  final String message;
  final IconData icon;

  const CustomTab({
    super.key,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isHoveredOrFocused = ValueNotifier(false);

    return Focus(
      onFocusChange: (isFocused) => isHoveredOrFocused.value = isFocused,
      child: MouseRegion(
        onEnter: (_) => isHoveredOrFocused.value = true,
        onExit: (_) => isHoveredOrFocused.value = false,
        child: ValueListenableBuilder<bool>(
          valueListenable: isHoveredOrFocused,
          builder: (context, isHovered, _) {
            return Tooltip(
              message: message,
              child: Tab(
                icon: isHovered
                    ? Icon(icon,
                        color:
                            Theme.of(context).extension<CustomPalette>()!.hover)
                    : Icon(icon),
              ),
            );
          },
        ),
      ),
    );
  }
}
