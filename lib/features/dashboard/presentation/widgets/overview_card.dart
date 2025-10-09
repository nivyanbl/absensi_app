import 'package:flutter/material.dart';

class OverviewCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color primaryColor;
  final VoidCallback? onTap;

  const OverviewCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.primaryColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = constraints.maxWidth;
        double valueFontSize = cardWidth * 0.18;
        double labelFontSize = cardWidth * 0.1;

        final displayValue =
            (value.trim().isEmpty || value == 'N/A') ? '-' : value;
        final valueParts = displayValue.split(' ');

        return Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Padding(
              // reduce vertical padding so cards fit better on small heights
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: Colors.black87, size: 22),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: labelFontSize,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Show primary part (e.g., time or number) prominently and secondary part smaller
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Text(
                            valueParts[0],
                            style: TextStyle(
                              fontSize: valueFontSize.clamp(12, 28),
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                      if (valueParts.length > 1) ...[
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            valueParts.sublist(1).join(' '),
                            style: TextStyle(
                              fontSize: labelFontSize.clamp(10, 16),
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
