import 'package:employment_attendance/core/constants/app_colors.dart';
import 'package:employment_attendance/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  const ExpandableTextWidget({super.key, required this.text});

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  String firstHalf = '';
  String secondHalf = '';

  bool hiddenText = true;

  @override
  void initState() {
    super.initState();
    // Determine cutoff based on screen height percentage
    // Use a conservative character cutoff derived from hp
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dims = Dimensions.of(context);
      final cutoff = (dims.hp(20) * 2).toInt();
      if (widget.text.length > cutoff) {
        firstHalf = widget.text.substring(0, cutoff);
        secondHalf = widget.text.substring(cutoff, widget.text.length);
      } else {
        firstHalf = widget.text;
        secondHalf = "";
      }
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // If init hasn't run yet, show nothing until we have computed halves
    if (firstHalf.isEmpty && secondHalf.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: secondHalf.isEmpty
          ? Text(
              firstHalf,
              style:
                  const TextStyle(fontSize: 14, color: AppColors.textPrimary),
              textAlign: TextAlign.left,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hiddenText ? (firstHalf + '...') : (firstHalf + secondHalf),
                  style: const TextStyle(
                      fontSize: 14, height: 1.6, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () => setState(() => hiddenText = !hiddenText),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        hiddenText ? 'Show more' : 'Show less',
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600),
                      ),
                      Icon(
                        hiddenText
                            ? Icons.arrow_drop_down
                            : Icons.arrow_drop_up,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
