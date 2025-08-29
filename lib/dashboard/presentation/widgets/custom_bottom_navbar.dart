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
      NavItem(Icons.assignment_outlined, 'Time Off'),
      NavItem(Icons.add_box_outlined, 'Absence'),
      NavItem(Icons.history, 'History'),
      NavItem(Icons.account_balance_wallet_outlined, 'Slip Pay'),
    ];

    return SafeArea(
      top: false, 
      child: Container(
        height: 68,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8), 
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(items.length, (i) {
            final isActive = i == currentIndex;

            
            final tab = AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeInOut,
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
                    items[i].icon,
                    size: 22,
                    color: isActive ? Colors.white : Colors.black87,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    items[i].label,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive ? Colors.white : Colors.black54,
                    ),
                  ),
                ],
              ),
            );

            final withDivider = i == 0
                ? tab
                : Stack(
                    children: [
                      Positioned.fill(
                        left: 0,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 1,
                            height: 32,
                            color: Colors.black12,
                          ),
                        ),
                      ),
                      tab,
                    ],
                  );

            return Expanded(
              child: InkWell(
                onTap: () => onTap(i),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Align(
                  alignment: Alignment.bottomCenter, 
                  child: withDivider,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
