import 'package:badges/badges.dart' as eos;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:viska_erp_mobile/app/model/card_equipment.dart';
import 'package:viska_erp_mobile/app/model/veiculo.dart';
import 'package:viska_erp_mobile/theme/colors.dart';
import 'package:viska_erp_mobile/widgets/service_box.dart';
import 'package:viska_erp_mobile/widgets/avatar_image.dart';
import 'package:viska_erp_mobile/widgets/balance_card.dart';
import 'package:viska_erp_mobile/widgets/transaction_item.dart';
import 'package:viska_erp_mobile/widgets/user_box.dart';
import 'package:flutter/material.dart' as material;
import '../app/core/firebase_const.dart';
import '../app/model/AtividadeInsuladora.dart';
import '../app/model/AtividadeProducao.dart';
import '../app/model/atividade.dart';
import '../app/model/card_transaction.dart';
import '../app/model/ferramenta.dart';
import '../app/model/profissional.dart';
import '../app/modules/home/store/home_store.dart';

class HomePage extends material.StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeStore controller = Modular.get();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final urlController = TextEditingController();
  static String nomeFuncionario = "";
  late List<CardTransaction> listaTransacoes = [];
  late List<CardTransaction> listaTransacoesSelect = [];
  late List<CardEquipment> listaEquipamentos = [];
  late List<CardEquipment> listaEquipamentosSelect = [];
  late List<AtividadeModel> listaAtividades = [];
  late List<AtividadeProducaoModel> tbProducao = [];
  late List<AtividadeInsuladoraModel> tbInsuladora = [];
  late ProfissionalModel _profissionalModel = ProfissionalModel();
  late ProfissionalModel _profissionalDB = ProfissionalModel();
  late FerramentaModel _ferramentaModel = FerramentaModel();
  late VeiculoModel _veiculoModel = VeiculoModel();
  late double seuSaldo = 0;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    onInit();
  }
  void onInit() async {
    await controller.recoverUserData();
    setState(() {
      nameController.text = controller.userModel.name;
      emailController.text = controller.userModel.email;
      urlController.text = controller.userModel.userImage;
      nomeFuncionario = controller.userModel.name;
      var names = nomeFuncionario.split(' ');
      var firstName = names[0];
      nomeFuncionario = firstName;
    });

    await getTransactions();

    await getProfissionalTable();
    setState(() {
      listaTransacoes = listaTransacoesSelect;
      _profissionalModel = _profissionalDB;

    });

    await getEquipments();

    //PREENCHE OS CARD DE TRANSACOES E DE EQUIPAMENTOS
    setState(() {
      listaEquipamentos = listaEquipamentosSelect;
    });

  }

  @override
  Widget build(BuildContext context) {
    return material.Scaffold(
      backgroundColor: material.Colors.transparent,
      body: _buildBody(),
    );
  }

  Future<void> getProfissionalTable() async{
    //RECUPERA DADOS DO PROFISSIONAL

    try{
      await FirebaseFirestore.instance.collection("profissionais")
           .where("email", isEqualTo: emailController.text)
           .get()
           .then(
            (querySnapshot) {

          for (var docSnapshot in querySnapshot.docs) {
            Map<String, dynamic> response = docSnapshot.data();
            _profissionalDB = ProfissionalModel.fromMap(response,docSnapshot.reference.id);
          }

        },
        onError: (e) => print("Error completing: $e"),
      );
    }
    catch (e){
      print("SELECT DO PROFISSONA");
      print(e); print(_profissionalDB.nome);

    }

  }

  Future<void> getTransactions() async{
    //RECUPERA TODAS AS ATIVIDADES DO PROFISSIONAL
   int cont = 0;
    try {
      await FirebaseFirestore.instance.collection('atividade')
          .where(
          "profissional", isEqualTo: emailController.text)
          .orderBy("dtModificacao",descending: true)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {

            Map<String, dynamic> response = docSnapshot.data();
            if(listaAtividades.length <= 3) {
              listaAtividades.add(
                  AtividadeModel.fromMap(response, docSnapshot.reference.id));
            }
          }
      });
    }
    catch (e){
      print(e);
    }

    try {
      for (var atividade in listaAtividades)
      {
        if(atividade.tabela.length == 1){

          await FirebaseFirestore.instance.collection(FirebaseConst.atividadeProducao).where("idAtividade", isEqualTo:atividade.id ).get().then(
                  (querySnapshot)
              {
                for (var docSnapshot in querySnapshot.docs) {

                    Map<String, dynamic> response = docSnapshot.data();
                    var producaoModel = AtividadeProducaoModel.fromMap(
                        response, docSnapshot.id);
                    CardTransaction card = CardTransaction();
                    card.name = atividade.nomeObra;
                    card.date = atividade.data;
                    card.price = producaoModel.totalProfissional.toString();
                    card.type = int.parse(atividade.tabela);
                    if (producaoModel.totalProfissional > 0 && listaTransacoesSelect.length <= 2) {
                      listaTransacoesSelect.add(card);
                    }
                    if (producaoModel.totalProfissional > 0){
                      seuSaldo = seuSaldo + producaoModel.totalProfissional;
                    }
                }
              });
        }
        else{

          await FirebaseFirestore.instance.collection(FirebaseConst.atividadeInsuladora).where("idAtividade", isEqualTo:atividade.id ).get().then(
                  (querySnapshot)
              {
                for (var docSnapshot in querySnapshot.docs) {
                  Map<String, dynamic> response = docSnapshot.data();

                    var insuladoraModel = AtividadeInsuladoraModel.fromMap(
                        response, docSnapshot.id);
                    CardTransaction card = CardTransaction();
                    card.name = atividade.nomeObra;
                    card.date = atividade.data;
                    card.price = insuladoraModel.totalProfissional.toString();
                    card.type = int.parse(atividade.tabela);

                    if (insuladoraModel.totalProfissional > 0 && listaTransacoesSelect.length <= 2) {
                      listaTransacoesSelect.add(card);
                    }
                  if (insuladoraModel.totalProfissional > 0) {
                    seuSaldo = seuSaldo + insuladoraModel.totalProfissional;
                  }
                }
                });

        }
      }
    }
    catch (e){
      print(e);
    }
  }

  Future<void> getEquipments() async{
    //RECUPERA OS EQUIPAMENTOS PARA EXIBIR NA HOME
    try {
      await FirebaseFirestore.instance.collection(FirebaseConst.ferramentas)
          .where(
          "profissional", isEqualTo: _profissionalModel.id)
          .get()
          .then((querySnapshot) {

        for (var docSnapshot in querySnapshot.docs) {

          Map<String, dynamic> response = docSnapshot.data();
          _ferramentaModel = FerramentaModel.fromMap(response, docSnapshot.reference.id);
          CardEquipment card = CardEquipment();
          card.date = _ferramentaModel.dtEntrega;
          card.lname = 'Ferramenta';
          card.fname = _ferramentaModel.nome;
          card.image = 'assets/images/settings_78352.png';
          listaEquipamentosSelect.add(card);
        }
      });
    }
    catch (e){
      print(e);
    }

    //RECUPERA OS VEICULOS PARA EXIBIR NA HOME
    try {
      await FirebaseFirestore.instance.collection(FirebaseConst.veiculos)
          .where(
          "alocado", isEqualTo: _profissionalModel.id)
          .get()
          .then((querySnapshot) {

        for (var docSnapshot in querySnapshot.docs) {

          Map<String, dynamic> response = docSnapshot.data();
          _veiculoModel = VeiculoModel.fromMap(response, docSnapshot.reference.id);
          CardEquipment card = CardEquipment();
          card.date = _veiculoModel.dtModf;
          card.lname = 'Veículo';
          card.fname = _veiculoModel.nome;
          card.image = 'assets/images/ExecutiveCar_Black.png';
          listaEquipamentosSelect.add(card);
        }
      });
    }
    catch (e){
      print(e);
    }

  }
  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(
            height: 25,
          ),
          _buildBalance(),
          const SizedBox(
            height: 35,
          ),
          _buildServices(),
          const SizedBox(
            height: 25,
          ),
          Container(
            padding: const EdgeInsets.all(15),
            alignment: Alignment.centerLeft,
            child: const Text(
              "Equipamentos Alocados",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15,left: 15),
            child: _buildEquipments(),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 15),
            child: _buildTransactionTitle(),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: _buildTransanctions(),
          ),
        ],
      ),
    );
  }

  _buildHeader() {
    return Container(
      height: 130,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 35),
      decoration: BoxDecoration(
        color: controller.appStore.isDark ?AppColor.shadowColor :AppColor.appBgColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //AvatarImage(urlController.text, isSVG: false, width: 35, height: 35),
          CircleAvatar(
            //radius: 30.0,
            minRadius: 10,
            maxRadius: 25,
            backgroundImage:
            NetworkImage(urlController.text.isNotEmpty ? urlController.text : 'https://e7.pngegg.com/pngimages/455/105/png-clipart-anonymity-computer-icons-anonymous-user-anonymous-purple-violet.png'),
            backgroundColor: Colors.transparent,

          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  'Olá $nomeFuncionario, tenha um excelente dia ',
                    style: const TextStyle(color: material.Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "VISKA DRYWALL",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          _buildNotification()
        ],
      ),
    );
  }

  Widget _buildNotification() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: material.Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: material.Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(1, 1), // changes position of shadow
          ),
        ],
      ),
      child: eos.Badge(
        //padding: const EdgeInsets.all(3),
        position: eos.BadgePosition.topEnd(top: -5, end: 2),
        badgeContent: const Text(
          '',
          style: TextStyle(color: material.Colors.white),
        ),
        child:  IconButton(
          //iconSize: 30,
          icon:  Icon(material.Icons.notifications_rounded),
          // the method which is called
          // when button is pressed
          onPressed: () => Modular.to.pushNamed('/chat'),
        ),
        //Icon(material.Icons.notifications_rounded),
      ),
    );
  }

  Widget _buildTransactionTitle() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Extrato",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Neste Mês",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Icon(material.Icons.expand_more_rounded),
      ],
    );
  }

  Widget _buildBalance() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
           BalanceCard(
            balance: seuSaldo.toStringAsFixed(2),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColor.secondary,
                shape: BoxShape.circle,
                border: Border.all(),
              ),
              child: const Icon(material.Icons.add),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildServices() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: ServiceBox.expense(
            //'Send',
            //iconmaterial.Icons.send_rounded,
            //onPressed: () => Navigator.of(context).pop(),
             onPressed: () => Modular.to.pushNamed('/schedule'),
            bgColor: AppColor.pink,

          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: ServiceBox.revenue(
            onPressed: () => Modular.to.pushNamed('/activity/create', arguments: ProfissionalModel(
                tbProd: _profissionalModel.tbProd,
                nome: _profissionalModel.nome,
                flgAdm: _profissionalModel.flgAdm,
                )),
            bgColor: AppColor.yellow,
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: ServiceBox.material(

            onPressed: () => Modular.to.pushNamed('/material'),//Navigator.of(context).pop(),
            bgColor: AppColor.green,
          ),
        ),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }

  Widget _buildEquipments() {
    var users = listaEquipamentos.map(
          (e) => Padding(
        padding: const EdgeInsets.only(right: 15),
        child: UserBox(user: e),
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 5),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: _buildSearchBox(),
          ),
          ...users
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: material.Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: //const Icon(material.Icons.search_rounded),
          IconButton(
            icon: const Icon(material.Icons.search_rounded),
            tooltip: 'Buscar',
            onPressed: () {
                Modular.to.pushNamed('/equipment', arguments: ProfissionalModel(
                  id:_profissionalModel.id,
                  tbProd: _profissionalModel.tbProd,
                  nome: _profissionalModel.nome,
                  flgAdm: _profissionalModel.flgAdm,
                ));
            },
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        const Text(
          "Buscar",
          style: TextStyle(fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  Widget _buildTransanctions() {
    return
      listaTransacoes.isNotEmpty ?
      Column(
      children: List.generate(
        listaTransacoes.length,
            (index) => TransactionItem(listaTransacoes[index]),
      ),
    ) :
    const Text("Nenhuma informação disponível",style: TextStyle(color: AppColor.purple),);
  }
}

class _profissionalModel {
}