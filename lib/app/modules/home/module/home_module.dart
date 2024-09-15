import 'dart:ui';
import 'package:viska_erp_mobile/app/app_store.dart';
import 'package:viska_erp_mobile/app/modules/activity/view/create_page.dart';
import 'package:viska_erp_mobile/app/modules/activity/view/tabela_hora_page.dart';
import 'package:viska_erp_mobile/app/modules/home/view/edit_profile_page.dart';
import 'package:viska_erp_mobile/app/modules/home/view/language_select_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../extrato/view/extract_page.dart';
import '../../material/view/material_page.dart';
import '../store/home_store.dart';
import 'package:viska_erp_mobile/pages/root_app.dart' as viska;

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => HomeStore(i.get<AppStore>()))
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const viska.RootApp()),
    ChildRoute('/profile', child: (_, args) => const EditProfilePage()),
    ChildRoute('/activity', child: (_, args) => CreatePage(profissional: args.data,)),
    ChildRoute('/edit', child: (_, args) => const EditProfilePage()),
    ChildRoute('/extrato', child: (_, args) => const ExtratoPage()),
    ChildRoute('/material', child: (_, args) => const MaterialPage()),
    ChildRoute('/tabelahora', child: (_, args) => const TabelaHoraPage()),
    ChildRoute('/language',
        child: (_, args) =>
            const LanguageSelectPage(selectedLocale: Locale('pt'))),
  ];
}
