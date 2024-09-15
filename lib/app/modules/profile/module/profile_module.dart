import 'package:viska_erp_mobile/app/modules/home/view/edit_profile_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfileModule extends Module {
  @override

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/profile', child: (_, args) => const EditProfilePage()),

  ];
}
