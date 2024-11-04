import 'package:flutter/material.dart';

extension HoverExtensions on Widget {
  Widget scaleOnHover() {
    return MouseRegion(
      onEnter: (_) => _hovering.value = true,
      onExit: (_) => _hovering.value = false,
      child: ValueListenableBuilder(
        valueListenable: _hovering,
        builder: (context, hovering, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.identity()..scale(hovering ? 1.02 : 1.0),
            decoration: BoxDecoration(
              color: hovering ? Colors.grey[200] : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              boxShadow: hovering
                  ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(2, 2),
                      ),
                    ]
                  : [],
            ),
            child: child,
          );
        },
        child: this,
      ),
    );
  }

  static final ValueNotifier<bool> _hovering = ValueNotifier(false);
}
