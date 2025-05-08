import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:zafarm/features/auth/login_page.dart';
import 'package:zafarm/providers/auth_provider.dart';
import 'package:zafarm/providers/navigation_provider.dart';

class CustomDrawer extends ConsumerStatefulWidget {
  const CustomDrawer({super.key});

  @override
  ConsumerState<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends ConsumerState<CustomDrawer> {
  final Map<String, bool> _expandedSections = {
    "Animal Management": false,
    "Production & Sales": false,
    "Inventory Management": false,
    "Employee Management": false,
    "Reports & PDFs": false,
    "Settings & Payments": false,
  };

  void _toggleSection(String section) {
    setState(() {
      _expandedSections[section] = !_expandedSections[section]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: theme.primary,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drawer Header with Business Icon and Title
              DrawerHeader(
                decoration: BoxDecoration(color: theme.primary),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/farmzan.png',
                      height: 90, // Adjust as needed
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'FarmZan Menu',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.outline,
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ Dashboard Navigation
              _drawerItem(
                title: 'Dashboard',
                icon: LucideIcons.layoutDashboard,
                index: 0,
                ref: ref,
                theme: theme,
              ),

              // ✅ Animal Management Section
              _buildExpandableSection(
                "Animal Management",
                LucideIcons.box,
                theme,
                [
                  _drawerSubItem(
                      title: 'Cattle', index: 4, ref: ref, theme: theme),
                  _drawerSubItem(
                      title: 'Sheep & Goats',
                      index: 14,
                      ref: ref,
                      theme: theme),
                  _drawerSubItem(
                      title: 'Poultry', index: 15, ref: ref, theme: theme),
                ],
              ),

              // ✅ Production & Sales Section
              _buildExpandableSection(
                "Production & Sales",
                LucideIcons.book,
                theme,
                [
                  _drawerSubItem(
                      title: 'Produce and Sale',
                      index: 1,
                      ref: ref,
                      theme: theme),
                  _drawerSubItem(
                      title: 'Sales Overview',
                      index: 3,
                      ref: ref,
                      theme: theme),
                ],
              ),

              // ✅ Inventory Management Section
              _drawerItem(
                title: 'Inventory Management',
                icon: LucideIcons.wallet,
                index: 5,
                ref: ref,
                theme: theme,
              ),

              // ✅ Employee Management Section
              _buildExpandableSection(
                "Employee Management",
                LucideIcons.users,
                theme,
                [
                  _drawerSubItem(
                      title: 'Employee Registration',
                      index: 9,
                      ref: ref,
                      theme: theme),
                  _drawerSubItem(
                      title: 'Role Assignment',
                      index: 10,
                      ref: ref,
                      theme: theme),
                  _drawerSubItem(
                      title: 'Approval System',
                      index: 11,
                      ref: ref,
                      theme: theme),
                ],
              ),

              // ✅ Reports & PDFs Section
              _buildExpandableSection(
                "Reports & PDFs",
                LucideIcons.fileText,
                theme,
                [
                  _drawerSubItem(
                      title: 'Custom Reports',
                      index: 2,
                      ref: ref,
                      theme: theme),
                  _drawerSubItem(
                      title: 'Production Cost Analysis',
                      index: 1,
                      ref: ref,
                      theme: theme),
                  _drawerSubItem(
                      title: 'Download report PDFs',
                      index: 12,
                      ref: ref,
                      theme: theme),
                ],
              ),

              _drawerItem(
                title: 'Procedures',
                icon: LucideIcons.wallet,
                index: 18,
                ref: ref,
                theme: theme,
              ),

              _drawerItem(
                title: 'Settings',
                icon: LucideIcons.settings,
                index: 6,
                ref: ref,
                theme: theme,
              ),

              _drawerItem(
                title: 'Subscription',
                icon: LucideIcons.wallet,
                index: 13,
                ref: ref,
                theme: theme,
              ),

              // ✅ Logout Button at Bottom
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DrawerLogoutButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ **Drawer Main Item**
  Widget _drawerItem({
    required String title,
    required IconData icon,
    required int index,
    required WidgetRef ref,
    required ColorScheme theme,
  }) {
    return ListTile(
      leading: Icon(icon, color: theme.outline),
      title: Text(title, style: TextStyle(color: theme.outline)),
      onTap: () {
        FocusScope.of(context).unfocus(); // ✅ Remove focus from any input field
        ref.read(drawerPageProvider.notifier).state = index;
        Navigator.of(context).pop();
      },
    );
  }

  Widget _drawerSubItem({
    required String title,
    required int index,
    required WidgetRef ref,
    required ColorScheme theme,
  }) {
    return ListTile(
      title: Text(title, style: TextStyle(color: theme.outline)),
      onTap: () {
        FocusScope.of(context).unfocus(); // ✅ Remove focus from any input field
        ref.read(drawerPageProvider.notifier).state = index;
        Navigator.of(context).pop();
      },
    );
  }

  /// ✅ **Expandable Sections**
  Widget _buildExpandableSection(
    String title,
    IconData icon,
    ColorScheme theme,
    List<Widget> children,
  ) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: theme.outline),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.outline,
            ),
          ),
          trailing: Icon(
            _expandedSections[title]! ? Icons.expand_less : Icons.expand_more,
            color: theme.outline,
          ),
          onTap: () => _toggleSection(title),
        ),
        if (_expandedSections[title]!)
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Column(children: children),
          ),
      ],
    );
  }
}

/// ✅ **ShadCN Logout Button for Drawer**
class DrawerLogoutButton extends ConsumerWidget {
  const DrawerLogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ShadButton.destructive(
      icon: Icon(LucideIcons.logOut, size: 20),
      child: const Text("Logout"),
      onPressed: () async {
        final authNotifier = ref.read(authProvider.notifier);
        await authNotifier.logout();

        // ✅ Instead of using named routes, navigate directly to LoginPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
    );
  }
}
