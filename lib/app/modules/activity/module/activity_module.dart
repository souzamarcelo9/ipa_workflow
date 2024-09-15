import 'package:viska_erp_mobile/app/app_store.dart';
import 'package:viska_erp_mobile/app/modules/activity/view/create_page.dart';
import 'package:viska_erp_mobile/app/modules/activity/view/detail_insuladora_page.dart';
import 'package:viska_erp_mobile/app/modules/activity/view/maps.dart';
import 'package:viska_erp_mobile/app/modules/activity/view/tabela_hora_page.dart';
import 'package:viska_erp_mobile/app/modules/login/store/login_store.dart';
import 'package:viska_erp_mobile/app/modules/login/store/register_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../view/activity_page.dart';
import '../view/detail_page.dart';
import '../view/edit_activity_page.dart';

class ActivityModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => LoginStore(i.get<AppStore>())),
    Bind.lazySingleton((i) => RegisterStore(i.get<AppStore>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const ActivityPage()),
    ChildRoute('/edit/:action', child: (_,args) => EditActivityPage(action: args.params['action'])),
    ChildRoute('/detail/:card', child: (_,args) => DetailPage(card: args.data)),
    ChildRoute('/detailInsul/:card', child: (_,args) => DetailInsuladoraPage(card: args.data)),
        //child: (_, args) => const EditActivityPage()),
    ChildRoute('/create/:profissional', child: (_, args) => CreatePage(profissional: args.data,)),
    ChildRoute('/tabelahora', child: (_, args) => const TabelaHoraPage()),
    ChildRoute('/map', child: (_, args) => MapActivityPage()),
  ];
}
