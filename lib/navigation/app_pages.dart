import 'package:employment_attendance/attendance/presentation/pages/attendance_history_page.dart';
import 'package:employment_attendance/leave/presentation/pages/check_in_page.dart';
import 'package:employment_attendance/leave/presentation/pages/check_in_success_page.dart';
import 'package:employment_attendance/dashboard/presentation/pages/dashboard_page.dart';
import 'package:employment_attendance/profile/presentation/pages/edit_profile_page.dart';
import 'package:employment_attendance/leave/presentation/pages/leave_history_page.dart';
import 'package:employment_attendance/leave/presentation/pages/leave_request_page.dart';
import 'package:employment_attendance/lms/presentation/pages/lms_page.dart';
import 'package:employment_attendance/auth/presentation/pages/login_page.dart';
import 'package:employment_attendance/notification/presentation/pages/notification_page.dart';
import 'package:employment_attendance/profile/presentation/pages/profile_page.dart';
import 'package:employment_attendance/auth/presentation/pages/register_page.dart';
import 'package:employment_attendance/auth/presentation/pages/forgotPassword_page.dart';
import 'package:employment_attendance/settings/presentation/pages/settings_page.dart';
import 'package:employment_attendance/slip/presentation/pages/slip_page.dart';
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
    GetPage(name: AppRoutes.CHECK_IN_SUCCESS,page: () => const CheckInSuccessPage()),
    GetPage(name: AppRoutes.SLIP, page: () => const SlipPayPage()),
    GetPage(name: AppRoutes.FORGOT_PASSWORD, page: () => ForgotPasswordPage()),
    GetPage(name: AppRoutes.ATTENDANCE_HISTORY, page: ()=> const AttendanceHistoryPage()),
    GetPage(name: AppRoutes.SETTINGS, page:()=> const SettingsPage())
  ];
}
