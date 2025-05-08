import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '/providers/navigation_provider.dart';

class CustomBottomNavBar extends ConsumerWidget {
  final ShadColorScheme colorScheme;

  const CustomBottomNavBar({super.key, required this.colorScheme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme;
    final selectedIndex = ref.watch(selectedPageProvider);
    final drawerIndex = ref.watch(drawerPageProvider);

    // ✅ If drawerIndex is active, do not highlight bottom nav
    final safeIndex = drawerIndex == null ? selectedIndex : 0;

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colorScheme.primary, width: 3)),
        color: theme.primary,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        child: BottomNavigationBar(
          currentIndex: safeIndex, // ✅ Prevents bottom nav from crashing
          onTap: (index) {
            ref.read(selectedPageProvider.notifier).state = index;
            ref.read(drawerPageProvider.notifier).state = null;
          },
          backgroundColor: colorScheme.secondary,
          selectedItemColor: theme.outline,
          unselectedItemColor: theme.outline.withOpacity(0.6),
          items: bottomNavItems,
        ),
      ),
    );
  }
}

// ✅ Updated Bottom Navigation Items
final List<BottomNavigationBarItem> bottomNavItems = [
  BottomNavigationBarItem(
    icon: Icon(LucideIcons.layoutDashboard),
    label: 'Dashboard',
  ),
  BottomNavigationBarItem(
    icon: Icon(LucideIcons.trendingUp),
    label: 'Production',
  ),
  BottomNavigationBarItem(
    icon: Icon(LucideIcons.fileText),
    label: 'Reports',
  ),
  BottomNavigationBarItem(
    icon: Icon(LucideIcons.trendingUpDown), // 🏭 Production Icon
    label: 'Sales',
  ),
];
