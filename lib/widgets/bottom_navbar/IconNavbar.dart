import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/GlobalColor.dart';

class IconNavbar extends StatelessWidget {
  final FaIconData icon;
  final bool isActive;
  const IconNavbar({super.key, required this.icon, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: isActive
              ? [GlobalColor.primaryColor, GlobalColor.blueLightColor]
              : [Colors.blueGrey[100]!, Colors.blueGrey[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: FaIcon(
        icon,
        size: isActive ? 26 : 22,
        color: Colors.white,
      ),
    );
  }
}
