import 'package:get/get.dart';
import '../../../../core/interfaces/i_auth_repository.dart';
import '../../../../data/repositories/auth_repository_impl.dart';
import '../controllers/verification_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IAuthRepository>(() => AuthRepositoryImpl());
    Get.lazyPut<VerificationController>(() => VerificationController(Get.find<IAuthRepository>()));
  }
}
