import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monoledger/core/theme/app_theme.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String sessionCode;
  final VoidCallback? onLeave;
  final VoidCallback? onShare;

  const DashboardAppBar({
    super.key,
    required this.sessionCode,
    this.onLeave,
    this.onShare,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: onLeave ?? () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.exit_to_app_rounded,
          color: AppTheme.primaryColor,
        ),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ROOM CODE',
            style: GoogleFonts.spaceMono(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          Text(
            '#$sessionCode',
            style: GoogleFonts.spaceMono(
              color: AppTheme.primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: onShare,
          icon: Icon(
            Icons.adaptive.share,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
