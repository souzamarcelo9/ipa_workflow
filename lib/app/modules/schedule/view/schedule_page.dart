// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:viska_erp_mobile/app/model/obra.dart';
import '../../../model/formam.dart';
import '../../home/store/home_store.dart';


class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  String name = "";
  final HomeStore controller = Modular.get();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  static TextEditingController textoBuscaController = TextEditingController();
  static  String idFormam = '';
  late FormamModel formamModel = FormamModel();
  late ObraModel obraModel = ObraModel();
  List<ObraModel> listaObra = [];
  List<ObraModel> listaObraDB = [];
  DateTime _dobCrt = DateTime.now();
  DateTime _dobCrtFinal = DateTime.now();
  static String _dataInicial = '';
  static String _dataFinal = '';
  bool filter = false;
  bool _isLoading = false;

  void onInit() async {
    await controller.recoverUserData();
    setState(() {
      nameController.text = controller.userModel.name;
      emailController.text = controller.userModel.email;
    });

    // _selectDate(context);
    setState(() {
      _isLoading = true;
    });

    await getFormamData();
    //await getDataFilter(null,null);
    //Recupera o id do formam para saber quais obras ele está
     setState(() {
      idFormam = formamModel.id;
    });

    /*setState(() {
      listaObra = listaObraDB;
    });*/
  }

  /*addData() async {
    for (var element in data) {
      FirebaseFirestore.instance.collection('users').add(element);
    }
    print('all data added');
  }*/

  @override
  void initState() {
    // TODO: implement initState
    onInit();
    super.initState();
  }


  Future<void> getDataFilter(DateTime ?dtInicio, DateTime ?dtFim,String txtBusca) async {
    //RECUPERA AS OBRAS DO FORMAN
    listaObraDB = [];
    listaObra = [];
    filter = true;

    try {
      await FirebaseFirestore.instance.collection('obras')
          .where("formam", isEqualTo: idFormam)
           //.orderBy("dtEntrega",descending: true)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> response = docSnapshot.data();
          obraModel = ObraModel.fromMap(response,docSnapshot.reference.id);
          listaObraDB.add(obraModel);
        }
      });
    }
    catch (e) {
      print(e);
    }

    var toRemove = [];

    if(dtInicio != null){
      for(var obra in listaObraDB) {
        DateTime dateTime1 = DateTime.parse(obra.dtEntrega!.toDate().toString());
        //data fim depois do range elimina

        if (dtFim!.isBefore(dateTime1) && DateUtils.isSameDay(dateTime1, dtFim) == false) {
          toRemove.add(obra.id);
        }
        //data de início antes do range elimina
        if (dtInicio!.isAfter(dateTime1) && DateUtils.isSameDay(dateTime1, dtFim) == false) {
          toRemove.add(obra.id);
        }
      }

    }

    for(var obra in toRemove){
      listaObraDB.removeWhere((item) => item.id == obra);
    }

    if(txtBusca.isNotEmpty){
      for(var obra in listaObraDB){
        if(obra.nome.contains(txtBusca)) {
          listaObra.add(obra);
        }
      }
      setState(() {
        listaObraDB = [];
        listaObraDB = listaObra;
      });
    }

    //setState(() {
      listaObra = listaObraDB;
        _isLoading = false;
    //});
  }

  Future<void> getFormamData() async {
    //RECUPERA o FORMAM

    try {
      await FirebaseFirestore.instance.collection('formam')
          .where(
          "email", isEqualTo: emailController.text)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> response = docSnapshot.data();
          formamModel = FormamModel.fromMap(response, docSnapshot.reference.id);
        }
      });
    }
    catch (e) {
      print(e);
    }

     setState(() {
       idFormam = formamModel.id;
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            backgroundColor: Colors.pink.shade50,
            appBar: topAppBar,
            body: ListView.builder(
              itemCount: listaObra.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10,bottom: 10),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index){
                return ListTile(
                  title: Text(
                    listaObra[index].dtCriacao.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${listaObra[index].nome}  -  ${listaObra[index].empresa}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/5233/5233805.png'),
                  ),
                );
              },
            ),
            bottomNavigationBar: makeBottom,
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Center(child: Text('Carregando...',style:TextStyle(fontSize: 30),));
        }
      },
      future: getDataFilter(_dobCrt,_dobCrtFinal,''),
    );
  }

  /*Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: topAppBar,
      body: makeBody,
      bottomNavigationBar: makeBottom,
    );
  }*/

  late final topAppBar = AppBar(
      title: Card(
        child: TextField(
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search), hintText: 'Buscar...'),
          controller: textoBuscaController,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) async {
            await getDataFilter(null,null,value);
          },
        ),
      ));

  late final makeBody =
    ListView.builder(
      itemCount: listaObra.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 10,bottom: 10),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index){
        return ListTile(
        title: Text(
           listaObra[index].dtCriacao.toString(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${listaObra[index].nome}  -  ${listaObra[index].empresa}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        leading: CircleAvatar(
          backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/5233/5233805.png'),
        ),
        );
       },
      );
      //:
  /*StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('obras').where("formam", isEqualTo: idFormam).snapshots(),
    builder: (context, snapshots) {
      return (snapshots.connectionState == ConnectionState.waiting)
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
          itemCount: snapshots.data!.docs.length,
          itemBuilder: (context, index) {
            var data = snapshots.data!.docs[index].data()
            as Map<String, dynamic>;

            if (textoBuscaController.text.isEmpty) {
              return ListTile(
                title: Text(
                  data['dtCriacao'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  data['empresa'] + ' - ' + data['nome'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/5233/5233805.png'),
                ),
              );
            }
            if (data['nome']
                .toString()
                .toLowerCase()
                .startsWith(textoBuscaController.text.toLowerCase())) {
              return ListTile(
                title: Text(
                  data['nome'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  data['dtCriacao'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/5233/5233805.png'),
                ),
              );
            }
            return Container();
          });
    },
  );*/


  late final makeBottom = SizedBox(
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
              await getDataFilter(_dobCrt,_dobCrtFinal,'')
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
}