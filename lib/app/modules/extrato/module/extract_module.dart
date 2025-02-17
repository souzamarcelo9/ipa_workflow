import 'package:viska_erp_mobile/app/app_store.dart';
import 'package:viska_erp_mobile/app/modules/login/store/login_store.dart';
import 'package:viska_erp_mobile/app/modules/login/store/register_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../view/extract_page.dart';

class ExtratoModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => LoginStore(i.get<AppStore>())),
    Bind.lazySingleton((i) => RegisterStore(i.get<AppStore>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const ExtratoPage()),
    ChildRoute('/home', child: (_, args) => const ExtratoPage()),
  ];
}
