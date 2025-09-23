import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:employment_attendance/slip/data/repositories/payslip_repository.dart';
import 'package:employment_attendance/slip/domain/models/payslip_model.dart';

class SlipPayController extends GetxController {
  final PayslipRepository _repo = PayslipRepository();
  var payslips = <PayslipModel>[].obs;
  var selectedPayslip = Rx<PayslipModel?>(null);
  var isLoading = false.obs;
  var selectedMethod = 0.obs;
  var isSending = false.obs;
  var showSuccess = false.obs;
  var errorMessage = RxnString();
  

  @override
  void onInit() {
    super.onInit();
    fetchPayslipsData();
  }

  Future<void> fetchPayslipsData({int? year, int? month}) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      final result = await _repo.listPayslips(year: year, month: month);
      payslips.assignAll(result);
      if (result.isEmpty) {
        selectedPayslip.value = PayslipModel(
          id: 'SLIP001',
          userId: 'USR001',
          year: 2025,
          month: 9,
          currency: 'IDR',
          gross: '12.000.000',
          net: '10.000.000',
          items: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      } else {
        selectedPayslip.value = result.first;
      }
    } on DioException catch (e) {
      errorMessage.value =
          e.response?.data['error']?['message'] ?? 'Failed to load payslip';
      selectedPayslip.value = PayslipModel(
        id: 'SLIP001',
        userId: 'USR001',
        year: 2025,
        month: 9,
        currency: 'IDR',
        gross: '12.000.000',
        net: '10.000.000',
        items: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPayslipByPeriod(int year, int month) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      selectedPayslip.value = await _repo.getPayslipByPeriod(year, month);
    } on DioException catch (e) {
      errorMessage.value =
          e.response?.data['error']?['message'] ?? 'Payslip not found';
      selectedPayslip.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  void sendPayment(VoidCallback onSuccessDialogClose) async {
    isSending.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isSending.value = false;
    showSuccess.value = true;
    await Future.delayed(const Duration(milliseconds: 400));
    Get.dialog(
      _SuccessDialog(onClose: onSuccessDialogClose),
      barrierDismissible: false,
    );
  }
}

class _SuccessDialog extends StatelessWidget {
  final VoidCallback onClose;
  const _SuccessDialog({required this.onClose});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF6EA07A);
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.7, end: 1),
        duration: const Duration(milliseconds: 400),
        curve: Curves.elasticOut,
        builder: (context, value, child) => Transform.scale(
          scale: value,
          child: child,
        ),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_rounded, color: primaryColor, size: 64),
                const SizedBox(height: 18),
                const Text(
                  "Payment Sent!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Your payment has been sent successfully. Please wait for confirmation.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15.5, color: Colors.black87),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onClose,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "OK",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}