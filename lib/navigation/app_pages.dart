import 'package:employment_attendance/features/attendance/presentation/pages/attendance_history_page.dart';
import 'package:employment_attendance/features/leave/presentation/pages/check_in_page.dart';
import 'package:employment_attendance/features/leave/presentation/pages/check_in_success_page.dart';
import 'package:employment_attendance/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:employment_attendance/features/leave/presentation/pages/check_out_page.dart';
import 'package:employment_attendance/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:employment_attendance/features/leave/presentation/pages/leave_history_page.dart';
import 'package:employment_attendance/features/leave/presentation/pages/leave_request_page.dart';
import 'package:employment_attendance/features/lms/presentation/pages/lms_page.dart';
import 'package:employment_attendance/features/auth/presentation/pages/login_page.dart';
import 'package:employment_attendance/features/notification/presentation/pages/notification_page.dart';
import 'package:employment_attendance/features/profile/presentation/pages/profile_page.dart';
import 'package:employment_attendance/features/auth/presentation/pages/register_page.dart';
import 'package:employment_attendance/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:employment_attendance/features/settings/presentation/pages/settings_page.dart';
import 'package:employment_attendance/features/settings/presentation/pages/privacy_policy_page.dart';
import 'package:employment_attendance/features/slip/presentation/pages/slip_page.dart';
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:employment_attendance/features/task/presentation/pages/create_task_page.dart';
import 'package:employment_attendance/features/task/presentation/pages/task_page.dart';
import 'package:get/get.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.login, page: () => LoginPage()),
    GetPage(name: AppRoutes.register, page: () => RegisterPage()),
    GetPage(name: AppRoutes.dashboard, page: () => const DashboardPage()),
    GetPage(name: AppRoutes.notification, page: () => const NotificationPage()),
    GetPage(name: AppRoutes.lms, page: () => const LmsPage()),
    GetPage(
        name: AppRoutes.leaveRequest, page: () => const LeaveRequestPage()),
    GetPage(
        name: AppRoutes.leaveHistory, page: () => const LeaveHistoryPage()),
    GetPage(name: AppRoutes.profile, page: () => ProfilePage()),
    GetPage(name: AppRoutes.editProfile, page: () => const EditProfilePage()),
    GetPage(name: AppRoutes.checkIn, page: () => const CheckInPage()),
    GetPage(
        name: AppRoutes.checkInSuccess,
        page: () => const CheckInSuccessPage()),
    GetPage(name: AppRoutes.slip, page: () => const SlipPayPage()),
    GetPage(name: AppRoutes.forgotPassword, page: () => ForgotPasswordPage()),
    GetPage(
        name: AppRoutes.attendanceHistory,
        page: () => const AttendanceHistoryPage()),
    GetPage(name: AppRoutes.settings, page: () => const SettingsPage()),
    GetPage(name: '/privacy', page: () => const PrivacyPolicyPage()),
    GetPage(name: AppRoutes.task, page: () => const TaskPage()),
    GetPage(name: AppRoutes.addTask, page: () => const CreateTaskPage()),
    GetPage(name: AppRoutes.checkOut, page: () => const CheckOutPage()),
  ];
}
