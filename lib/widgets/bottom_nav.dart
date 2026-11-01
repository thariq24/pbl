import 'package:flutter/material.dart';
import '../utils/color_palettes.dart';
import '../utils/text_styles.dart';
import 'app_constants.dart';

/// Item untuk bottom navigation
class BottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;

  const BottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}

/// Custom bottom navigation bar untuk aplikasi BukuBicara
class BottomNav extends StatelessWidget {
  /// Index halaman yang sedang aktif
  final int currentIndex;

  /// Callback ketika item ditekan
  final ValueChanged<int> onTap;

  /// Daftar item navigasi
  final List<BottomNavItem> items;

  /// Warna item aktif
  final Color? activeColor;

  /// Warna item tidak aktif
  final Color? inactiveColor;

  /// Background color
  final Color? backgroundColor;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.activeColor,
    this.inactiveColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: AppConstants.bottomNavHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              items.length,
              (index) => _buildNavItem(
                item: items[index],
                isActive: currentIndex == index,
                onTap: () => onTap(index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BottomNavItem item,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final color = isActive
        ? (activeColor ?? AppColors.yinMnBlue)
        : (inactiveColor ?? AppColors.grey);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive && item.activeIcon != null ? item.activeIcon : item.icon,
              color: color,
              size: AppConstants.bottomNavIconSize,
            ),
            const SizedBox(height: AppConstants.spaceXSmall),
            Text(
              item.label,
              style: AppTextStyles.labelSmall.copyWith(
                color: color,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Default bottom nav items untuk BukuBicara
class BukuBicaraBottomNav {
  /// Items default untuk aplikasi BukuBicara
  static List<BottomNavItem> get defaultItems => [
        const BottomNavItem(
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          label: 'Beranda',
        ),
        const BottomNavItem(
          icon: Icons.explore_outlined,
          activeIcon: Icons.explore,
          label: 'Jelajahi',
        ),
        const BottomNavItem(
          icon: Icons.library_books_outlined,
          activeIcon: Icons.library_books,
          label: 'Library',
        ),
        const BottomNavItem(
          icon: Icons.person_outline,
          activeIcon: Icons.person,
          label: 'Profil',
        ),
      ];

  /// Items dengan search di tengah
  static List<BottomNavItem> get withSearch => [
        const BottomNavItem(
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          label: 'Beranda',
        ),
        const BottomNavItem(
          icon: Icons.search,
          activeIcon: Icons.search,
          label: 'Cari',
        ),
        const BottomNavItem(
          icon: Icons.library_books_outlined,
          activeIcon: Icons.library_books,
          label: 'Library',
        ),
        const BottomNavItem(
          icon: Icons.person_outline,
          activeIcon: Icons.person,
          label: 'Profil',
        ),
      ];
}

/// Bottom navigation dengan floating action button di tengah
class BottomNavWithFAB extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onFABTap;
  final IconData fabIcon;
  final String? fabTooltip;

  const BottomNavWithFAB({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onFABTap,
    this.fabIcon = Icons.add,
    this.fabTooltip,
  });

  @override
  Widget build(BuildContext context) {
    // Items tanpa item tengah (akan digantikan FAB)
    final items = [
      const BottomNavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: 'Beranda',
      ),
      const BottomNavItem(
        icon: Icons.explore_outlined,
        activeIcon: Icons.explore,
        label: 'Jelajahi',
      ),
      const BottomNavItem(
        icon: Icons.library_books_outlined,
        activeIcon: Icons.library_books,
        label: 'Library',
      ),
      const BottomNavItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Profil',
      ),
    ];

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Bottom nav
        BottomNav(
          currentIndex: currentIndex,
          onTap: (index) {
            // Adjust index untuk FAB di tengah
            if (index >= 2) {
              onTap(index + 1);
            } else {
              onTap(index);
            }
          },
          items: items,
        ),

        // FAB
        Positioned(
          bottom: AppConstants.paddingLarge,
          child: FloatingActionButton(
            onPressed: onFABTap,
            backgroundColor: AppColors.yinMnBlue,
            foregroundColor: AppColors.white,
            tooltip: fabTooltip,
            child: Icon(fabIcon),
          ),
        ),
      ],
    );
  }
}

/// Material 3 style bottom nav dengan indicator
class ModernBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItem> items;

  const ModernBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: AppColors.white,
      indicatorColor: AppColors.lavender,
      height: AppConstants.bottomNavHeight,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: items.map((item) {
        return NavigationDestination(
          icon: Icon(item.icon),
          selectedIcon: Icon(item.activeIcon ?? item.icon),
          label: item.label,
        );
      }).toList(),
    );
  }
}
