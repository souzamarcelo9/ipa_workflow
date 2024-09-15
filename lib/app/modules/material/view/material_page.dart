// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:viska_erp_mobile/app/model/profissional.dart';
import '../../../../flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/firebase_const.dart';
import '../../../model/material.dart';
import '../../../model/obra.dart';
import '../../../model/user.dart';
import '../../../widgets/alert.dart';
import '../../home/store/home_store.dart';


class MaterialPage extends StatefulWidget {
  const MaterialPage({super.key});

  @override
  State<MaterialPage> createState() => _MaterialPageState();
}

class _MaterialPageState extends State<MaterialPage> {
  String? selectedValue;
  final _ageCrt = TextEditingController();
  DateTime _dobCrt = DateTime.now();
  late UserModel _user;
  late ProfissionalModel _profissionalModel;
  MaterialModel _materialModel = MaterialModel();
  static var profissionalDB;
  final HomeStore controller = Modular.get();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController(text: 'initial value');
  TextEditingController tbProdController = TextEditingController();
  TextEditingController unidadeController = TextEditingController();
  TextEditingController quantidadeController = TextEditingController();
  TextEditingController obsController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  Map<String, dynamic> data = {};
  CollectionReference? _profissionais;
  bool _pressedCreate = false;
  bool _disabled = false;
  final _statesController = WidgetStatesController();
  final _statesAvancar = WidgetStatesController();
  String _dataEntrega = '';
  String txtDataEntrega = 'Para quando';
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

    /*_statesController.update(
      WidgetState.disabled,
      false, // or false depending on your logic
    );
    _statesAvancar.update(
      WidgetState.disabled,
      false, // or false depending on your logic
    );*/

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
        _dataEntrega = DateFormat('dd/MM/yyyy').format(picked) ;
        txtDataEntrega = _dataEntrega;
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

