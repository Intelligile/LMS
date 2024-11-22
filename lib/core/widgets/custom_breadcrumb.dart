import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lms/constants.dart';

class CustomBreadcrumb extends StatelessWidget {
  final List<String> items;
  final Function(int) onTap;

  const CustomBreadcrumb({super.key, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // White background as specified
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(items.length, (index) {
          final isLast = index == items.length - 1;
          return Row(
            children: [
              _HoverableText(
                text: items[index],
                isLast: isLast,
                onTap: () {
                  if (!isLast)
                    onTap(index); // Only clickable if not the active item
                },
              ),
              if (!isLast)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.0),
                  child: Icon(
                    FontAwesomeIcons.angleRight,
                    size: 12, // Slightly smaller arrow
                    color: Colors.grey, // Arrow icon color
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _HoverableText extends StatefulWidget {
  final String text;
  final bool isLast;
  final VoidCallback onTap;

  const _HoverableText({
    Key? key,
    required this.text,
    required this.isLast,
    required this.onTap,
  }) : super(key: key);

  @override
  _HoverableTextState createState() => _HoverableTextState();
}

class _HoverableTextState extends State<_HoverableText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.isLast
          ? SystemMouseCursors.basic // Default cursor for active item
          : SystemMouseCursors.click, // Clickable cursor for links
      onEnter: (_) {
        if (!widget.isLast) {
          setState(() {
            _isHovered = true;
          });
        }
      },
      onExit: (_) {
        if (!widget.isLast) {
          setState(() {
            _isHovered = false;
          });
        }
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 14, // Reduced font size
            fontWeight: widget.isLast ? FontWeight.bold : FontWeight.normal,
            color: widget.isLast
                ? Colors.black87 // Active item lighter color
                : kPrimaryColor, // Previous items are links
            decoration: _isHovered && !widget.isLast
                ? TextDecoration.underline // Show underline on hover
                : TextDecoration.none, // No underline by default
          ),
        ),
      ),
    );
  }
}
