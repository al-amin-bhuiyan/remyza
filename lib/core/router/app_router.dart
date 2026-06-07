import 'package:go_router/go_router.dart';
import 'package:get/get.dart';

import '../../modules/onboarding/views/onboarding_view.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/auth/views/verification_view.dart';
import '../../modules/auth/bindings/auth_binding.dart';
import '../../modules/shell/views/main_shell_view.dart';
import '../../modules/settings/views/profile_view.dart';
import '../../modules/settings/bindings/settings_binding.dart';
import '../../modules/settings/views/my_plan_view.dart';
import '../../modules/settings/views/my_sms_number_view.dart';
import '../../modules/settings/views/notification_prefs_view.dart';
import '../../modules/settings/views/ai_settings_view.dart';
import '../../modules/settings/views/help_support_view.dart';
import '../../modules/settings/views/send_email_view.dart';
import '../../modules/settings/views/privacy_policy_view.dart';
import '../../modules/settings/views/terms_of_service_view.dart';
import '../../modules/messages/bindings/messages_binding.dart';
import '../../modules/messages/views/chat_view.dart';
import '../../modules/messages/views/new_message_view.dart';
import '../../modules/messages/controllers/chat_controller.dart';
import '../../modules/leads/bindings/leads_binding.dart';
import '../../modules/leads/views/lead_detail_view.dart';
import '../../modules/contacts/bindings/contacts_binding.dart';
import '../../modules/contacts/views/contact_form_view.dart';
import '../../modules/contacts/views/import_contacts_view.dart';
import '../../modules/contacts/views/edit_contact_view.dart';
import '../../modules/settings/views/auto_capture_view.dart';
import '../../modules/settings/views/auto_capture_simulation_view.dart';
import '../../modules/settings/views/welcome_message_edit_view.dart';
import '../../modules/leads/views/set_reminder_view.dart';
import '../interfaces/i_messages_repository.dart';
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
          AuthBinding().dependencies();
          final phoneNumber = state.uri.queryParameters['phone'] ?? '';
          return VerificationView(phoneNumber: phoneNumber);
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) {
          SettingsBinding().dependencies();
          MessagesBinding().dependencies();
          LeadsBinding().dependencies();
          ContactsBinding().dependencies();
          return const MainShellView();
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(
        path: AppRoutes.myPlan,
        builder: (context, state) => const MyPlanView(),
      ),
      GoRoute(
        path: AppRoutes.smsNumber,
        builder: (context, state) => const MySmsNumberView(),
      ),
      GoRoute(
        path: AppRoutes.notificationPrefs,
        builder: (context, state) => const NotificationPrefsView(),
      ),
      GoRoute(
        path: AppRoutes.aiSettings,
        builder: (context, state) => const AISettingsView(),
      ),
      GoRoute(
        path: AppRoutes.helpSupport,
        builder: (context, state) => const HelpSupportView(),
      ),
      GoRoute(
        path: AppRoutes.sendEmail,
        builder: (context, state) => const SendEmailView(),
      ),
      GoRoute(
        path: AppRoutes.privacyPolicy,
        builder: (context, state) => const PrivacyPolicyView(),
      ),
      GoRoute(
        path: AppRoutes.termsOfService,
        builder: (context, state) => const TermsOfServiceView(),
      ),
      GoRoute(
        path: AppRoutes.chat,
        builder: (context, state) {
          MessagesBinding().dependencies();
          final id = state.pathParameters['id'] ?? '';
          Get.delete<ChatController>();
          Get.put(ChatController(Get.find<IMessagesRepository>(), id));
          return ChatView(conversationId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.newMessage,
        builder: (context, state) {
          MessagesBinding().dependencies();
          return const NewMessageView();
        },
      ),
      GoRoute(
        path: AppRoutes.leadDetail,
        builder: (context, state) {
          LeadsBinding().dependencies();
          final id = state.pathParameters['id'] ?? '';
          return LeadDetailView(leadId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.contactForm,
        builder: (context, state) => const ContactFormView(),
      ),
      GoRoute(
        path: AppRoutes.importContacts,
        builder: (context, state) => const ImportContactsView(),
      ),
      GoRoute(
        path: AppRoutes.autoCapture,
        builder: (context, state) => const AutoCaptureView(),
      ),
      GoRoute(
        path: AppRoutes.autoCaptureSimulation,
        builder: (context, state) => const AutoCaptureSimulationView(),
      ),
      GoRoute(
        path: AppRoutes.welcomeMessageEdit,
        builder: (context, state) => const WelcomeMessageEditView(),
      ),
      GoRoute(
        path: AppRoutes.setReminder,
        builder: (context, state) {
          LeadsBinding().dependencies();
          return const SetReminderView();
        },
      ),
      GoRoute(
        path: AppRoutes.editContact,
        builder: (context, state) {
          ContactsBinding().dependencies();
          return const EditContactView();
        },
      ),
    ],
  );
}
