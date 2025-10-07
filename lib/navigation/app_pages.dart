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
import 'package:employment_attendance/features/auth/presentation/pages/forgotPassword_page.dart';
import 'package:employment_attendance/features/settings/presentation/pages/settings_page.dart';
import 'package:employment_attendance/features/settings/presentation/pages/privacy_policy_page.dart';
import 'package:employment_attendance/features/slip/presentation/pages/slip_page.dart';
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:employment_attendance/features/task/presentation/pages/create_task_page.dart';
import 'package:employment_attendance/features/task/presentation/pages/task_page.dart';
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
    GetPage(name: AppRoutes.PROFILE, page: () =>  ProfilePage()),
    GetPage(name: AppRoutes.EDIT_PROFILE, page: () => const EditProfilePage()),
    GetPage(name: AppRoutes.CHECK_IN, page: () => const CheckInPage()),
    GetPage(name: AppRoutes.CHECK_IN_SUCCESS,page: () => const CheckInSuccessPage()),
    GetPage(name: AppRoutes.SLIP, page: () => const SlipPayPage()),
    GetPage(name: AppRoutes.FORGOT_PASSWORD, page: () => ForgotPasswordPage()),
    GetPage(name: AppRoutes.ATTENDANCE_HISTORY, page: ()=> const AttendanceHistoryPage()),
    GetPage(name: AppRoutes.SETTINGS, page:()=> const SettingsPage()),
  GetPage(name: '/privacy', page: () => const PrivacyPolicyPage()),
    GetPage(name: AppRoutes.TASK, page: ()=> const TaskPage()),
    GetPage(name: AppRoutes.ADDTASK, page:()=> const CreateTaskPage()),
    GetPage(name: AppRoutes.CHECK_OUT, page: ()=> const CheckOutPage()),
  ];
}
