import 'package:flutter/material.dart';

enum AvatarSize { sm, md, lg, xl }

class Avatar extends StatelessWidget {
  final String initials;
  final AvatarSize size;

  const Avatar({super.key, required this.initials, this.size = AvatarSize.md});

  @override
  Widget build(BuildContext context) {
    double width;
    double height;
    double fontSize;

    switch (size) {
      case AvatarSize.sm:
        width = 32;
        height = 32;
        fontSize = 12;
        break;
      case AvatarSize.md:
        width = 40;
        height = 40;
        fontSize = 14;
        break;
      case AvatarSize.lg:
        width = 64;
        height = 64;
        fontSize = 20;
        break;
      case AvatarSize.xl:
        width = 72;
        height = 72;
        fontSize = 24;
        break;
    }

    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        color: Color(0xFF1E3A5F),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
