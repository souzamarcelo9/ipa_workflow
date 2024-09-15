import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:viska_erp_mobile/app/model/AtividadeInsuladora.dart';
import 'package:viska_erp_mobile/app/model/AtividadeProducao.dart';
import '../../../core/firebase_const.dart';
import '../../../model/card_tabela.dart';

class DetailFotoPage extends StatefulWidget {

  CardTabela card ;
  String tbProd = '';

  DetailFotoPage({super.key, required this.card});

  @override
  State<DetailFotoPage> createState() => _DetailFotoPageState();
}

class _DetailFotoPageState extends State<DetailFotoPage> {
  TextEditingController firstNameController = TextEditingController(text: 'initial value');
  TextEditingController tbProdController = TextEditingController();
  TextEditingController unidadeController = TextEditingController();
  TextEditingController quantidadeController = TextEditingController();
  String psqt  = '';
  String totalSQFT = '' ;
  String valorHora = '';
  String totalU$ = '';
  //String tbProd = Modular.args.params['tbProd'];
  CardTabela card = CardTabela();
  late String idAtividade = '';
  late String tipoTabela = '';
  late AtividadeProducaoModel atividadeProducaoModel = AtividadeProducaoModel();
  late AtividadeInsuladoraModel atividadeInsuladoraModel = AtividadeInsuladoraModel();
  late File photoFirebase;

  void onInit() async {
    /*await controller.recoverUserData();
    setState(() {
      nameController.text = controller.userModel.name;
      emailController.text = controller.userModel.email;
      telController.text = controller.userModel.phone;
    });
*/
    card = Modular.args.data;
    photoFirebase =  Image.network(card.tipo) as File;
  }
  @override
  void initState () {
    //card = Modular.args.params['card'];
    onInit();
   // card = Modular.args.params['card'];
    super.initState();
    //card = Modular.args.params['card'];
  }

  @override
  Widget build(BuildContext context) {
    final levelIndicator = Container(
      child: Container(
        child: LinearProgressIndicator(
            backgroundColor: const Color.fromRGBO(209, 224, 224, 0.2),
            value: card.indicatorValue?.toDouble(),
            valueColor: const AlwaysStoppedAnimation(Colors.green)),
      ),
    );

    final coursePrice = Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        card.quantity.toString(),
        style: const TextStyle(color: Colors.white),
      ),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 80.0),
        const Icon(
          Icons.linked_camera,
          color: Colors.white,
          size: 40.0,
        ),
        const SizedBox(
          width: 90.0,
          child: Divider(color: Colors.green),
        ),
        const SizedBox(height: 10.0),
        Text(
          card.title,
          style: const TextStyle(color: Colors.white, fontSize: 45.0),
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 1, child: levelIndicator),
            Expanded(
                flex: 6,
                child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      card.level,
                      style: const TextStyle(color: Colors.white),
                    ))),
            //Expanded(flex: 1, child: coursePrice)
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: const EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/drywall-2.png"),
                fit: BoxFit.cover,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: const EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );

    final bottomContentText =

    Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
            padding: const EdgeInsets.only(left: 15.0),
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(card.tipo),
                        fit: BoxFit.cover)
            ),

              ),
            );
    /*final bottomContentText =
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
      children: [
        new TextFormField(
          decoration: const InputDecoration(
            icon: const Icon(
              FontAwesomeIcons.coins,
              color: Colors.blueGrey,
            ),
            hintText: 'Digite a quantidade',
            labelText: 'Quantidade',
          ),
          keyboardType: TextInputType.number,
          controller: quantidadeController,
        ),

        const SizedBox(height: 20),
      ]
      ));*/
    /*Text(
      card.content,
      style: TextStyle(fontSize: 18.0),
    );*/

    final readButton = Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () async => {
            await saveDetailProducao()
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child:
              const Text("CONFIRMAR", style: TextStyle(color: Colors.white)),
        ));

    final totals =
    DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text(
              'FT',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'SQFT',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Valor',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Total',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
      rows:  <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell( Text(psqt)),
            DataCell(Text(totalSQFT)),
            DataCell(Text(valorHora)),
            DataCell(Text(totalU$)),

          ],
        ),

          ],
        );

    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[bottomContentText],
        ),
      ),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[topContent, bottomContent],
      ),
    );
  }

  Future<void> saveDetailProducao() async{
    var tabela = '';
    DocumentSnapshot snapshot =
    await FirebaseFirestore.instance.collection('tbAtividadeProducao')
        .doc(card.id)
        .get();
    AtividadeProducaoModel atividadeProducao = AtividadeProducaoModel.fromMap(snapshot.data() as Map,'');

    atividadeProducao.quantidade = int.parse(quantidadeController.text);
    //dynamic totalSoft =  quantidade  * atividadeProducao.psqt;
    atividadeProducao.totalSoft =  ( atividadeProducao.quantidade * atividadeProducao.psqt);
    //total profissional
    atividadeProducao.totalProfissional = ( atividadeProducao.totalSoft * atividadeProducao.usProfissional );
    //total Empresa
    atividadeProducao.totalEmpresa = ( atividadeProducao.totalSoft * atividadeProducao.usEmpresa );
    bool atualizou = false;

    try {
      //await _auth.currentUser?.updateEmail(model.email);
      await FirebaseFirestore.instance
          .collection(FirebaseConst.atividadeProducao)
          .doc(card.id)
          .update({
        "quantidade": atividadeProducao.quantidade,
        "totalSoft": atividadeProducao.totalSoft,
        "totalProfissional": atividadeProducao.totalProfissional,
        "totalEmpresa": atividadeProducao.totalEmpresa,
      });
      atualizou = true;
    }
    catch (error)
    {
      print(error);
    }

    setState(() {
      psqt  = atividadeProducao.psqt.toString();
      totalSQFT = atividadeProducao.totalSoft.toString() ;
      valorHora = atividadeProducao.usProfissional.toString();
      totalU$ = atividadeProducao.totalProfissional.toString();
      card.quantity = atividadeProducao.quantidade;
    });

  }
}