  var selectedObra, selectedType,selectedMaterial,idMaterial;
  final GlobalKey<FormState> _formKeyValue = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          leading: IconButton(
              icon: Icon(
                FontAwesomeIcons.backward,
                color: Colors.white,
              ),
              onPressed: () => Modular.to.pop()),
          title: Container(
            alignment: Alignment.center,
            child: Text("Solicitação de material para:",
                style: TextStyle(
                  color: Colors.black87,
                )),
          ),
          actions: const <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.addressCard,
                size: 20.0,
                color: Colors.black87
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
              SizedBox(height: 40.0),
              SizedBox(width:15.0,child:
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
                                    final snackBar = SnackBar(
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
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color:
                                      Colors.greenAccent),),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color:
                                      Colors.green),),
                                  ),
                                  elevation: 2,
                                  style: TextStyle(color: Colors.black,
                                      fontSize: 16),
                                  isDense: true,
                                  iconSize: 30.0,
                                  iconEnabledColor: Colors.black,

                                  value: selectedObra,
                                  isExpanded: false,
                                  hint: Text(
                                    "Selecione a obra que necessita do material:",
                                    style: TextStyle(color: Color(0xff11b719)),
                                  ),

                                ),
                              ))
                        ],
                      );
                    }
                  })),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("products")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Ocorreu um erro :${snapshot.error}"),
                      );
                    }
                    List<DropdownMenuItem> materialItems= [];
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else {
                      final selectMaterial = snapshot.data?.docs.reversed.toList();
                      if (selectMaterial != null) {
                        for (var material in selectMaterial) {
                          materialItems.add(
                            DropdownMenuItem<String>(
                              value: material['nome'],
                              child: Text(
                                material['nome'],
                              ),
                            ),
                          );
                        }
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              child: SizedBox(height: 50.0,width: 30,
                                //Icon(FontAwesomeIcons.warehouse,
                                // size: 25.0, color: Color(0xff11b719)),
                                child:
                                    SizedBox(width: 10,child:
                                DropdownButtonFormField(
                                  //autovalidateMode: AutovalidateMode.always,
                                  items: materialItems,
                                  onChanged: (mat) {
                                    final snackBar = SnackBar(
                                      content: Text(
                                        'Material selecionado.',
                                        style: TextStyle(color: Color(0xff11b719)),
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    setState(() {
                                      selectedMaterial = mat;
                                    });
                                  },
                                  validator: validateFields(selectedMaterial),
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color:
                                      Colors.greenAccent),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color:
                                      Colors.green),),
                                  ),
                                  elevation: 2,
                                  style: TextStyle(color: Colors.black,
                                      fontSize: 16),
                                  isDense: true,
                                  iconSize: 30.0,
                                  iconEnabledColor: Colors.black,
                                  value: selectedMaterial,
                                  isExpanded: true,
                                  hint: Text(
                                    "Selecione o material para a obra:",
                                    style: TextStyle(color: Color(0xff11b719)),
                                  ),

                                )),
                              ))
                        ],
                      );
                    }
                  }),
              SizedBox(height: 20.0),
              TextFormField(
                decoration:  InputDecoration(
                  icon: Icon(
                    FontAwesomeIcons.calendarDay,
                    color: Colors.blueGrey,
                  ),
                  hintText: _dataEntrega,
                  labelText: txtDataEntrega,
                ),
                keyboardType: TextInputType.datetime,
                readOnly: false,
                  onTap: () =>  {
                    _selectDate(context)
                  }),
              SizedBox(height: 20.0),
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
              SizedBox(height: 20.0),
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
              SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(
                    FontAwesomeIcons.penFancy,
                    color: Colors.blueGrey,
                  ),
                  hintText: 'Observação',
                  labelText: 'Observação',
                ),
                keyboardType: TextInputType.multiline,
                controller: obsController,
              ),
              SizedBox(
                height: 50.0,
              ),

              if (_pressedCreate)
                //validateFields(_materialModel),
                FutureBuilder(
                  future: _createMaterialRequirement(_materialModel),
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

                      /*{final snackBar = SnackBar(
                        content: Text(
                          'Por favor preencha a obra na qual irá trabalhar e a tabela.',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }*/
                    }
                    _pressedCreate = false;
                    _disabled = true;
                    /*_statesController.update(
                      WidgetState.disabled,
                      true, // or false depending on your logic
                    );*/

                    return const CircularProgressIndicator();
                  },

                )
              else
                const SizedBox.shrink(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  /*ElevatedButton(
                    onPressed: !_disabled ? () {
                      //print(selectedObra.toString() );

                      if(selectedObra == null || selectedMaterial == null || quantidadeController.text == '')
                      {final snackBar = SnackBar(
                        content: Text(
                          'Por favor preencha a obra na qual irá trabalhar, o material e a quantidade.',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      else
                      {
                        setState(() {
                          _materialModel = MaterialModel.create(
                              profissional: emailController.text,
                              idObra: selectedObra.toString(),
                              obra: '',
                              dtEntrega: _dataEntrega,
                              quantidade: quantidadeController.text,
                              unidade: unidadeController.text,
                              produto: selectedMaterial,
                              obs:obsController.text);
                           }
                        );
                        _pressedCreate = true;
                        _disabled = false;
                      }} : null,
                    //statesController: _statesController,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                    ),
                    child: Text("Salvar",style: TextStyle(color: Colors.white)),
                  ),*/
                  SizedBox(
                    height: 150.0,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      tooltip: 'Salvar',
                      shape: const CircleBorder(),
                      onPressed: !_disabled ? () {
                      //print(selectedObra.toString() );

                      if(selectedObra == null || selectedMaterial == null || quantidadeController.text == '')
                      {final snackBar = SnackBar(
                        content: Text(
                        'Por favor preencha a obra na qual irá trabalhar, o material e a quantidade.',
                        style: TextStyle(color: Colors.red),
                        ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      else
                      {
                        setState(() {
                        _materialModel = MaterialModel.create(
                        profissional: emailController.text,
                        idObra: selectedObra.toString(),
                        obra: '',
                        dtEntrega: _dataEntrega,
                        quantidade: quantidadeController.text,
                        unidade: unidadeController.text,
                        produto: selectedMaterial,
                        obs:obsController.text);
                        }
                      );
                      _pressedCreate = true;
                      _disabled = false;
                      }} : null,
                      child: const Icon(Icons.add),
                      backgroundColor: Colors.lightGreen,
                    ),
                  ),
                  /*ElevatedButton(
                    onPressed: () {
                      if(_atividadeModel.tabela.isNotEmpty) {
                        _atividadeModel.tabela.length == 1 ? Modular.to.pushNamed('edit/$idAtividade' )  : Modular.to.pushNamed('edit/$idAtividade' ) ;
                      }else{
                        {final snackBar = SnackBar(
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
                    child: Text("Avançar",style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                    ),
                  )*/
                ],
              ),
            ],
          ),
        ));


  }
  Future<DocumentReference> _createMaterialRequirement(MaterialModel material) async {
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
    material.profissional = profDB.nome;
    print("Vai adicionar o material agora");
    print(profDB.nome);

    try
    {
    DocumentSnapshot snapshot =
    await db.collection(FirebaseConst.obra)
        .doc(material.idObra)
        .get();
    final obraModel = ObraModel.fromMap(snapshot.data() as Map,'');
    material.obra = obraModel.nome;

      docRef = await db
          .collection("material")
          .withConverter(
        fromFirestore: MaterialModel.fromFirestore,
        toFirestore: (value, options) {
          return material.toFirestore();
        },
      )
      //.doc()
          .add(material);

    }
    catch (e)
    {
      print(e.toString());
      throw Exception(e.toString());
    } finally
    {
     // await Future.delayed(const Duration(milliseconds: 1000));
    }
    setState(() {
      idMaterial = docRef.id;
    });
    showMessage();
    return docRef;
  }

  validateFields(dynamic value) {
    if (value == "") {
      return [AlertType.info, "Por favor preencha todos os campos"];
      return("Por favor preencha todos os campos");

    }
    return null;
  }

  Future<dynamic> showMessage() async{
    //WidgetsBinding.instance.addPostFrameCallback((_) =>
        alertDialog(
        context,
        AlertType.info,
        AppLocalizations.of(context)!.save.toUpperCase(),
        'Material solicitado com sucesso');
    //);
  }


}