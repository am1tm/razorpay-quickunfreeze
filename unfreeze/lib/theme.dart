import 'package:flutter/material.dart';

/// Tokens matched to the merchant app reference recordings: white surfaces, hairline borders,
/// one strong blue, a navy banner, and a pale-blue "Collect payments" block.
class AppColors {
  static const navy = Color(0xFF0D1B3E); // headings + link banner
  static const ink = Color(0xFF1B2233); // body text
  static const blue = Color(0xFF1F5AF0); // primary buttons, active nav
  static const paleBlue = Color(0xFFE8EFFE); // collect-payments block
  static const bg = Colors.white;
  static const card = Colors.white;
  static const muted = Color(0xFF6B7385);
  static const line = Color(0xFFE6E9EF);
  static const chip = Color(0xFFF1F3F6);
  static const iceText = Color(0xFF3A6E8F);
  static const water = Color(0xFF5BB8E6);
  static const green = Color(0xFF18A058);
  static const greenBg = Color(0xFFE7F6EE);
  static const amber = Color(0xFFD9822B);
  static const amberBg = Color(0xFFFFF4E5);
  static const red = Color(0xFFD93C3C);
}

const _fallback = ['NotoSansDevanagari'];

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.blue,
      primary: AppColors.blue,
      surface: AppColors.bg,
    ),
    scaffoldBackgroundColor: AppColors.bg,
    fontFamily: 'Inter',
    fontFamilyFallback: _fallback,
    splashFactory: InkRipple.splashFactory,
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.navy,
      fontFamily: 'Inter',
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      foregroundColor: AppColors.navy,
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontFamilyFallback: _fallback,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.navy,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.blue,
        minimumSize: const Size(0, 46),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontFamilyFallback: _fallback,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ink,
        minimumSize: const Size(0, 44),
        side: const BorderSide(color: AppColors.line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontFamilyFallback: _fallback,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.blue,
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontFamilyFallback: _fallback,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.line),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.line,
      thickness: 1,
      space: 1,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.navy,
      unselectedLabelColor: AppColors.navy,
      indicatorColor: AppColors.blue,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: AppColors.line,
      labelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

String formatInr(int n) {
  // Indian grouping: 48200 -> 48,200 ; 1234567 -> 12,34,567
  final s = n.abs().toString();
  if (s.length <= 3) return (n < 0 ? '-' : '') + s;
  final last3 = s.substring(s.length - 3);
  var rest = s.substring(0, s.length - 3);
  final parts = <String>[];
  while (rest.length > 2) {
    parts.insert(0, rest.substring(rest.length - 2));
    rest = rest.substring(0, rest.length - 2);
  }
  if (rest.isNotEmpty) parts.insert(0, rest);
  return '${n < 0 ? '-' : ''}${parts.join(',')},$last3';
}

String rupees(int n, {bool paise = true}) =>
    '₹${formatInr(n)}${paise ? '.00' : ''}';

/// Small rounded status/label chip.
class Pill extends StatelessWidget {
  const Pill(
    this.text, {
    super.key,
    this.color = AppColors.muted,
    this.bg,
    this.icon,
  });
  final String text;
  final Color color;
  final Color? bg;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: bg ?? color.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
        ],
        Text(
          text,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: color,
            letterSpacing: .2,
          ),
        ),
      ],
    ),
  );
}

/// Grey rounded "View breakdown ⌄" style pill.
class SoftPill extends StatelessWidget {
  const SoftPill(
    this.text, {
    super.key,
    this.trailing = Icons.keyboard_arrow_down,
    this.onTap,
    this.outlined = false,
  });
  final String text;
  final IconData? trailing;
  final VoidCallback? onTap;
  final bool outlined;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: outlined ? Colors.white : AppColors.chip,
        border: outlined ? Border.all(color: AppColors.line) : null,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.ink,
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 4),
            Icon(trailing, size: 16, color: AppColors.ink),
          ],
        ],
      ),
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing});
  final String text;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 10),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
        ),
        ?trailing,
      ],
    ),
  );
}

/// Back-chevron + left-aligned title, as on the reference's inner pages.
PreferredSizeWidget innerAppBar(
  BuildContext context,
  String title, {
  List<Widget>? actions,
}) => AppBar(
  leading: IconButton(
    icon: const Icon(Icons.chevron_left, size: 28),
    onPressed: () => Navigator.maybePop(context),
  ),
  titleSpacing: 0,
  title: Text(title),
  actions: actions,
  bottom: const PreferredSize(
    preferredSize: Size.fromHeight(1),
    child: Divider(),
  ),
);

/// Small "concept prototype" tag (kept visible so the demo is never mistaken for the real app).
class ConceptTag extends StatelessWidget {
  const ConceptTag({super.key});
  @override
  Widget build(BuildContext context) => const Text(
    'Concept prototype · Razorpay x ISB Build Challenge',
    style: TextStyle(fontSize: 10, color: AppColors.muted),
  );
}
