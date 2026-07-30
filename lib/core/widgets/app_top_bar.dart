import 'package:flutter/material.dart';

import 'package:outc/core/theme/design_tokens.dart';

/// The one top-bar treatment for screens reached from Home (a search form,
/// results, a confirmation step, etc.): white background, a back arrow
/// (auto-supplied when there's a route to pop), and just the service/step
/// name — no color block, no extra icon row. Matches the clean, minimal
/// chrome of reference travel apps (MakeMyTrip) rather than each module
/// inventing its own AppBar. Bus is the first module on this; other modules
/// still use their own older AppBar patterns until they're migrated too.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
  });

  final String title;

  /// Optional second line (e.g. bus type under the operator name on the
  /// seat-selection/results screens) — kept on this shared widget instead of
  /// each screen re-building its own `Column` title.
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;

  @override
  Size get preferredSize => Size.fromHeight(subtitle == null ? kToolbarHeight : kToolbarHeight + 8);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: subtitle == null ? null : 0,
      title: subtitle == null
          ? Text(title, style: const TextStyle(fontWeight: FontWeight.w600))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                Text(subtitle!, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      foregroundColor: AppColors.textPrimary,
      iconTheme: const IconThemeData(color: AppColors.primary),
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: actions,
    );
  }
}
