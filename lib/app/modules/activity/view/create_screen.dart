import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:viska_erp_mobile/app/model/AtividadeInsuladora.dart';
import 'package:viska_erp_mobile/app/model/AtividadeProducao.dart';
import 'package:viska_erp_mobile/app/model/atividade.dart';
import 'package:viska_erp_mobile/app/model/profissional.dart';
//import 'package:simple_flutter_firebase_crud/constants/collection.dart';
import 'package:viska_erp_mobile/app/model/user.dart';
import 'package:intl/intl.dart';

import '../../../core/firebase_const.dart';
import '../../../model/obra.dart';
import '../../../model/tbInsuladora.dart';
import '../../../model/tbProducao.dart';
import '../../home/store/home_store.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({Key? key}) : super(key: key);

  static const routeName = "/create";

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {

  String? selectedValue;
  final _ageCrt = TextEditingController();
  DateTime _dobCrt = DateTime.now();
  late UserModel _user;
  late ProfissionalModel _profissionalModel;
  AtividadeModel _atividadeModel = AtividadeModel();
  static var profissionalDB;
  final HomeStore controller = Modular.get();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController(text: 'initial value');
  TextEditingController tbProdController = TextEditingController();
  TextEditingController unidadeController = TextEditingController();
  TextEditingController alturaController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  Map<String, dynamic> data = {};
  CollectionReference? _profissionais;
  bool _pressedCreate = false;
  bool _disabled = true;
  final _statesController = WidgetStatesController();
  final _statesAvancar = WidgetStatesController();

  @override
  void initState() {
    _ageCrt.text = "18";
    onInit();
    _profissionais = FirebaseFirestore.instance.collection('profissionais');
    super.initState();
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
      false, // or false depending on your logic
    );

    //_selectTbUser(emailController.text);
    /*FirebaseFirestore.instance
        .collection('profissionais')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      // Update the TextFormField value here
      firstNameController.text = snapshot.docs.first['tbProd'];
    });*/

    //var collectionProfissional = FirebaseFirestore.instance.collection('profissionais');
    /*collection.snapshots().listen((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();
        if( data['email'].toString() == emailController.text.toString()) {
          var tbProd = data['tbProd'].toString(); // <-- Retrieving the value.
          tbProdController.text = tbProd;
          print(tbProd);
        }
      }
    });*/

    /*FirebaseFirestore.instance.collection('profissionais').where(
        "email", isEqualTo: emailController.text)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((value) {
        data = value.data as Map<String, dynamic>;
        print('printing uid ${data['uid']}');
        print('printing username--${data['username']}');
        print('printing all data--$data');
      });
    });*/
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

   Future<bool> _selectTbUser(String email) async {
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
  }

  var selectedObra, selectedType,selectedTabela,idAtividade;
  final GlobalKey<FormState> _formKeyValue = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
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
        body: Form(
          key: _formKeyValue,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            children: <Widget>[

             /* new TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(
                    FontAwesomeIcons.userCircle,
                    color: Color(0xff11b719),
                  ),
                  hintText: 'Enter your Name',
                  labelText: 'Name',
                ),
              ),*/

              /*new TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(
                    FontAwesomeIcons.envelope,
                    color: Color(0xff11b719),
                  ),
                  hintText: 'Enter your Email Address',
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),*/
             /* SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.building,
                    size: 25.0,
                    color: Color(0xff11b719),
                  ),
                  SizedBox(width: 50.0),
                  DropdownButton(
                    items: _accountType
                        .map((value) =>
                        DropdownMenuItem(
                          child: Text(
                            value,
                            style: TextStyle(color: Color(0xff11b719)),
                          ),
                          value: value,
                        ))
                        .toList(),
                    onChanged: (selectedAccountType) {
                      print('$selectedAccountType');
                      setState(() {
                        selectedType = selectedAccountType;
                      });
                    },
                    value: selectedType,
                    isExpanded: false,
                    hint: Text(
                      'Choose Account Type',
                      style: TextStyle(color: Color(0xff11b719)),
                    ),
                  )
                ],
              ),*/
              const SizedBox(height: 40.0),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("obras")
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
                        mainAxisAlignment: MainAxisAlignment.start,
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
                  }),
              const SizedBox(height: 15.0),
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
              ),
              const SizedBox(height: 15.0,width: 50.0),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("profissionais")
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
                          .where((doc) => doc['email'].toLowerCase().contains(emailController.text.toLowerCase())).toList();

                      if (selectTabela != null) {
                        for (var tabela in selectTabela) {
                            tabelaItems.add(
                              DropdownMenuItem(
                                value: tabela.id,
                                child: Text(
                                  getTableText(tabela['tbProd']),
                                ),
                              ),
                            );

                        }
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Icon(FontAwesomeIcons.table,
                              size: 25.0, color: Colors.blueGrey),
                          const SizedBox(width: 25.0),
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
                              });
                            },
                            value: selectedTabela,
                            isExpanded: false,
                            hint: const Text(
                              "Selecione a tabela produtiva",
                              style: TextStyle(color: Color(0xff11b719)),
                            ),
                          ),
                        ],
                      );
                    }
                  }),


              /*StreamBuilder(
                stream: _profissionais?.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (!streamSnapshot.hasData) {
                  return const CircularProgressIndicator();
                  }
                  else {
                    final List<DocumentSnapshot> profissionais = streamSnapshot
                        .data!.docs
                        .where((doc) =>
                    doc['email'].toLowerCase().contains(
                    emailController.text.toLowerCase(),
                    ))
                        .toList();

                    dynamic data = streamSnapshot.data?.docs.first;

                    return new TextFormField(
                      decoration:  InputDecoration(
                        icon: Icon(
                          FontAwesomeIcons.table,
                          color: Color(0xff11b719),
                        ),
                        hintText: data['tbProd'],
                        labelText: 'Tabela',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          tbProdController.text = data['tbProd'];
                        }
                        tbProdController.text = data['tbProd'];
                      },
                      keyboardType: TextInputType.text,
                      readOnly: true,
                      controller:tbProdController,
                    );
                  }
                }),*/
              const SizedBox(height: 20.0),
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
              ),
              const SizedBox(height: 20.0),
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
              ),
              const SizedBox(
                height: 100.0,
              ),

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

                      /*alertDialog(
                      context,
                      AlertType.error,
                      AppLocalizations.of(context)!.attention,
                      AppLocalizations.of(context)!.userAlreadyExists);*/

                      {const snackBar = SnackBar(
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
                      print(selectedObra.toString() );
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
                            room:'',
                            status: 'A',
                            mes: DateTime.now().month,
                            ano:DateTime.now().year
                        );
                      });
                      _pressedCreate = true;
                      _disabled = false;
                    }},
                    statesController: _statesController,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                    ),
                    child: const Text("Salvar",style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if(_atividadeModel.tabela.isNotEmpty) {
                        _atividadeModel.tabela.length == 1 ? Modular.to.pushNamed('edit/$idAtividade' )  : Modular.to.pushNamed('edit/$idAtividade' ) ;
                      }else{
                          {const snackBar = SnackBar(
                            content: Text(
                              'Por favor salve sua atividade antes de prosseguir.',
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
                    ),
                    child: const Text("Avançar",style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ],
          ),
        ));


  }
  Future<DocumentReference> _createActivity(AtividadeModel atividade) async {
    final db = FirebaseFirestore.instance;
    // await db.collection(Collection.users).add(user.toJson());
    var tbProd;
    ProfissionalModel profDB =  ProfissionalModel();
    DocumentReference docRef;

    await db.collection("profissionais").where("email", isEqualTo: emailController.text).get().then(
          (querySnapshot) {

        for (var docSnapshot in querySnapshot.docs) {
          //print('${docSnapshot.id} => ${docSnapshot.data()}');
          //var value = Map<String, dynamic>.from(snapshot.value as Map);
          Map<String, dynamic> response = docSnapshot.data();
          profDB = ProfissionalModel.fromMap(response,'');
        }

      },
      onError: (e) => print("Error completing: $e"),
    );
    //validateFields(atividade);
    atividade.tabela = profDB.tbProd;

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
    _createWorkTables(idAtividade,atividade.tabela);
    return docRef;
  }

  Future<void> _createWorkTables(String idAtividade,String tipoTabela) async {
    final db = FirebaseFirestore.instance;
    // await db.collection(Collection.users).add(user.toJson());
    String tbProd;
    List<ProducaoModel> tbProducao =  [];
    List<InsuladoraModel> tbInsuladora = [];

    //print("tipoTabela");
    //print(tipoTabela);
    if(tipoTabela.length == 1) {
      tbProd = "tbProd$tipoTabela";
    }
    else{
      tbProd = "tbInsul${tipoTabela.substring(0,1)}";
    }

    //print(tbProd);
    await db.collection(tbProd).get().then(
          (querySnapshot) {

        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> response = docSnapshot.data();
          if(tipoTabela.length == 1) {

            tbProducao.add(ProducaoModel.fromMap(response));
          }
          else
          {
            tbInsuladora.add(InsuladoraModel.fromMap(response));
          }
        }

      },
      onError: (e) => print("Error completing: $e"),
    );

    if(tipoTabela.length == 1) {
      for (var tabela in tbProducao)
        {
          //print(tabela.drywall);
          AtividadeProducaoModel atividadeProd = AtividadeProducaoModel();
          atividadeProd.idAtividade = idAtividade;
          atividadeProd.totalProfissional = 0;
          atividadeProd.totalEmpresa = 0;
          atividadeProd.drywall = tabela.drywall;
          atividadeProd.usEmpresa = tabela.usEmpresa;
          atividadeProd.usProfissional = tabela.usProfissional;
          atividadeProd.psqt = tabela.psqt;
          atividadeProd.quantidade = 0;
          atividadeProd.totalSoft = 0;
          try {
            await db
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
          catch (e)
          {
            print(e.toString());
            throw Exception(e.toString());
          }
        }
    }
     else
      {
        print("tipoTabela");
        print(tipoTabela);
        for (var tabela in tbInsuladora){

          AtividadeInsuladoraModel atividadeInsul = AtividadeInsuladoraModel();
          atividadeInsul.idAtividade = idAtividade;
          atividadeInsul.quantidade = 0;
          atividadeInsul.usEmpresa = tabela.usEmpresa;
          atividadeInsul.usProfissional = tabela.usProfissional;
          atividadeInsul.totalEmpresa = 0;
          atividadeInsul.totalProfissional = 0;
          atividadeInsul.tipoBag = tabela.tipo;
          atividadeInsul.qtdSoftBag = 0;
          atividadeInsul.totalSoft = 0;

          try {
            await db
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
          catch (e)
          {
            print(e.toString());
            throw Exception(e.toString());
          }
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