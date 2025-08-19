import 'package:employment_attendance/feature/presentation/page/check_in_page.dart';
import 'package:employment_attendance/feature/presentation/page/check_in_success_page.dart';
import 'package:employment_attendance/feature/presentation/page/dashboard_page.dart';
import 'package:employment_attendance/feature/presentation/page/edit_profile_page.dart';
import 'package:employment_attendance/feature/presentation/page/leave_history_page.dart';
import 'package:employment_attendance/feature/presentation/page/leave_request_page.dart';
import 'package:employment_attendance/feature/presentation/page/lms_page.dart';
import 'package:employment_attendance/feature/presentation/page/login_page.dart';
import 'package:employment_attendance/feature/presentation/page/notification_page.dart';
import 'package:employment_attendance/feature/presentation/page/profile_page.dart';
import 'package:employment_attendance/feature/presentation/page/register_page.dart';
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:get/get.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.LOGIN, page: () => LoginPage()),
    GetPage(name: AppRoutes.REGISTER, page: () => RegisterPage()),
    GetPage(name: AppRoutes.DASHBOARD, page: () => const DashboardPage()),
    GetPage(name: AppRoutes.NOTIFICATION, page: () => const NotificationPage()),
    GetPage(name: AppRoutes.LMS, page: () => const LmsPage()),
    GetPage(name: AppRoutes.LEAVE_REQUEST, page: () => const LeaveRequestPage()),
    GetPage(name: AppRoutes.LEAVE_HISTORY, page: () => const LeaveHistoryPage()),
    GetPage(name: AppRoutes.PROFILE, page: () => const ProfilePage()),
    GetPage(name: AppRoutes.EDIT_PROFILE, page: () => const EditProfilePage()),
    GetPage(name: AppRoutes.CHECK_IN, page: () => const CheckInPage()),
    GetPage(name: AppRoutes.CHECK_IN_SUCCESS, page: () => const CheckInSuccessPage()),
  ];
}