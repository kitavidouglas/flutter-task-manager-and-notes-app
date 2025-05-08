import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:zafarm/core/theme/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zafarm/components/badge/badge.dart';
import 'package:zafarm/providers/navigation_provider.dart'; // ✅ Import Navigation Provider

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const CustomAppBar({super.key})
      : preferredSize = const Size.fromHeight(80.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedColor = ref.watch(themeColorProvider); // Get theme color
    final colorScheme = ShadColorScheme.fromName(selectedColor);
    final themeMode = ref.watch(themeProvider); // Watch Dark/Light Mode
    final themeNotifier = ref.read(themeProvider.notifier);
    final navigationNotifier =
        ref.read(selectedPageProvider.notifier); // ✅ Navigation State

    return Container(
      decoration: BoxDecoration(
        color:
            Theme.of(context).colorScheme.primary, // Matches theme background
        border: Border(
          bottom: BorderSide(
            color: colorScheme.primary, // 3px bottom border color
            width: 3.0,
          ),
        ),
      ),
      child: AppBar(
        toolbarHeight: 100, // Reduced height for a sleek look
        backgroundColor: Colors.transparent, // Ensure Container's color is used
        elevation: 0, // Remove shadow to maintain clean UI
        leading: Builder(
          builder: (context) => IconButton(
            color: Theme.of(context).colorScheme.surface,
            icon: const Icon(LucideIcons.menu, size: 35), // 🍔 Drawer Icon
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        // Business Logo in the center of the AppBar
        title: Image.asset(
          'assets/icons/farmzan.png',
          height: 50, // Adjust the height as needed
          fit: BoxFit.contain,
        ),
        centerTitle: false,
        actions: [
          // 🔔 Notifications Button with Badge
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                color: Theme.of(context).colorScheme.surface,
                icon: const Icon(Icons.notifications, size: 28),
                onPressed: () {
                  // TODO: Navigate to notifications screen
                },
              ),
              const Positioned(
                right: 6,
                top: 6,
                child: CustomBadge(label: "3"), // Show unread count
              ),
            ],
          ),
          // 🌙 Theme Toggle Icon (Switches between Light and Dark Mode)
          IconButton(
            color: Theme.of(context).colorScheme.surface,
            icon: Icon(
              themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
              size: 28,
            ),
            onPressed: () {
              themeNotifier.toggleBrightness(); // ✅ Toggle Theme
            },
          ),
          // 🐔 User Avatar (Using hen1.jpg) - Navigates to UserSettingsPage
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {
                navigationNotifier.state = 3; // ✅ Navigates to UserSettingsPage
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/hen1.jpg", // ✅ Using hen1.jpg
                    fit: BoxFit.cover, // Ensures image fits well
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
