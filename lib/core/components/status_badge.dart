import 'package:flutter/material.dart';
import '../constant/colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    Color border;

    switch (status) {
      case 'Approved':
      case 'Present':
        bg = AppColors.successBg;
        text = AppColors.successText;
        border = const Color(0xFFA7F3D0); // emerald-200
        break;
      case 'Pending':
      case 'Late':
        bg = AppColors.warningBg;
        text = AppColors.warningText;
        border = const Color(0xFFFDE68A); // amber-200
        break;
      case 'Rejected':
      case 'Absent':
        bg = AppColors.errorBg;
        text = AppColors.errorText;
        border = const Color(0xFFFECACA); // red-200
        break;
      case 'Leave':
        bg = AppColors.infoBg;
        text = AppColors.infoText;
        border = const Color(0xFFBFDBFE); // blue-200
        break;
      case 'Overtime':
        bg = const Color(0xFFF5F3FF); // purple-50
        text = const Color(0xFF6D28D9); // purple-700
        border = const Color(0xFFDDD6FE); // purple-200
        break;
      case 'Correction':
        bg = const Color(0xFFEEF2FF); // indigo-50
        text = const Color(0xFF4338CA); // indigo-700
        border = const Color(0xFFC7D2FE); // indigo-200
        break;
      default:
        bg = const Color(0xFFF3F4F6); // gray-100
        text = const Color(0xFF4B5563); // gray-600
        border = Colors.transparent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: border),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: text,
        ),
      ),
    );
  }
}
