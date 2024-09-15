import 'package:flutter_modular/flutter_modular.dart';
import 'package:viska_erp_mobile/app/modules/activity/view/maps.dart';
import 'package:viska_erp_mobile/app/modules/activity/view/tabela_hora_page.dart';
import 'package:viska_erp_mobile/pages/home_page.dart';
import 'package:viska_erp_mobile/theme/colors.dart';
import 'package:viska_erp_mobile/widgets/bottombar_item.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../app/modules/home/store/home_store.dart';


class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int activeTab = 0;
  final _auth = FirebaseAuth.instance;
  final HomeStore controller = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.appBgColor.withOpacity(.95),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Scaffold(
        backgroundColor: controller.appStore.isDark ?AppColor.shadowColor :Colors.transparent,
        bottomNavigationBar: _buildBottomBar(),
        floatingActionButton: _buildMidButton(),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        body: _buildPage(),
      ),
    );
  }

  Widget _buildMidButton() {
    return Container(
      margin: const EdgeInsets.only(top: 35),
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColor.bottomBarColor,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            activeTab = 2;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: AppColor.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 75,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.bottomBarColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(0.1),
            blurRadius: .5,
            spreadRadius: .5,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BottomBarItem(
              Icons.home_rounded,
              "Início",
              isActive: activeTab == 0,
              activeColor: AppColor.primary,
              onTap: () {
                setState(() {
                  activeTab = 0;

                });
              },
            ),
            BottomBarItem(
              Icons.account_balance_wallet_rounded,
              "Fotos da Obra",
              isActive: activeTab == 1,
              activeColor: AppColor.primary,
              onTap: () {
                setState(() {
                  activeTab = 1;
                  Modular.to.navigate('/obra/list/${_auth.currentUser!.uid}');
                });
              },
            ),
            BottomBarItem(
              Icons.watch_later_rounded,
              "Tabela Hora",
              isActive: activeTab == 2,
              activeColor: AppColor.primary,
              onTap: () {
                setState(() {
                  activeTab = 2;
                  //Modular.to.pushNamed('activity/tabelahora');
                });
              },
            ),
            BottomBarItem(
              Icons.insert_chart_rounded,
              "Extrato",
              isActive: activeTab == 3,
              activeColor: AppColor.primary,
              onTap: () {
                setState(() {
                  //activeTab = 3;
                  Modular.to.pushNamed('/extrato');
                });
              },
            ),
            BottomBarItem(
              Icons.person_rounded,
              "Perfil/Login",
              isActive: activeTab == 4,
              activeColor: AppColor.primary,
              onTap: () {
                    setState(() {
                      //activeTab = 4;
                          Modular.to.pushNamed('/login/profile');
                    });


              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage() {
    return IndexedStack(
      index: activeTab,
      children: const <Widget>[
        HomePage(),
        Center(
          child: Text(
            "Carregando...",
            style: TextStyle(fontSize: 35),
          ),
        ),
        //TabelaHoraPage(),
        const MapActivityPage(),
        Center(
          child: Text(
            "Tabela Hora",
            style: TextStyle(fontSize: 35),
          ),
        ),
        Center(
          child: Text(
            "Statistics",
            style: TextStyle(fontSize: 35),
          ),
        ),
        Center(
          child: Text(
            "Account",
            style: TextStyle(fontSize: 35),
          ),
        )
      ],
    );
  }
}
