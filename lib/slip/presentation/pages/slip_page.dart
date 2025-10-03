import 'package:employment_attendance/dashboard/presentation/widgets/custom_bottom_navbar.dart';
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:employment_attendance/slip/presentation/controllers/payslip_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SlipPayPage extends StatelessWidget {
  const SlipPayPage({super.key});

  @override
  Widget build(BuildContext context) {
  final SlipPayController controller = Get.put(SlipPayController());
  final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Complete SlipPay",
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.w700,
            fontSize: 21,
            letterSpacing: 0.2,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() => AnimatedOpacity(
            opacity: controller.showSuccess.value ? 0.2 : 1,
            duration: const Duration(milliseconds: 400),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Transaction Summary Card
                  _AnimatedCard(
                    delay: 100,
                    child: Obx(() {
                      final slip = controller.selectedPayslip.value;
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (controller.errorMessage.value != null) {
                        return Text(controller.errorMessage.value!);
                      }
                      if (slip == null) {
                        return const Text('There is no payslip yet');
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  "Transaction Summary",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.5,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.snackbar(
                                    "Details",
                                    "Show transaction details here.",
                                    backgroundColor: Theme.of(context).cardColor,
                                    colorText: Theme.of(context).textTheme.bodyLarge?.color,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "View Details",
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                    Icon(Icons.chevron_right,
                                        color: Theme.of(context).iconTheme.color?.withOpacity(0.7) ?? Colors.black54, size: 20),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Text(
                                "Amount Due:",
                                style: TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 8),
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: 1),
                                duration: const Duration(milliseconds: 700),
                                builder: (context, value, child) => Opacity(
                                  opacity: value,
                                  child: Transform.scale(
                                    scale: 0.95 + value * 0.05,
                                    child: child,
                                  ),
                                ),
                                  child: Text(
                                  "${slip.currency} ${slip.net}",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 21,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text(
                                "Recipient:",
                                style: TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${slip.userId} (Slip ID: ${slip.id})",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text(
                                "Periode:",
                                style: TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${slip.month}/${slip.year}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text(
                                "Gross:",
                                style: TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${slip.currency} ${slip.gross}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.hourglass_bottom,
                                  color: Colors.redAccent, size: 20),
                              const SizedBox(width: 6),
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: 1),
                                duration: const Duration(milliseconds: 700),
                                builder: (context, value, child) => Opacity(
                                  opacity: value,
                                  child: child,
                                ),
                                  child: Text(
                                  "Awaiting Confirmation",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ),
                  // Payment Method
                  _AnimatedCard(
                    delay: 250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Choose Payment Method",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            letterSpacing: 0.1,
                            color: Theme.of(context).textTheme.titleLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Obx(() => Column(
                              children: [
                                _PaymentOption(
                                  icon: Icons.credit_card,
                                  title: "Credit / Debit Card",
                                  subtitle:
                                      "Pay securely with your visa, Mastercard, or American Express",
                                  selected:
                                      controller.selectedMethod.value == 0,
                                  onTap: () =>
                                      controller.selectedMethod.value = 0,
                                ),
                                const SizedBox(height: 12),
                                _PaymentOption(
                                  icon: Icons.account_balance_wallet_outlined,
                                  title: "Digital Wallet",
                                  subtitle:
                                      "Use Apple Pay or Google Pay for quick checkout",
                                  selected:
                                      controller.selectedMethod.value == 1,
                                  onTap: () =>
                                      controller.selectedMethod.value = 1,
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Obx(() => SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: controller.isSending.value
                              ? ElevatedButton(
                                  key: const ValueKey('loading'),
                                  onPressed: null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    elevation: 0,
                                  ),
                                                  child: const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                )
                                          : ElevatedButton(
                                              key: const ValueKey('send'),
                                              onPressed: () => controller.sendPayment(() {
                                                controller.showSuccess.value = false;
                                                Get.back();
                                              }),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: primaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                elevation: 0,
                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                              ),
                                               child: Row(
                                                 mainAxisAlignment: MainAxisAlignment.center,
                                                 mainAxisSize: MainAxisSize.max,
                                                 children: const [
                                                   Icon(Icons.send, color: Colors.white, size: 20),
                                                   SizedBox(width: 10),
                                                   Text(
                                                     "Send",
                                                     style: TextStyle(
                                                         color: Colors.white,
                                                         fontWeight: FontWeight.bold,
                                                         fontSize: 17),
                                                   ),
                                                 ],
                                               ),
                                            ),
                        ),
                      )),
                ],
              ),
            ),
          )),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 4,
        // primary: primaryColor,
        onTap: (index) {
          if (index == 0) Get.offAllNamed(AppRoutes.DASHBOARD);
          if (index == 1) Get.offAllNamed(AppRoutes.ATTENDANCE_HISTORY);
          if (index == 2) Get.offAllNamed(AppRoutes.CHECK_IN);
          if (index == 3) Get.offAllNamed(AppRoutes.LMS);
          if (index == 4) Get.offAllNamed(AppRoutes.SLIP);
        },
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF6EA07A);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? primaryColor : Colors.grey.shade300,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
            color: selected ? const Color(0xFFEDF7F1) : Colors.white,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.07),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              AnimatedScale(
                scale: selected ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 250),
                child: Icon(icon,
                    color: selected ? primaryColor : Colors.black54, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.5,
                        color: selected ? primaryColor : Colors.black,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Colors.black54,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selected ? primaryColor : Colors.grey,
                  key: ValueKey(selected),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedCard extends StatelessWidget {
  final Widget child;
  final int delay;
  const _AnimatedCard({required this.child, this.delay = 0});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      builder: (context, value, child) => Opacity(
        opacity: value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, (1 - value) * 30),
          child: child,
        ),
      ),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}