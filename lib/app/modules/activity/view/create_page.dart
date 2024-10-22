import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:editable/editable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:viska_erp_mobile/app/model/AtividadeInsuladora.dart';
import 'package:viska_erp_mobile/app/model/AtividadeProducao.dart';
+import 'package:viska_erp_mobile/app/model/accountSeg.dart';
import 'package:viska_erp_mobile/app/model/atividade.dart';
import 'package:viska_erp_mobile/app/model/formam.dart';
import 'package:viska_erp_mobile/app/model/profissional.dart';
//import 'package:simple_flutter_firebase_crud/constants/collection.dart';
import 'package:viska_erp_mobile/app/model/user.dart';
import 'package:intl/intl.dart';

import '../../../../flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/firebase_const.dart';
import '../../../model/obra.dart';
import '../../../model/tbInsuladora.dart';
import '../../../model/tbProducao.dart';
import '../../../model/tipoTabelaProfissional.dart';
import '../../../widgets/alert.dart';
import '../../home/store/home_store.dart';

class CreatePage extends StatefulWidget {
  CreatePage({Key? key,required this.profissional}) : super(key: key);
  ProfissionalModel profissional;
  //static const routeName = "/create";

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {

  String? selectedValue;
  final _ageCrt = TextEditingController();
  DateTime _dobCrt = DateTime.now();
  late UserModel _user;
  late final ProfissionalModel _profissionalModel = ProfissionalModel();
  AtividadeModel _atividadeModel = AtividadeModel();
  late ProfissionalModel profissionalDB = ProfissionalModel();
  late ProfissionalModel profissional = ProfissionalModel();
  late FormamModel _formamModel = FormamModel();
  late FormamModel _formamDB = FormamModel();
  late List<ProducaoModel> listaProducao = [];
  late List<InsuladoraModel> listaInsuladora = [];
  final HomeStore controller = Modular.get();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController(text: 'initial value');
  TextEditingController tbProdController = TextEditingController();
  TextEditingController unidadeController = TextEditingController();
  TextEditingController alturaController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  Map<String, dynamic> data = {};
  late final CollectionReference? _profissionais;
  bool _pressedCreate = false;
  bool _disabled = true;
  final _statesController = WidgetStatesController();
  final _statesAvancar = WidgetStatesController();
  final _editableKey = GlobalKey<EditableState>();
  /*List rowsProducao = [
    {
      "folha": '8 (1/2)',
      "qtde": '',
      "ft": '',
      "status": 'completed'
    },
    {
      "folha": '9 (1/2)',
      "ft": '',
      "status": 'new',
      "qtde": '',
    },
    {
      "ft": '',
      "folha": '10 (1/2)',
      "qtde": '',
      "status": 'expert'
    },
    {
      "folha": '11 (1/2)',
      "status": '',
      "qtde": '',
      "ft": '',
    },
    {
      "folha": '12 (1/2)',
      "status": '',
      "qtde": '',
      "ft": '',
    },
    {
      "folha": '8 (5/8)',
      "status": '',
      "qtde": '',
      "ft": '',
    },
    {
      "folha": '9 (5/8)',
      "status": '',
      "qtde": '',
      "ft": '',
    },
    {
      "folha": '10 (5/8)',
      "status": '',
      "qtde": '',
      "ft": '',
    },
    {
      "folha": '11 (5/8)',
      "status": '',
      "qtde": '',
      "ft": '',
    },
    {
      "folha": '12 (5/8)',
      "status": '',
      "qtde": '',
      "ft": '',
    },
  ];*/
  List rowsProducao = [];
  List colsProducao = [
    {"title": 'Folha DryWall', 'widthFactor': 0.5, 'key': 'folha', 'editable': false},
    {"title": 'Quantidade', 'widthFactor': 0.3, 'key': 'qtde'},
    {"title": 'FT', 'widthFactor': 0.2, 'key': 'ft'},
    //{"title": 'Status', 'key': 'status'},
  ];

  List rowsInsuladora = [
    {
      "tipo": 'ROSA',
      "qtde": '',
      "soft": '',
    },
    {
      "tipo": 'ROXEL',
      "qtde": '',
      "soft": '',
    },
    {
      "tipo": 'STIQUIPIN',
      "qtde": '',
      "soft": '',
    },

  ];
  List colsInsuladora= [
    {"title": 'Tipo', 'widthFactor': 0.4, 'key': 'tipo', 'editable': false},
    {"title": 'Quantidade', 'widthFactor': 0.3, 'key': 'qtde'},
    {"title": 'SoftBag', 'widthFactor': 0.3, 'key': 'soft'},
    //{"title": 'Status', 'key': 'status'},
  ];
  List listColumns = [];
  List listRows = [];

  @override
  void initState() {
    _ageCrt.text = "18";
    profissional = Modular.args.data;

    onInit();
    //_profissionais = FirebaseFirestore.instance.collection('profissionais');

    if(profissional.idTipoProfissional == 'P') {

      rowsProducao = [];
      for (var row in profissional.listaTBProd) {
        setState(() {
          listRows.add( {
            "folha": row.drywall,
            "qtde": '',
            "ft": '',
            "status": ''
          });
        });
      }
      setState(() {
        listColumns = colsProducao;
        //listRows = rowsProducao;
      });


    }
    else {
      setState(() {
        listColumns = colsInsuladora;
        listRows = rowsInsuladora;
        //listRows = profissional.listaTBProd;
      });
    }
    super.initState();

  }

  void _addNewRow() {
    setState(() {
      _editableKey.currentState?.createRow();
    });
  }

  ///Print only edited rows.
  void _printEditedRows() {
    List editedRows = _editableKey.currentState!.editedRows;
    print(editedRows);
    for(var row in editedRows){

    }
  }

  void onInit() async {
    await controller.recoverUserData();
    setState(() {
      nameController.text = controller.userModel.name;
      emailController.text = controller.userModel.email;
    });

    _statesController.update(
      WidgetState.disabled,
      false, // or false depending on your logic
    );
    _statesAvancar.update(
      WidgetState.disabled,
      true, // or false depending on your logic
    );

    profissional = Modular.args.data;

    //_selectTbUser(emailController.text);
    /*FirebaseFirestore.instance
        .collection('profissionais')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      // Update the TextFormField value here
      firstNameController.text = snapshot.docs.first['tbProd'];
    });*/

    //await fillExcelTituloColuna();

    await getFormamByEmail();

    setState(() {
      _formamModel = _formamDB;
    });

  }
  Future<void> getFormamByEmail() async{
    try{
      await FirebaseFirestore.instance.collection("formam")
          .where("email", isEqualTo: emailController.text)
          .get()
          .then(
            (querySnapshot) {

          for (var docSnapshot in querySnapshot.docs) {
            Map<String, dynamic> response = docSnapshot.data();
            _formamDB = FormamModel.fromMap(response,docSnapshot.reference.id);
          }

        },
        onError: (e) => print("Error completing: $e"),
      );
    }
    catch (e){

      print(e);

    }
  }

  Future<void> fillExcelTituloColuna() async{

    if(profissional.idTipoProfissional == 'P'){
      rowsProducao = [];
      for (var row in profissional.listaTBProd) {
         rowsProducao.add( {
            "folha": row.drywall,
            "qtde": '',
            "ft": '',
            "status": ''
          });
      }
    }
    else{
      rowsInsuladora = [];
      for (var row in listaInsuladora) {
        rowsInsuladora.add( {
          "tipo": row.tipo,
          "qtde": '',
          "soft": ''
        });
      }
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
      });
    }
  }

  /* Future<bool> _selectTbUser(String email) async {
    final data = await FirebaseFirestore.instance
        .collection('profissionais')
        .where('email', isEqualTo: email)
        .get();

    if (data.docs.isNotEmpty) {
      //user exists
     profissionalDB = data.docs.first.data();
      print('user exists: ${data.docs.first.data()}');

     setState(() {
       profissionalDB = data.docs.first.data();
     });
      return true;
    } else {
      //user doesn't exists
      print(profissionalDB);
      return false;
    }
  }*/

  var selectedObra, selectedType,selectedTabela,idAtividade;
  final GlobalKey<FormState> _formKeyValue = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          leading: IconButton(
              icon: const Icon(
                FontAwesomeIcons.backward,
                color: Colors.white,
              ),
              onPressed: () => Modular.to.pop()),
          title: Container(
            alignment: Alignment.center,
            child: const Text("Atividades",
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
          actions: const <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.addressCard,
                size: 20.0,
                color: Colors.white,
              ),
              onPressed: null,
            ),
          ],
        ),

        body: SingleChildScrollView(
        child: Stack(
        children: <Widget>[
          Form(
            key: _formKeyValue,
        child:
         Column(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               const SizedBox(height: 40.0),
               SizedBox(height: 40.0,width: 300,child:
               StreamBuilder<QuerySnapshot>(
                   stream: FirebaseFirestore.instance
                       .collection("obras")
                       .where("formam", isEqualTo: _formamModel.id)
                       .snapshots(),
                   builder: (context, snapshot) {
                     if (snapshot.hasError) {
                       return Center(
                         child: Text("Ocorreu um erro :${snapshot.error}"),
                       );
                     }
                     List<DropdownMenuItem> programItems = [];
                     if (!snapshot.hasData) {
                       return const CircularProgressIndicator();
                     } else {
                       final selectProgram = snapshot.data?.docs.reversed.toList();
                       if (selectProgram != null) {
                         for (var program in selectProgram) {
                           programItems.add(
                             DropdownMenuItem<String>(
                               value: program.id,
                               child: Text(
                                 program['nome'],
                               ),
                             ),
                           );
                         }
                       }
                       return Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           Expanded(
                               child: SizedBox(height: 70.0,
                                 //Icon(FontAwesomeIcons.warehouse,
                                 // size: 25.0, color: Color(0xff11b719)),
                                 //SizedBox(width: 50.0),
                                 child: DropdownButtonFormField(
                                   //autovalidateMode: AutovalidateMode.always,
                                   items: programItems,
                                   onChanged: (obra) {
                                     const snackBar = SnackBar(
                                       content: Text(
                                         'Obra selecionada.',
                                         style: TextStyle(color: Color(0xff11b719)),
                                       ),
                                     );
                                     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                     setState(() {
                                       selectedObra = obra;
                                     });
                                   },
                                   validator: validateFields(selectedObra),
                                   decoration: const InputDecoration(
                                     enabledBorder: UnderlineInputBorder(
                                       borderSide: BorderSide(color:
                                       Colors.greenAccent),),
                                     focusedBorder: UnderlineInputBorder(
                                       borderSide: BorderSide(color:
                                       Colors.green),),
                                   ),
                                   elevation: 2,
                                   style: const TextStyle(color: Colors.black,
                                       fontSize: 16),
                                   isDense: true,
                                   iconSize: 30.0,
                                   iconEnabledColor: Colors.black,
                                   value: selectedObra,
                                   isExpanded: false,
                                   hint: const Text(
                                     "Selecione a obra em que irá trabalhar",
                                     style: TextStyle(color: Color(0xff11b719)),
                                   ),

                                 ),
                               ))
                         ],
                       );
                     }
                   })),
               const SizedBox(height: 25.0),
               SizedBox(height: 50.0,width: 300,child:
               TextFormField(
                 decoration:  InputDecoration(
                   icon: const Icon(
                     FontAwesomeIcons.calendarDay,
                     color: Colors.blueGrey,
                   ),
                   hintText: DateFormat("dd.MM.yyyy").format(DateTime.now()),
                   labelText: DateFormat("dd.MM.yyyy").format(DateTime.now()),

                 ),
                 keyboardType: TextInputType.datetime,
                 readOnly: true,
               )),
               const SizedBox(height: 20.0),
               SizedBox(height: 50.0,width: 500.0,child:
               StreamBuilder<QuerySnapshot>(
                   stream: FirebaseFirestore.instance
                       .collection(FirebaseConst.tipoTabelaProf)
                       .snapshots(),
                   builder: (context, snapshot) {
                     if (snapshot.hasError) {
                       return Center(
                         child: Text("Ocorreu um erro :${snapshot.error}"),
                       );
                     }
                     List<DropdownMenuItem> tabelaItems = [];
                     if (!snapshot.hasData) {
                       return const CircularProgressIndicator();
                     } else {
                       final selectTabela = snapshot.data?.docs
                           .where((doc) => doc['idtTabela'].contains(profissional.tbProd)).toList();

                       if (selectTabela != null) {
                         for (var tabela in selectTabela) {
                           tabelaItems.add(
                             DropdownMenuItem(
                               value: tabela.id,
                               child: Text(
                                 tabela['desc'],
                               ),
                             ),
                           );

                         }
                       }
                       return Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: <Widget>[
                           const Icon(FontAwesomeIcons.table,
                                color: Colors.blueGrey),
                           const SizedBox(width: 30.0),
                           Padding(
                           padding: const EdgeInsets.only(right: 10.0),
                           child:
                           DropdownButton(
                             items: tabelaItems,
                             onChanged: (tabela) {
                               const snackBar = SnackBar(
                                 content: Text(
                                   'Tabela selecionada.',
                                   style: TextStyle(color: Color(0xff11b719)),
                                 ),
                               );
                               ScaffoldMessenger.of(context).showSnackBar(snackBar);
                               setState(() {
                                 selectedTabela = tabela;
                                 //listRows = rowsProducao;
                               });

                             },
                             value: selectedTabela,
                             isExpanded: false,
                             hint: const Text(
                               "Selecione a Tabela produtiva",
                               style: TextStyle(color: Color(0xff11b719)),
                             ),
                           )),
                         ],
                       );
                     }
                   })),
               const SizedBox(height: 15.0),
               SizedBox(height: 50.0,width: 300,child:
               TextFormField(
                 decoration: const InputDecoration(
                   icon: Icon(
                     FontAwesomeIcons.unity,
                     color: Colors.blueGrey,
                   ),
                   hintText: 'Digite a unidade',
                   labelText: 'Unidade/Floor',
                 ),
                 keyboardType: TextInputType.number,
                 controller: unidadeController,
               )),
               const SizedBox(height: 20),
           SizedBox(height: 50,width:300,child:
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(
                  FontAwesomeIcons.streetView,
                  color: Colors.blueGrey,
                ),
                hintText: 'Digite a altura',
                labelText: 'Altura',
              ),
              keyboardType: TextInputType.streetAddress,
              controller: alturaController,
            )),
          const SizedBox(height: 30),
          SizedBox(height: 600,width: 500,child:
            Editable(
              key: _editableKey,
              columns:  listColumns,
              rows:  listRows,
              zebraStripe: true,
              stripeColor1: Colors.blue[200]!,
              stripeColor2: Colors.green[50]!,
              onRowSaved: (value) {
                print(value);
                _printEditedRows();
              },
              onSubmitted: (value) {
                print(value);
              },
              borderColor: Colors.blueGrey,
              tdStyle: const TextStyle(fontWeight: FontWeight.bold),
              trHeight: 50,
              thStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              thAlignment: TextAlign.center,
              thVertAlignment: CrossAxisAlignment.end,
              thPaddingBottom: 3,
              showSaveIcon: false,
              saveIconColor: Colors.black,
              showCreateButton: true,
              tdAlignment: TextAlign.left,
              tdEditableMaxLines: 100, // don't limit and allow data to wrap
              tdPaddingTop: 0,
              tdPaddingBottom: 14,
              tdPaddingLeft: 10,
              tdPaddingRight: 8,
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.all(Radius.circular(0))),
            )),

               if (_pressedCreate)
               //validateFields(_atividadeModel),
                 FutureBuilder(
                   future: idAtividade = _createActivity(_atividadeModel),
                   builder: (context, snapshot) {
                     print("Salvando");
                     if (snapshot.hasData) {
                       if (snapshot.data == false) {
                         return const Text(
                           'Ocorreu um erro!',
                           style: TextStyle(color: Colors.red),
                         );
                       }

                       {
                         const snackBar = SnackBar(
                         content: Text(
                           'Por favor preencha a obra na qual irá trabalhar e a tabela.',
                           style: TextStyle(color: Colors.red),
                         ),
                       );
                       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                       }
                     }
                     _pressedCreate = false;
                     _statesController.update(
                       WidgetState.disabled,
                       true, // or false depending on your logic
                     );
                     _statesAvancar.update(
                       WidgetState.disabled,
                       false, // or false depending on your logic
                     );

                     showMessage();
                     //Modular.to.navigate('/home');
                     return const CircularProgressIndicator();
                   },

                 )
               else
                 const SizedBox.shrink(),
               Column(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: <Widget>[
                     ElevatedButton(
                       onPressed: () {

                         if(selectedObra == null || selectedTabela == null)
                         {const snackBar = SnackBar(
                           content: Text(
                             'Por favor preencha a obra na qual irá trabalhar e a tabela.',
                             style: TextStyle(color: Colors.red),
                           ),
                         );
                         ScaffoldMessenger.of(context).showSnackBar(snackBar);
                         }
                         else
                         {
                           setState(() {
                             _atividadeModel = AtividadeModel.create(
                                 profissional: emailController.text,
                                 obra: selectedObra.toString(),
                                 nomeObra: '',
                                 data: DateFormat("dd.MM.yyyy").format(DateTime.now()),
                                 tabela: selectedTabela.toString(),
                                 unidade: unidadeController.text == '' ? 0 : int.parse(unidadeController.text),
                                 usuario:emailController.text,
                                 dtModificacao: Timestamp.now(),
                                 altura: alturaController.text,
                                 status: 'A'
                             );
                           });
                           _pressedCreate = true;
                           _disabled = false;
                         }},
                       statesController: _statesController,
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.blueGrey,
                         minimumSize: const Size(40,50),
                         maximumSize: const Size(50,50)
                       ),
                       child: const Text("Salvar",style: TextStyle(color: Colors.white)),
                     ),
                     const SizedBox(
                       height: 20.0,
                     ),
                     ElevatedButton(
                       onPressed: () {
                         if(_atividadeModel.tabela.isNotEmpty) {
                           Modular.to.pushNamed('/obra/$idAtividade' );
                         }else{
                           {const snackBar = SnackBar(
                             content: Text(
                               'Por favor salve primeiro sua atividade',
                               style: TextStyle(color: Colors.red),
                             ),
                           );
                           ScaffoldMessenger.of(context).showSnackBar(snackBar);
                           }
                         }
                       },
                       statesController: _statesAvancar,
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.blueGrey,
                           minimumSize: const Size(40,50),
                           maximumSize: const Size(50,50)
                       ),
                       child: const Text("Fotos da obra",style: TextStyle(color: Colors.white)),
                     ),
                     const SizedBox(
                       height: 15.0,
                     ),
             ]
       )
    ]
    )
          )]
        )

        )
    );


  }

 /* void trocaTabelaProdutiva(selectTabela){
    if(selectTabela.toString().length == 1) {
      setState(() {
        listRows = rowsProducao;
        listColumns = colsProducao;
      });
    }else {
      setState(() {
        listRows = rowsInsuladora;
        listColumns = colsInsuladora;
      });
    }

  }*/
  Future<dynamic> showMessage() async{
     WidgetsBinding.instance.addPostFrameCallback((_) => alertDialog(
        context,
        AlertType.info,
        AppLocalizations.of(context)!.save.toUpperCase(),
        'Atividades salvas com sucesso'));
  }

  Future<DocumentReference> _createActivity(AtividadeModel atividade) async {
    final db = FirebaseFirestore.instance;
    // await db.collection(Collection.users).add(user.toJson());
    var tbProd;
    ProfissionalModel profDB =  ProfissionalModel();
    DocumentReference docRef;

    /*await db.collection("profissionais").where("email", isEqualTo: emailController.text).get().then(
          (querySnapshot) {

        for (var docSnapshot in querySnapshot.docs) {
          //print('${docSnapshot.id} => ${docSnapshot.data()}');
          //var value = Map<String, dynamic>.from(snapshot.value as Map);
          Map<String, dynamic> response = docSnapshot.data();
          profDB = ProfissionalModel.fromMap(response);
        }

      },
      onError: (e) => print("Error completing: $e"),
    );*/
    //validateFields(atividade);
    atividade.tabela = profissional.tbProd;//profDB.tbProd;

    DocumentSnapshot snapshot =
    await db.collection(FirebaseConst.obra)
        .doc(atividade.obra)
        .get();
    final obraModel = ObraModel.fromMap(snapshot.data() as Map,'');

    atividade.nomeObra = obraModel.nome;
    try {
     docRef = await db
          .collection("atividade")
          .withConverter(
        fromFirestore: AtividadeModel.fromFirestore,
        toFirestore: (value, options) {
          return atividade.toFirestore();
        },
      )
          //.doc()
          .add(atividade);

    }
    catch (e)
    {
      print(e.toString());
      throw Exception(e.toString());
    } finally
    {
      await Future.delayed(const Duration(milliseconds: 1000));
    }
    setState(() {
      idAtividade = docRef.id;
    });
    _createWorkTables(idAtividade,profissional.tbProd);
    return docRef;
  }

  Future<num> _getLastAccNumber(String type) async {
    final db = FirebaseFirestore.instance;
    AccountSegModel docContabil =  AccountSegModel();

    await db.collection(FirebaseConst.documentoContabil)
        .where("tpDoc", isEqualTo: type)
        .orderBy('doc_number', descending: true)
        .limit(1)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> response = docSnapshot.data();
        docContabil = AccountSegModel.fromMap(response, docSnapshot.reference.id);
      }
    });

    return docContabil.docNumber;
  }


  Future<void> _createAccDocFromProd(AtividadeProducaoModel atividade,DocumentReference docRef) async {
    final db = FirebaseFirestore.instance;
    AccountSegModel bsegModel = AccountSegModel();
    bsegModel.docNumber = await _getLastAccNumber('KR');
    bsegModel.docNumber +=1;
    bsegModel.data = DateFormat("dd.MM.yyyy").format(DateTime.now());
    bsegModel.profissional = atividade.nomeProfissional;
    bsegModel.refkey = docRef.id;
    bsegModel.status = "A";
    bsegModel.tpDoc = "KR";
    bsegModel.urlImagem = controller.userModel.userImage;
    bsegModel.wrbtr = atividade.totalProfissional;

    try {
       await db
          .collection(FirebaseConst.documentoContabil)
          .withConverter(
        fromFirestore: AccountSegModel.fromFirestore,
        toFirestore: (value, options) {
          return bsegModel.toFirestore();
        },
      )
          .add(bsegModel);
    }
    catch (e)
    {
      print(e.toString());
      throw Exception(e.toString());
    }

    bsegModel.docNumber = await _getLastAccNumber("DZ");
    bsegModel.docNumber +=1;
    bsegModel.tpDoc = "DZ";
    bsegModel.wrbtr = atividade.totalEmpresa;

    try {
      await db
          .collection(FirebaseConst.documentoContabil)
          .withConverter(
        fromFirestore: AccountSegModel.fromFirestore,
        toFirestore: (value, options) {
          return bsegModel.toFirestore();
        },
      )
          .add(bsegModel);
    }
    catch (e)
    {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> _createAccDocFromInsul(AtividadeInsuladoraModel atividade,DocumentReference docRef) async {

    final db = FirebaseFirestore.instance;
    AccountSegModel bsegModel = AccountSegModel();
    bsegModel.docNumber = await _getLastAccNumber('KR');
    bsegModel.docNumber +=1;
    bsegModel.data = DateFormat("dd.MM.yyyy").format(DateTime.now());
    bsegModel.profissional = atividade.nomeProfissional;
    bsegModel.refkey = docRef.id;
    bsegModel.status = "A";
    bsegModel.tpDoc = "KR";
    bsegModel.urlImagem = controller.userModel.userImage;
    bsegModel.wrbtr = atividade.totalProfissional;

    try {
      await db
          .collection(FirebaseConst.documentoContabil)
          .withConverter(
        fromFirestore: AccountSegModel.fromFirestore,
        toFirestore: (value, options) {
          return bsegModel.toFirestore();
        },
      )
          .add(bsegModel);
    }
    catch (e)
    {
      print(e.toString());
      throw Exception(e.toString());
    }

    bsegModel.docNumber = await _getLastAccNumber("DZ");
    bsegModel.docNumber +=1;
    bsegModel.tpDoc = "DZ";
    bsegModel.wrbtr = atividade.totalEmpresa;

    try {
      await db
          .collection(FirebaseConst.documentoContabil)
          .withConverter(
        fromFirestore: AccountSegModel.fromFirestore,
        toFirestore: (value, options) {
          return bsegModel.toFirestore();
        },
      )
          .add(bsegModel);
    }
    catch (e)
    {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> _createWorkTables(String idAtividade,String tipoTabela) async {
    final db = FirebaseFirestore.instance;
    DocumentReference docRef;
    // await db.collection(Collection.users).add(user.toJson());
    String tbProd;
    List<ProducaoModel> tbProducao = [];
    List<InsuladoraModel> tbInsuladora = [];
    ProducaoModel producaoModel = ProducaoModel();
    InsuladoraModel insuladoraModel = InsuladoraModel();
    List editedRows = _editableKey.currentState!.editedRows;
    TipoTabelaProfissionalModel tipoTabelaProfModelDB = TipoTabelaProfissionalModel();

    try {
      DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection(FirebaseConst.tipoTabelaProf)
          .doc(profissional.id)
          .get();
      tipoTabelaProfModelDB = TipoTabelaProfissionalModel.fromMap(snapshot.data() as Map, snapshot.reference.id);
    }
    catch(e) {
      print(e);
    }

    tbProd = tipoTabelaProfModelDB.idtTabela;

    for (int i = 0; i < editedRows.length; i++) {

      if (tipoTabelaProfModelDB.tipo == 'P') {

        AtividadeProducaoModel atividadeProd = AtividadeProducaoModel();
        atividadeProd.idAtividade = idAtividade;
        atividadeProd.totalProfissional = 0;
        atividadeProd.totalEmpresa = 0;
        atividadeProd.drywall = getRowTypeProd(editedRows[i]['row']);

        await db.collection(tbProd).where("drywall", isEqualTo: atividadeProd.drywall).get().then(
              (querySnapshot) {

            for (var docSnapshot in querySnapshot.docs) {
              Map<String, dynamic> response = docSnapshot.data();
              producaoModel = ProducaoModel.fromMap(response);
            }

          },
          onError: (e) => print("Error completing: $e"),
        );

        atividadeProd.usEmpresa = producaoModel.usEmpresa;
        atividadeProd.usProfissional = producaoModel.usProfissional;

        //preenchimento do usuário
        if(editedRows[i]['ft'] != '') {
          atividadeProd.psqt = int.parse(editedRows[i]['ft']);
        }
        if(editedRows[i]['qtde'] != '') {
          atividadeProd.quantidade = int.parse(editedRows[i]['qtde']);
        }
        atividadeProd.totalSoft =  ( atividadeProd.quantidade * atividadeProd.psqt);
        atividadeProd.totalProfissional = ( atividadeProd.totalSoft * atividadeProd.usProfissional );
        //total Empresa
        atividadeProd.totalEmpresa = ( atividadeProd.totalSoft * atividadeProd.usEmpresa );
        atividadeProd.url = controller.userModel.userImage;
        atividadeProd.emailProfissional = controller.userModel.email;
        atividadeProd.nomeProfissional = controller.userModel.name;

        try {
          docRef = await db
              .collection("tbAtividadeProducao")
              .withConverter(
            fromFirestore: AtividadeProducaoModel.fromFirestore,
            toFirestore: (value, options) {
              return atividadeProd.toFirestore();
            },
          )
           //.doc()
              .add(atividadeProd);
        }
        catch (e) {
          print(e.toString());
          throw Exception(e.toString());
        }

        //Salva os documentos contábeis
         await _createAccDocFromProd(atividadeProd,docRef);

        //}
      }
      else {
        /*for (var tabela in tbInsuladora) {*/

        AtividadeInsuladoraModel atividadeInsul = AtividadeInsuladoraModel();
        atividadeInsul.idAtividade = idAtividade;
        atividadeInsul.quantidade = 0;
        atividadeInsul.tipoBag = getRowTypeInsul(editedRows[i]['row'].toString());

        await db.collection(tbProd).where("tipo", isEqualTo: atividadeInsul.tipoBag).get().then(
              (querySnapshot) {

            for (var docSnapshot in querySnapshot.docs) {
              Map<String, dynamic> response = docSnapshot.data();
              insuladoraModel = InsuladoraModel.fromMap(response);
            }

          },
          onError: (e) => print("Error completing: $e"),
        );

        atividadeInsul.usEmpresa = insuladoraModel.usEmpresa;
        atividadeInsul.usProfissional = insuladoraModel.usProfissional;

        //preenchimento do usuário
        if(editedRows[i]['soft'] != '') {
          atividadeInsul.qtdSoftBag = int.parse(editedRows[i]['soft']);
        }
        if(editedRows[i]['qtde'] != '') {
          atividadeInsul.quantidade = int.parse(editedRows[i]['qtde']);
        }
        atividadeInsul.totalSoft =  ( atividadeInsul.quantidade * atividadeInsul.qtdSoftBag);
        atividadeInsul.totalProfissional = ( atividadeInsul.totalSoft * atividadeInsul.usProfissional );
        //total Empresa
        atividadeInsul.totalEmpresa = ( atividadeInsul.totalSoft * atividadeInsul.usEmpresa );
        atividadeInsul.url = controller.userModel.userImage;
        atividadeInsul.emailProfissional = controller.userModel.email;
        atividadeInsul.nomeProfissional = controller.userModel.name;

          try {
           docRef =  await db
                .collection("tbAtividadeInsuladora")
                .withConverter(
              fromFirestore: AtividadeInsuladoraModel.fromFirestore,
              toFirestore: (value, options) {
                return atividadeInsul.toFirestore();
              },
            )
            //.doc()
                .add(atividadeInsul);
          }
          catch (e) {
            print(e.toString());
            throw Exception(e.toString());
          }
          //salva o documento na contabilidade

         await _createAccDocFromInsul(atividadeInsul,docRef);
        //}
      }
    }
  }

   validateFields(dynamic value) {
    if (value == "") {
      return [AlertType.info, "Por favor preencha todos os campos"];
      return("Por favor preencha todos os campos");

    }
    return null;
  }

  String getRowTypeProd( int row){

    return profissional.listaTBProd[row].drywall;
    /*switch (row) {
      case '0':
        return '8 (1/2)';
        break;
      case '1':
        return '9 (1/2)';
        break;
      case '2':
        return '10 (1/2)';
        break;
      case '3':
        return '11 (1/2)';
        break;
      case '4':
        return '12 (1/2)';
        break;
      case '5':
        return '8 (5/8)';
        break;
      case '6':
        return '9 (5/8)';
        break;
      case '7':
        return '10 (5/8)';
        break;
      case '8':
        return '11 (5/8)';
        break;
      case '9':
        return '12 (5/8)';
        break;
      default:
        return 'Não selecionada';
    }*/
  }
  String getRowTypeInsul(String row){
    switch (row) {
      case '0':
        return 'ROSA';
        break;
      case '1':
        return 'ROXEL';
        break;
      case '2':
        return 'STIQUIPIN';
        break;
      default:
        return 'Não selecionada';
    }
  }

  String getTableText(String tabela){
    switch (tabela) {
      case '1':
       return 'Tabela Produção Nível 1';
       break;
      case '2':
        return 'Tabela Produção Nível 2';
        break;
      case '3':
        return 'Tabela Produção Nível 3';
        break;
      case '4':
        return 'Tabela Produção Nível 4';
        break;
      case '11':
        return 'Tabela Insuladora Nível 1';
        break;
      case '12':
        return 'Tabela Insuladora Nível 2';
        break;
      case '13':
        return 'Tabela Insuladora Nível 3';
        break;
      case '14':
        return 'Tabela Insuladora Nível 4';
        break;
      default:
        return 'Não selecionada';
    }

    return "";
  }
}