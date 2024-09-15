import 'package:viska_erp_mobile/app/app_store.dart';
import 'package:viska_erp_mobile/app/modules/activity/view/tabela_hora_page.dart';
import 'package:viska_erp_mobile/app/modules/login/store/login_store.dart';
import 'package:viska_erp_mobile/app/modules/login/store/register_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:viska_erp_mobile/app/modules/obra/view/detailFoto_page.dart';
import 'package:viska_erp_mobile/app/modules/obra/view/list_page.dart';
import '../view/fotoObra_page.dart';

class ObraModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => LoginStore(i.get<AppStore>())),
    Bind.lazySingleton((i) => RegisterStore(i.get<AppStore>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/:idAtividade', child: (_, args) => const FotoObraPage(idAtividade:'',)),
    ChildRoute('/activity/tabelahora', child: (_, args) => const TabelaHoraPage()),
    ChildRoute('/list/:userId', child: (_, args) => const ObraListPage(userId: '',)),
    ChildRoute('/detailFoto/:card', child: (_,args) => DetailFotoPage(card: args.data)),
    ChildRoute('/home/:idAtividade', child: (_, args) => const FotoObraPage(idAtividade: '',)),
  ];
}
