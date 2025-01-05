import 'package:boxify/core.dart';
import 'package:flutter/material.dart';

class HoverText extends StatefulWidget {
  /// Used for track titles, subtitles, Large Left side widgets
  HoverText({
    super.key,
    required this.text,
    this.fontSize = 12,
    this.fontWeight = FontWeight.bold,
    this.overflow = TextOverflow.ellipsis,
    this.fontColor,
    this.underlineOnHover = false,
    this.changeColorOnHover = true,
    this.parentIsMouseClicked = false,
  });
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextOverflow overflow;
  final Color? fontColor;
  final bool underlineOnHover;
  final bool changeColorOnHover;
  final bool parentIsMouseClicked;

  @override
  _HoverTextState createState() => _HoverTextState();
}

class _HoverTextState extends State<HoverText> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    Color? fontColor;
    if (widget.fontColor == null) {
      (_isHovering && widget.changeColorOnHover) || widget.parentIsMouseClicked
          ? fontColor = Core.appColor.titleColor
          : fontColor = Core.appColor.subtitleColor;
    } else {
      fontColor = widget.fontColor;
    }
    return MouseRegion(
      onHover: (event) {
        setState(() {
          _isHovering = true;
        });
      },
      onExit: (event) {
        setState(() {
          _isHovering = false;
        });
      },
      child: Text(
        widget.text,
        overflow: widget.overflow,
        style: TextStyle(
          color: fontColor,
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          decoration: widget.underlineOnHover && _isHovering
              ? TextDecoration.underline
              : null,
        ),
      ),
    );
  }
}
