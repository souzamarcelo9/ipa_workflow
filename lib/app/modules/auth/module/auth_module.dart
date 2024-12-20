import 'package:viska_erp_mobile/app/modules/auth/store/auth_store.dart';
import 'package:viska_erp_mobile/app/modules/auth/view/auth_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:viska_erp_mobile/pages/splashscreen.dart';

class AuthModule extends Module {
  @override
  final List<Bind> binds = [Bind.lazySingleton((i) => AuthStore())];

  @override
  final List<ModularRoute> routes = [

    ChildRoute('/', child: (_, args) => const AuthPage())
  ];
}
