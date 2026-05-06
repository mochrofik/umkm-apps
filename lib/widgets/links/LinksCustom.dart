import 'package:flutter/material.dart';
import 'package:umkm_store/utils/GlobalColor.dart';

class LinkCustoms extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;
  const LinkCustoms({super.key, this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          color: GlobalColor.primaryColor,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
