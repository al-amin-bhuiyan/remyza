import 'package:go_router/go_router.dart';

import '../../modules/onboarding/views/onboarding_view.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/auth/views/verification_view.dart';
import '../../modules/shell/views/main_shell_view.dart';
import '../../modules/settings/views/profile_view.dart';
import '../constants/app_routes.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.onboarding,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: AppRoutes.verification,
        builder: (context, state) {
          final phoneNumber = state.uri.queryParameters['phone'] ?? '';
          return VerificationView(phoneNumber: phoneNumber);
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MainShellView(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileView(),
      ),
      // Add other routes here as they are built
    ],
  );
}
