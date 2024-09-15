import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:viska_erp_mobile/app/model/AtividadeInsuladora.dart';
import 'package:viska_erp_mobile/app/model/AtividadeProducao.dart';
import '../../../core/firebase_const.dart';
import '../../../model/card_tabela.dart';

class DetailInsuladoraPage extends StatefulWidget {
  //class DetailPage extends StatelessWidget {
  CardTabela card ;
  String tbProd = '';

  DetailInsuladoraPage({super.key, required this.card});

  @override
  //_DetailPageState createState() => _DetailPageState();
  State<DetailInsuladoraPage> createState() => _DetailInsuladoraPageState();
}

class _DetailInsuladoraPageState extends State<DetailInsuladoraPage> {
  TextEditingController firstNameController = TextEditingController(text: 'initial value');
  TextEditingController tbProdController = TextEditingController();
  TextEditingController unidadeController = TextEditingController();
  TextEditingController quantidadeController = TextEditingController();
  TextEditingController softBagController = TextEditingController();
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

  void onInit() async {
    /*await controller.recoverUserData();
    setState(() {
      nameController.text = controller.userModel.name;
      emailController.text = controller.userModel.email;
      telController.text = controller.userModel.phone;
    });
*/
    card = Modular.args.data;

    if(card.tipo == 'P') {
      tipoTabela = 'tbAtividadeProducao';

      DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection(tipoTabela)
          .doc(card.id)
          .get();

      atividadeProducaoModel = AtividadeProducaoModel.fromMap(snapshot.data() as Map,'');

      setState(() {
        psqt  = atividadeProducaoModel.psqt.toString();
        totalSQFT = atividadeProducaoModel.totalSoft.toString();
        valorHora = atividadeProducaoModel.usProfissional.toString();
        totalU$ = atividadeProducaoModel.totalProfissional.toString();
      });

    }else {
      tipoTabela = 'tbAtividadeInsuladora';
      DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection(tipoTabela)
          .doc(card.id)
          .get();
      atividadeInsuladoraModel = AtividadeInsuladoraModel.fromMap(snapshot.data() as Map,'');
      setState(() {
        totalSQFT = atividadeInsuladoraModel.totalSoft.toString();
        valorHora = atividadeInsuladoraModel.usProfissional.toString();
        totalU$ = atividadeInsuladoraModel.totalProfissional.toString();
      });
    }

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
        const SizedBox(height: 120.0),
        const Icon(
          Icons.table_view_sharp,
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
        const SizedBox(height: 30.0),
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
            Expanded(flex: 1, child: coursePrice)
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
      child: Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            icon: Icon(
              FontAwesomeIcons.bagShopping,
              color: Colors.blueGrey,
            ),
            hintText: 'Digite a quantidade de softbags',
            labelText: 'Soft Bag',
          ),
          keyboardType: TextInputType.number,
          controller: softBagController,
        ),

        TextFormField(
          decoration: const InputDecoration(
            icon: Icon(
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
      ));
    /*Text(
      card.content,
      style: TextStyle(fontSize: 18.0),
    );*/

    final readButton = Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () async => {
            await saveDetailInsuladora()
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
          children: <Widget>[bottomContentText, readButton,totals],
        ),
      ),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[topContent, bottomContent],
      ),
    );
  }

  Future<void> saveDetailInsuladora() async{
    var tabela = '';
    DocumentSnapshot snapshot =
    await FirebaseFirestore.instance.collection('tbAtividadeInsuladora')
        .doc(card.id)
        .get();
    AtividadeInsuladoraModel atividadeInsuladora = AtividadeInsuladoraModel.fromMap(snapshot.data() as Map,'');

    atividadeInsuladora.quantidade = int.parse(quantidadeController.text);
    //dynamic totalSoft =  quantidade  * atividadeProducao.psqt;
    atividadeInsuladora.qtdSoftBag = int.parse(softBagController.text);

    atividadeInsuladora.totalSoft =  ( atividadeInsuladora.quantidade * atividadeInsuladora.qtdSoftBag );
    //total profissional
    atividadeInsuladora.totalProfissional = ( atividadeInsuladora.totalSoft * atividadeInsuladora.usProfissional );
    //total Empresa
    atividadeInsuladora.totalEmpresa = ( atividadeInsuladora.totalSoft * atividadeInsuladora.usEmpresa );
    bool atualizou = false;

    try {
      //await _auth.currentUser?.updateEmail(model.email);
      await FirebaseFirestore.instance
          .collection(FirebaseConst.atividadeInsuladora)
          .doc(card.id)
          .update({
        "quantidade": atividadeInsuladora.quantidade,
        "totalSoft": atividadeInsuladora.totalSoft,
        "totalProfissional": atividadeInsuladora.totalProfissional,
        "totalEmpresa": atividadeInsuladora.totalEmpresa,
      });
      atualizou = true;
    }
    catch (error)
    {
      print(error);
    }

    setState(() {
      totalSQFT = atividadeInsuladora.totalSoft.toString() ;
      valorHora = atividadeInsuladora.usProfissional.toString();
      totalU$ = atividadeInsuladora.totalProfissional.toString();
      card.quantity = atividadeInsuladora.quantidade;
    });

  }
}