// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:viska_erp_mobile/app/model/AtividadeInsuladora.dart';
import '../../../core/firebase_const.dart';
import '../../../model/AtividadeProducao.dart';
import '../../../model/atividade.dart';
import '../../../model/card_extrato.dart';
import '../../home/store/home_store.dart';


class ExtratoPage extends StatefulWidget {
  const ExtratoPage({super.key});

  @override
  State<ExtratoPage> createState() => _ExtratoPageState();
}

class _ExtratoPageState extends State<ExtratoPage> {
  String name = "";
  final HomeStore controller = Modular.get();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  late List<Map<String, dynamic>> data;
  DateTime _dobCrt = DateTime.now();
  DateTime _dobCrtFinal = DateTime.now();
  String _dataInicial = '';
  String _dataFinal = '';
  late List<CardExtrato> listaExtrato = [];
  late List<CardExtrato> listaExtratoSelect = [];
  late List<AtividadeModel> listaAtividades = [];
  late List<AtividadeModel> listaAtividadesDB = [];
  late List<AtividadeProducaoModel> tbProducao = [];
  late List<AtividadeInsuladoraModel> tbInsuladora = [];

  void onInit() async {
    await controller.recoverUserData();
    setState(() {
      nameController.text = controller.userModel.name;
      emailController.text = controller.userModel.email;
    });

   // _selectDate(context);

    await getData(null,null);
    //PREENCHE O CARD DE EXTRATO
    setState(() {
      listaExtrato = listaExtratoSelect;
    });
  }

