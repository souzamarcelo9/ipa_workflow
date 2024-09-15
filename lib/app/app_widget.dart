import 'package:viska_erp_mobile/app/app_store.dart';
import 'package:viska_erp_mobile/app/modules/home/store/home_store.dart';
import 'package:viska_erp_mobile/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../flutter_gen/gen_l10n/app_localizations.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final store = Modular.get<AppStore>();
  final homeStore = Modular.get<HomeStore>();

  @override
  void initState() {
    super.initState();
    store.loadTheme();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    await homeStore.loadSelectedLanguage();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("IDIOMA:> ${homeStore.selectedLanguage}");
    return Observer(
      builder: (context) {
        if(store.themeType != null){
          return MaterialApp.router(
            theme: store.themeType,
            routeInformationParser: Modular.routeInformationParser,
            routerDelegate: Modular.routerDelegate,
            supportedLocales: L10n.all,
            locale: homeStore.selectedLanguage,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
