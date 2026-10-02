import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool isCompact;

  const StatusBadge({
    super.key,
    required this.status,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;
    String label = status.toUpperCase();

    switch (status.toUpperCase()) {
      case 'VERIFIED':
        bg = AppColors.tertiaryContainer;
        fg = AppColors.tertiary;
        icon = Icons.verified_user_rounded;
        break;
      case 'EXPIRING SOON':
      case 'PENDING SYNC':
        bg = AppColors.secondaryContainer;
        fg = AppColors.secondary;
        icon = Icons.schedule_rounded;
        break;
      case 'EXPIRED':
      case 'REVOKED':
        bg = AppColors.errorContainer;
        fg = AppColors.error;
        icon = Icons.gpp_bad_rounded;
        break;
      default:
        bg = AppColors.surfaceVariant;
        fg = AppColors.textSecondary;
        icon = Icons.info_outline_rounded;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 10,
        vertical: isCompact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: fg.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isCompact ? 12 : 14, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: isCompact ? 10 : 11,
              fontWeight: FontWeight.w700,
              color: fg,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