  Future<void> getData(DateTime ?dtInicio,DateTime ?dtFim) async{
    //RECUPERA TODAS AS ATIVIDADES DO PROFISSIONAL

    if(dtInicio == null) {
      try {
        await FirebaseFirestore.instance.collection('atividade')
            .where("profissional", isEqualTo: emailController.text)
            .orderBy("dtModificacao",descending: true)
            .limit(30)
            .get()
            .then((querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            Map<String, dynamic> response = docSnapshot.data();
            listaAtividades.add(
                AtividadeModel.fromMap(response, docSnapshot.reference.id));
          }
        });
      }
      catch (e) {
        print(e);
      }
    }else{
      //listaAtividadesDB = listaAtividades;
      listaAtividades = [];
      listaExtratoSelect = [];
      listaExtrato = [];

      await FirebaseFirestore.instance.collection('atividade')
          .where("profissional", isEqualTo: emailController.text)
          .orderBy("dtModificacao",descending: true)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> response = docSnapshot.data();
          listaAtividades.add(
              AtividadeModel.fromMap(response, docSnapshot.reference.id));
        }
      });
      listaAtividadesDB = listaAtividades;
        
        var toRemove = [];

        for(var atividade in listaAtividadesDB){

          DateTime dateTime1 = DateTime.parse(atividade.dtModificacao!.toDate().toString());
           //data fim depois do range elimina
             if(dtFim!.isAfter(dateTime1) && DateUtils.isSameDay(dateTime1, dtFim) == false) {
               toRemove.add(atividade.id);
             }
          //data de início antes do range elimina
            if(dtInicio!.isBefore(dateTime1) && DateUtils.isSameDay(dateTime1, dtFim) == false) {
              toRemove.add(atividade.id);
          }

        }

        for(var atv in toRemove){
          listaAtividades.removeWhere((item) => item.id == atv);
        }

    }
    //SELECIONA OS VALORES DA TAREFA
    try {
    for (var atividade in listaAtividades)
    {
      if(atividade.tabela.length == 1){

        await FirebaseFirestore.instance.collection(FirebaseConst.atividadeProducao).where("idAtividade", isEqualTo:atividade.id ).get().then(
                (querySnapshot)
            {
              for (var docSnapshot in querySnapshot.docs) {
                Map<String, dynamic> response = docSnapshot.data();
                var producaoModel = AtividadeProducaoModel.fromMap(response,docSnapshot.id);
                CardExtrato cardExtrato = CardExtrato();
                cardExtrato.nomeObra = atividade.nomeObra;
                cardExtrato.dataAtividade = atividade.data;
                cardExtrato.valor = producaoModel.totalProfissional;
                cardExtrato.idAtividade = atividade.tabela.length == 1 ? 'Atividade Produção' : 'Atividade Insuladora';

                /*if(_dataInicial.isNotEmpty){
                  if(_dataInicial )
                }*/
                listaExtratoSelect.add(cardExtrato);
              }
            });
      }
      else{

        await FirebaseFirestore.instance.collection(FirebaseConst.atividadeInsuladora).where("idAtividade", isEqualTo:atividade.id ).get().then(
                (querySnapshot)
            {
              for (var docSnapshot in querySnapshot.docs) {
                Map<String, dynamic> response = docSnapshot.data();

                var insuladoraModel = AtividadeInsuladoraModel.fromMap(response,docSnapshot.id);
                CardExtrato cardExtrato = CardExtrato();
                cardExtrato.nomeObra = atividade.nomeObra;
                cardExtrato.dataAtividade = atividade.data;
                cardExtrato.valor = insuladoraModel.totalProfissional;
                cardExtrato.idAtividade = atividade.tabela.length == 1 ? 'Atividade Produção' : 'Atividade Insuladora';
                if(insuladoraModel.totalProfissional > 0){
                  listaExtratoSelect.add(cardExtrato);
                  }
              }
            });

      }
    }
    }
    catch (e){
      print(e);
    }

    setState(() {
      listaExtrato = listaExtratoSelect;
    });
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
            child: Icon(Icons.autorenew, color: Colors.white),
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
                    child: Text('\$ ${card.valor.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.white))),
              ),
            ],
          ),
          trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
            /*if(card.tipo == 'P') {
              Modular.to.pushNamed('/activity/detail/', arguments: CardTabela(
                  id: card.id,
                  tipo: card.tipo,
                  title: card.title,
                  level: card.level,
                  indicatorValue: card.indicatorValue,
                  price: card.price,
                  quantity: card.quantity));
            }else{
              Modular.to.pushNamed('/activity/detailInsul/', arguments: CardTabela(
                  id: card.id,
                  tipo: card.tipo,
                  title: card.title,
                  level: card.level,
                  indicatorValue: card.indicatorValue,
                  price: card.price,
                  quantity: card.quantity));
            }*/
            /* Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DetailPage(card: card, tbProd: tipoTabela)));*/
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

    final makeBody = Container(
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: listaExtrato.isNotEmpty ? ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: listaExtrato.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(listaExtrato[index]);
        },
      ) : Center(child:Text('Nenhuma informação disponível',style: TextStyle(color:Colors.red),))
    );

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
                getData(_dobCrt,_dobCrtFinal)
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
      title: Text("Extrato de Pagamento",style: TextStyle(color:Colors.white),),
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

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Data inicial',style: TextStyle(color: Colors.white),),
                    style:  ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                    ),
                  ),
                  SizedBox(width: 10,),
                  ElevatedButton(
                  onPressed: () => _selectDateFinal(context),
                    child: const Text('Data final',style: TextStyle(color: Colors.white)),
                    style:  ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                    ),
                  ),
                  SizedBox(width: 10,),
                  IconButton(
                  onPressed: ()  => {},
                  icon: Icon(Icons.search_rounded)
                  ),
                ]
            ),*/
            /*child:Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
               // Text("${_dobCrt.toLocal()}".split(' ')[0]),
                const SizedBox(height: 1.0,),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Data inicial'),
                  style:  ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                  ),
                ),
                Text("${_dobCrt.toLocal()}".split(' ')[0]),
              ],
            ),*/
          /*child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),*/
        //),
      /*  body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('atividade').snapshots(),
          builder: (context, snapshots) {

            final selectTabela = snapshots.data?.docs
                .where((doc) => doc['profissional'].toLowerCase().contains(emailController.text.toLowerCase())).toList();

            return (snapshots.connectionState == ConnectionState.waiting)
                ? Center(
                    child: CircularProgressIndicator(),
                  )*/
                //:
                  /* ListView.builder(
                    itemCount: selectTabela?.length,//snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;

                      if (data['dtModificacao']
                          .toString()
                          .toLowerCase()
                          .startsWith(_eventDate)) {
                        return ListTile(
                          title: Text(
                            data['obra'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            data['profissional'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          leading: CircleAvatar(
                            //backgroundImage: NetworkImage(data['image']),
                          ),
                        );
                      }
                      return Container();
                    });
          },
        ));*/
  //}
}