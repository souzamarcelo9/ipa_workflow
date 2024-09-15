import 'package:viska_erp_mobile/app/app_store.dart';
import 'package:viska_erp_mobile/app/modules/activity/module/activity_module.dart';
import 'package:viska_erp_mobile/app/modules/auth/module/auth_module.dart';
import 'package:viska_erp_mobile/app/modules/chat/module/chat_module.dart';
import 'package:viska_erp_mobile/app/modules/equipment/module/equipment_module.dart';
import 'package:viska_erp_mobile/app/modules/extrato/module/extract_module.dart';
import 'package:viska_erp_mobile/app/modules/home/store/home_store.dart';
import 'package:viska_erp_mobile/app/modules/login/module/login_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:viska_erp_mobile/app/modules/material/module/material_module.dart';
import 'package:viska_erp_mobile/app/modules/obra/module/obra_module.dart';
import 'modules/home/module/home_module.dart';
import 'modules/schedule/module/schedule_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => AppStore()),
    Bind.lazySingleton((i) => HomeStore(i.get<AppStore>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute('/', module: AuthModule()),
    ModuleRoute('/home', module: HomeModule()),
    ModuleRoute('/login', module: LoginModule()),
    ModuleRoute('/profile', module: HomeModule()),
    ModuleRoute('/activity', module: ActivityModule()),
    ModuleRoute('/extrato', module: ExtratoModule()),
    ModuleRoute('/schedule', module: ScheduleModule()),
    ModuleRoute('/equipment', module: EquipmentModule()),
    ModuleRoute('/obra', module: ObraModule()),
    ModuleRoute('/chat', module: ChatModule()),
    ModuleRoute('/material', module: MaterialModule()),
  ];
}
