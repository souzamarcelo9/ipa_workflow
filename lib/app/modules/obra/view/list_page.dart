// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:viska_erp_mobile/app/model/AtividadeInsuladora.dart';
import 'package:viska_erp_mobile/app/model/fotoObra.dart';
import '../../../core/firebase_const.dart';
import '../../../model/AtividadeProducao.dart';
import '../../../model/card_extrato.dart';
import '../../../model/card_tabela.dart';
import '../../home/store/home_store.dart';


class ObraListPage extends StatefulWidget {
  const ObraListPage({super.key,required this.userId});
  final String userId;
  @override
  State<ObraListPage> createState() => _ObraListPageState();
}

class _ObraListPageState extends State<ObraListPage> {
  String name = "";
  final HomeStore controller = Modular.get();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  late List<Map<String, dynamic>> data;
  DateTime _dobCrt = DateTime.now();
  DateTime _dobCrtFinal = DateTime.now();
  String _dataInicial = '';
  String _dataFinal = '';
  late List<CardExtrato> listaFotosCard = [];
  late List<CardExtrato> listaFotosCardSelect = [];
  late List<FotoObraModel> listaFotos = [];
  late final FotoObraModel _fotoObraModel = FotoObraModel();
  late List<AtividadeProducaoModel> tbProducao = [];
  late List<AtividadeInsuladoraModel> tbInsuladora = [];
  final _auth = FirebaseAuth.instance;

  void onInit() async {
    await controller.recoverUserData();
    setState(() {
      nameController.text = controller.userModel.name;
      emailController.text = controller.userModel.email;
    });

   // _selectDate(context);

    await getData("","");
    //PREENCHE O CARD
    setState(() {
      listaFotosCard = listaFotosCardSelect;
    });
  }

  Future<void> getData(String dtInicio,String dtFim) async{
    //RECUPERA TODAS AS ATIVIDADES DO PROFISSIONAL

    try {
     await FirebaseFirestore.instance.collection(FirebaseConst.fotoAtividade)
          .where(
          "idUsuario", isEqualTo:_auth.currentUser!.uid )
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> response = docSnapshot.data();
          listaFotos.add(FotoObraModel.fromMap(response, docSnapshot.reference.id));

        }
      });
    }
    catch (e){
      print(e);
    }

    for (var foto in listaFotos)
    {
        CardExtrato cardExtrato = CardExtrato();
        cardExtrato.nomeObra = foto.nomeObra;
        cardExtrato.dataAtividade = foto.dataUpload;
        cardExtrato.idAtividade = foto.idAtividade;
        cardExtrato.tipotabela = foto.urlPhoto;

        listaFotosCardSelect.add(cardExtrato);
      }


  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _dobCrt,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _dobCrt) {
      setState(() {
        _dobCrt = picked;
        _dataInicial = DateFormat('dd/MM/yyyy').format(picked) ;
      });
    }
  }

  Future<void> _selectDateFinal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _dobCrtFinal,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _dobCrtFinal) {
      setState(() {
        _dobCrtFinal = picked;
        _dataFinal = DateFormat('dd/MM/yyyy').format(picked) ;
      });
    }
  }

  addData() async {
    for (var element in data) {
      FirebaseFirestore.instance.collection('users').add(element);
    }
    print('all data added');
  }

  @override
  void initState() {
    // TODO: implement initState
    onInit();
    super.initState();
    //addData();
  }

  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(CardExtrato card) =>
        ListTile(
          contentPadding:
          EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(width: 1.0, color: Colors.white24))),
            child: Icon(Icons.photo_camera, color: Colors.white),
          ),
          title: Text(
            'Obra - ${card.nomeObra}',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

          subtitle: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    // tag: 'hero',
                    child: LinearProgressIndicator(
                        backgroundColor: Color.fromRGBO(
                            255, 255, 255, 1.0),
                        value: card.valor.toDouble(),
                        valueColor: AlwaysStoppedAnimation(Colors.green)),
                  )),
              Expanded(
                flex: 4,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(card.dataAtividade,
                        style: TextStyle(color: Colors.white))),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text('',
                        style: TextStyle(color: Colors.white))),
              ),
            ],
          ),
          trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
              Modular.to.pushNamed('/obra/detailFoto/', arguments: CardTabela(
                  id: card.idAtividade,
                  tipo: card.tipotabela, //url da foto
                  title: card.nomeObra,
                  level: card.dataAtividade,
                  indicatorValue: 100,
                  price: 100,
                  quantity: 1));
          },
        );

    Card makeCard(CardExtrato card) =>
        Card(
          elevation: 8.0,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: makeListTile(card),
          ),
        );

    final makeBody =
    listaFotosCard.isNotEmpty ?
    Container(
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: listaFotosCard.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(listaFotosCard[index]);
        },
      ),
    ) : Center(child:Text("Nenhuma informação foi localizada.",style: TextStyle(color:Colors.redAccent)));

    final makeBottom = SizedBox(
      height: 55.0,
      child: BottomAppBar(
        color: Colors.grey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
                tooltip: 'Home',
                icon: Icon(Icons.home, color: Colors.white),
                onPressed: () => Modular.to.navigate('/home')
            ),
            IconButton(
              tooltip: 'Pesquisar',
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () async =>  {
                getData(_dataInicial,_dataFinal)
              },
            ),
            /*IconButton(
              tooltip: 'Data Inicial',
                icon: Icon(Icons.date_range, color: Colors.white),
              onPressed: () => _selectDate(context),
            ),*/
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child:Row( // Replace with a Row for horizontal icon + text
                children: const <Widget>[
                  Icon(Icons.calendar_month),
                  Text("Início")
                ],
              ),
              /*child: const Text('Data inicial',style: TextStyle(color: Colors.white),),*/
            ),
            ElevatedButton(
              onPressed: () => _selectDateFinal(context),
              child:Row( // Replace with a Row for horizontal icon + text
                children: const <Widget>[
                  Icon(Icons.calendar_month),
                  Text("Fim")
                ],
              ),
           ),
            /*IconButton(
                icon: Icon(Icons.save, color: Colors.white),
                onPressed: () => {}//saveCard()
            )*/
          ],
        ),
      ),
    );

    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.backward,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home')),
      title: Center(child :Text("Lista de Fotos",style: TextStyle(color:Colors.white),)),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {},
        )
      ],
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      body: makeBody,
      bottomNavigationBar: makeBottom,
    );
  }

}