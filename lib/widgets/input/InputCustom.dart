import 'package:flutter/material.dart';
import 'package:umkm_store/utils/GlobalColor.dart';

class InputCustom extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final IconData prefixIcon;
  final bool isPassword;
  final bool isObscure;
  final VoidCallback? onTogglePassword;
  final TextInputType keyboardType;
  final bool readOnly;
  final String? Function(String?)? validator;

  const InputCustom({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.prefixIcon,
    this.isPassword = false,
    this.isObscure = false,
    this.onTogglePassword,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isObscure,
          keyboardType: keyboardType,
          readOnly: readOnly,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                const TextStyle(color: GlobalColor.greyHint, fontSize: 14),
            prefixIcon: Icon(prefixIcon, color: GlobalColor.primaryColor),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isObscure ? Icons.visibility_off : Icons.visibility,
                      color: GlobalColor.greyHint,
                    ),
                    onPressed: onTogglePassword,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: GlobalColor.primaryColor, width: 1.5),
            ),
            filled: readOnly,
            fillColor: readOnly ? Colors.grey[100] : Colors.transparent,
          ),
        ),
      ],
    );
  }
}
