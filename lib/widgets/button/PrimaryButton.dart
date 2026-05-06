import 'package:flutter/material.dart';
import 'package:umkm_store/utils/GlobalColor.dart';
import 'package:umkm_store/widgets/button/ButtonLoading.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  const PrimaryButton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: GlobalColor.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: isLoading
          ? const ButtonLoading()
          : Text(
              text,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
    );
  }
}
