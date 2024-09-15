// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:viska_erp_mobile/app/model/fotoObra.dart';
import 'package:viska_erp_mobile/app/model/profissional.dart';
import '../../../../flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../theme/colors.dart';
import '../../../../widgets/bottombar_item.dart';
import '../../../core/firebase_const.dart';
import '../../../model/atividade.dart';
import '../../../model/material.dart';
import '../../../model/obra.dart';
import '../../../model/user.dart';
import '../../../widgets/alert.dart';
import '../../home/store/home_store.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FotoObraPage extends StatefulWidget {

  const FotoObraPage({super.key,required this.idAtividade,});
  final String idAtividade;

  @override
  State<FotoObraPage> createState() => _FotoObraPageState();
}

class _FotoObraPageState extends State<FotoObraPage> {
  String? selectedValue;
  final _ageCrt = TextEditingController();
  DateTime _dobCrt = DateTime.now();
  late UserModel _user;
  late ProfissionalModel _profissionalModel;
  final MaterialModel _materialModel = MaterialModel();
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
  final bool _pressedCreate = false;
  final bool _disabled = true;
  final _statesController = WidgetStatesController();
  final _statesAvancar = WidgetStatesController();
  String _dataEntrega = '';
  String txtDataEntrega = 'Para quando';
  int activeTab = 1;
  late File ?_image;
  final picker = ImagePicker();
  final _auth = FirebaseAuth.instance;
  String idAtividade = '';
  late String nomeObra = '';
  late AtividadeModel _atividadeModel  = AtividadeModel();

  @override
  void initState() {
    _ageCrt.text = "18";
    idAtividade = Modular.args.params['idAtividade'];
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

    await getObraName();

    setState(() {
      nomeObra = _atividadeModel.nomeObra;
    });

  }

