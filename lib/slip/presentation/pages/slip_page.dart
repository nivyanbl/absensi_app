import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SlipPayController extends GetxController {
  var selectedMethod = 0.obs;
  var isSending = false.obs;

  void sendPayment() async {
    isSending.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isSending.value = false;
    Get.snackbar("Success", "Payment sent successfully!",
        backgroundColor: Colors.green[100], colorText: Colors.black);
  }
}

class SlipPayPage extends StatelessWidget {
  const SlipPayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SlipPayController());
    final Color primaryColor = const Color(0xFF6EA07A);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Complete SlipPay",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 21,
            letterSpacing: 0.2,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Transaction Summary Card
            AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
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
              child: Column(
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
                          Get.snackbar("Details", "Show transaction details here.",
                              backgroundColor: Colors.white,
                              colorText: Colors.black,
                              snackPosition: SnackPosition.BOTTOM);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Row(
                          children: [
                            Text(
                              "View Details",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                                fontSize: 13.5,
                              ),
                            ),
                            Icon(Icons.chevron_right, color: Colors.black54, size: 20),
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
                        style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "IDR 12,500,000",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 21,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        "Recipient:",
                        style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "John Doe (Employee ID: 2034)",
                        style: TextStyle(
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
                        "Transaction ID:",
                        style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "SP-98756732",
                        style: TextStyle(
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
                      const Icon(Icons.hourglass_bottom, color: Colors.redAccent, size: 20),
                      const SizedBox(width: 6),
                      const Text(
                        "Awaiting Confirmation",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Payment Method
            AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Choose Payment Method",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      letterSpacing: 0.1,
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
                            selected: controller.selectedMethod.value == 0,
                            onTap: () => controller.selectedMethod.value = 0,
                          ),
                          const SizedBox(height: 12),
                          _PaymentOption(
                            icon: Icons.account_balance_wallet_outlined,
                            title: "Digital Wallet",
                            subtitle:
                                "Use Apple Pay or Google Pay for quick checkout",
                            selected: controller.selectedMethod.value == 1,
                            onTap: () => controller.selectedMethod.value = 1,
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
                        : ElevatedButton.icon(
                            key: const ValueKey('send'),
                            onPressed: controller.sendPayment,
                            icon: const Icon(Icons.send, color: Colors.white),
                            label: const Text(
                              "Send",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.5),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                              elevation: 0,
                            ),
                          ),
                  ),
                )),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 4,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 0) {
            Get.offAllNamed('/dashboard');
          } else if (index == 1) {
            Get.offAllNamed('/leave-request');
          } else if (index == 2) {
            Get.offAllNamed('/absence');
          } else if (index == 3) {
            Get.offAllNamed('/history');
          } else if (index == 4) {
            // Stay on this page
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.timer_off), label: 'Time Off'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Absence'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Slip Pay'),
        ],
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
    final Color primaryColor = const Color(0xFF6EA07A);
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
              Icon(icon,
                  color: selected ? primaryColor : Colors.black54, size: 32),
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