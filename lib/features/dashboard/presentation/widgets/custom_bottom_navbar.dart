import 'package:flutter/material.dart';

class NavItem {
  final IconData icon;
  final String label;
  const NavItem(this.icon, this.label);
}

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color primary;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.primary = const Color(0xFF6EA07A),
  });

  @override
  Widget build(BuildContext context) {
    const items = <NavItem>[
      NavItem(Icons.home_outlined, 'Home'),
      NavItem(Icons.assignment_outlined, 'Atteandance'),
      NavItem(Icons.add_box_outlined, 'Absence'),
      NavItem(Icons.history, 'LMS'),
      NavItem(Icons.account_balance_wallet_outlined, 'Slip Pay'),
    ];

    List<Widget> navItems = [];

    for (int i = 0; i < items.length; i++) {
      bool isActive = i == currentIndex;

      navItems.add(
        Expanded(
          child: InkWell(
            onTap: () => onTap(i),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: _buildNavItem(items[i], isActive),
          ),
        ),
      );

      if (i < items.length - 1) {
        navItems.add(
          const VerticalDivider(
            width: 1,
            thickness: 1,
            color: Colors.black12,
            indent: 18,
            endIndent: 18, 
          ),
        );
      }
    }

    return SafeArea(
      top: false,
      child: Container(
        height: 68,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch, 
          children: navItems,
        ),
      ),
    );
  }

  Widget _buildNavItem(NavItem item, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeInOut,
      alignment: Alignment.center, 
      padding: EdgeInsets.symmetric(
        horizontal: isActive ? 18 : 12,
        vertical: isActive ? 10 : 8,
      ),
      decoration: isActive
          ? BoxDecoration(
              color: primary,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            )
          : const BoxDecoration(color: Colors.transparent),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.icon,
            size: 22,
            color: isActive ? Colors.white : Colors.black87,
          ),
          const SizedBox(height: 6),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? Colors.white : Colors.black54,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}