  Future<void> getObraName() async{
    var db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
    await db.collection(FirebaseConst.atividade)
        .doc(idAtividade)
        .get();
    _atividadeModel = AtividadeModel.fromMap(snapshot.data() as Map,'');

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

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  //Show options to get image from camera or gallery
  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Galeria'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Câmera'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print('tirou foto');
        print(idAtividade);
      }
    });
  }

  Future<bool> saveImageOnFirebase() async {
    var fotoSalva = false;
    var rng = Random();
    var fileName = '';
    var db = FirebaseFirestore.instance;
    var date = DateFormat('dd-MM-yyyy').format(DateTime.now());

    if (_image != null)
    {
      fileName = '$nomeObra${rng.nextInt(100)}_$date';

      try {
        final Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('user/${_auth
            .currentUser!
            .uid }/$fileName'); //i is the name of the image
        UploadTask uploadTask =
        firebaseStorageRef.putFile(_image!);
        TaskSnapshot storageSnapshot = await uploadTask;
        var downloadUrl = await storageSnapshot.ref.getDownloadURL();

        uploadTask.whenComplete(() async =>
         await savePhotoOnList(downloadUrl.toString(),nomeObra)

        );
        fotoSalva =  true;
        await showMessage('Foto(s) salva com sucesso');
      }
      catch(ex){
        await showMessage(ex.toString());
        fotoSalva = false;
      }
    }
    return fotoSalva;
  }

  Future<void> savePhotoOnList(String url,String obra)async {
    print(url);
    final db = FirebaseFirestore.instance;
    DocumentReference docRef;
    FotoObraModel fotoObraModel = FotoObraModel();
    fotoObraModel.idAtividade = idAtividade;
    fotoObraModel.nomeObra = obra;
    fotoObraModel.dataUpload = DateFormat('dd/MM/yyyy').format(DateTime.now());
    fotoObraModel.urlPhoto = url;
    fotoObraModel.idUsuario = _auth.currentUser!.uid;

    try {
      docRef = await db
          .collection(FirebaseConst.fotoAtividade)
          .withConverter(
        fromFirestore: FotoObraModel.fromFirestore,
        toFirestore: (value, options) {
          return fotoObraModel.toFirestore();
        },
      )
          .add(fotoObraModel);
    }
    catch (e)
    {
      print(e.toString());
      throw Exception(e.toString());
    }
    finally
    {
      //await Future.delayed(const Duration(milliseconds: 1000));
    }
    setState(() {
      idMaterial = docRef.id;
    });

   // await showMessage('Foto(s) salva com sucesso');
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

  Future<dynamic> showMessage(String message) async{
    /*WidgetsBinding.instance.addPostFrameCallback((_) => alertDialog(
        context,
        AlertType.info,
        AppLocalizations.of(context)!.save.toUpperCase(),
        message)
    );*/
    alertDialog(
        context,
        AlertType.info,
        AppLocalizations.of(context)!.save.toUpperCase(),
        message);
    //Navigator.pushReplacementNamed(context, '/obra');
  }

  var selectedObra, selectedType,selectedMaterial,idMaterial;
  final GlobalKey<FormState> _formKeyValue = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(
        icon: Icon(
        FontAwesomeIcons.backward,
        color: Colors.white,
        ),
        onPressed: () => voltar(context)),
        title: Container(
          alignment: Alignment.center,
          child: Text("Fotos para a Obra:",
          style: TextStyle(
          color: Colors.black87,
          )),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                    FontAwesomeIcons.cameraRetro,
                  size: 20.0,
                  color: Colors.black87
                  ),
          onPressed: () => Modular.to.pushNamed('list/${_auth.currentUser!.uid}' )
          ),
          ],),
      body: Column(
        children: [
          SizedBox(
            height: 20.0,
          ),
          SizedBox(width:300.0,child:
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
                            child: TextFormField(
                              decoration: InputDecoration(
                                icon: Icon(
                                  FontAwesomeIcons.warehouse,
                                  color: Colors.blueGrey,
                                ),
                                hintText: nomeObra,
                                labelText: nomeObra,
                              ),
                              keyboardType: TextInputType.text,
                              readOnly: true,
                            ),
                            /*DropdownButtonFormField(
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
                              hint: Text(textAlign: TextAlign.center,
                                "Selecione a obra :",
                                style: TextStyle(color: Color(0xff11b719)),
                              ),

                            ),*/
                          ))
                    ],
                  );
                }
              })),
          SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
            onPressed: showOptions,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: Text('Selecione a imagem',style: TextStyle(color: Colors.white),),
          ),
          SizedBox(
            height: 15.0,
          ),
           SizedBox(height: 500.0,width:  500,
               child:
           Center(
            child: _image == null ? Text('Nenhuma imagem selecionada.') : Image.file(_image!),
          )),
          SizedBox(
            height: 50.0,
          ),
      SizedBox(
        height: 50.0,
        width:300,
        child:
        ElevatedButton(
        onPressed: () {
            if( _image == null)
            {
              final snackBar = SnackBar(
              content: Text(
                'Por favor selecione a foto que será adicionada',
                style: TextStyle(color: Colors.red),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            }else
            {
              saveImageOnFirebase();
            }
          },
        statesController: _statesAvancar,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
        child: Text("Salvar",style: TextStyle(color: Colors.white)),
      ))
         // _buildBottomBar()
        ],
      ),
    );
  }
  //}
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
                  Navigator.pushReplacementNamed(context, '/home');
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
                  Modular.to.navigate('/obra');
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
                  Modular.to.pushNamed('/activity/tabelahora');
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

    DocumentSnapshot snapshot =
    await db.collection(FirebaseConst.obra)
        .doc(material.idObra)
        .get();
    final obraModel = ObraModel.fromMap(snapshot.data() as Map,'');
    material.obra = obraModel.nome;

    try {
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
      await Future.delayed(const Duration(milliseconds: 1000));
    }
    setState(() {
      idMaterial = docRef.id;
    });

    return docRef;
  }

  validateFields(dynamic value) {
    if (value == "") {
      return [AlertType.info, "Por favor preencha todos os campos"];
      return("Por favor preencha todos os campos");

    }
    return null;
  }

  void voltar(BuildContext context) {
    //Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/home');
  }

}