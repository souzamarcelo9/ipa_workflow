// ignore_for_file: library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:viska_erp_mobile/app/model/AtividadeHora.dart';
import 'package:viska_erp_mobile/app/model/AtividadeInsuladora.dart';
import 'package:viska_erp_mobile/app/model/AtividadeProducao.dart';
import 'package:viska_erp_mobile/app/modules/activity/repository/activity_repository.dart';
import 'package:viska_erp_mobile/app/modules/home/store/home_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/firebase_const.dart';
import '../../../model/card_tabela.dart';
import '../../../model/obra.dart';
import '../../../model/profissional.dart';
import '../../../widgets/alert.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class TabelaHoraPage extends StatefulWidget {
  const TabelaHoraPage({super.key});

  @override
  _TabelaHoraPageState createState() => _TabelaHoraPageState();
}

class _TabelaHoraPageState extends State<TabelaHoraPage> {
  //late Position _currentPosition;
  final HomeStore controller = Modular.get();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final telController = TextEditingController();
  final _repository = ActivityRepository();
  late String tipoTabela = '';
  late String idAtividade = Modular.args.params['action'];
  List<AtividadeProducaoModel> tbProducao = [];
  List<AtividadeInsuladoraModel> tbInsuladora = [];
  ObraModel _obraModel = ObraModel();
  late List<CardTabela> lstCards = [];
  late List<CardTabela> lstCardsInit = [];
  late GoogleMapController mapController;
  LatLng? _currentPosition;
  var selectedObra, selectedType,selectedTabela;
  bool _isLoading = true;
  late DateTime _chosenDateTime;
  late double latitude;
  late double longitude;
  late double latObra;
  late double longObra;
  final _statesEntrar = WidgetStatesController();
  final _statesEncerrar = WidgetStatesController();
  bool btnVisible = false;
  bool isDisabled = false;

  void onInit() async {

    await controller.recoverUserData();
    setState(() {
      nameController.text = controller.userModel.name;
      emailController.text = controller.userModel.email;
      telController.text = controller.userModel.phone;
    });

    _statesEntrar.update(
      WidgetState.disabled,
      false, // or false depending on your logic
    );
    _statesEncerrar.update(
      WidgetState.disabled,
      true, // or false depending on your logic
    );
  }

  @override
  void initState() {
    onInit();
    super.initState();
    getLocation();

  }

  Future<void> getLatLngFromAddress(String address) async {

    try
    {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        Location location = locations.first;
        double latitude = location.latitude;
        double longitude = location.longitude;
        print('Latitude: $latitude, Longitude: $longitude');

        setState(() {
          longObra = longitude;
          latObra = latitude;
        });
      } else {
        print('Endereço não encontrado.');
      }
    }
    catch (e) {
      print('Erro na obtenção de coordenadas: $e');
    }
  }

  Future<void> getDetailObra()async {

    DocumentSnapshot snapshot =
    await FirebaseFirestore.instance.collection(FirebaseConst.obra)
        .doc(selectedObra)
        .get();

    setState(() {
      _obraModel = ObraModel.fromMap(snapshot.data() as Map,'');
    });
  }

  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
      latitude = lat;
      longitude = long;
      _isLoading = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<Position> get() async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest);
  }

  Future<DocumentReference> iniciaTrabalhoValorHora() async {
    final db = FirebaseFirestore.instance;
    AtividadeHoraModel atividadeHora =  AtividadeHoraModel();
    ProfissionalModel profDB = ProfissionalModel();
    DocumentReference docRef;

   try {
     await db.collection(FirebaseConst.profissionais)
         .where("email", isEqualTo: emailController.text).get().then(
           (querySnapshot) {
         for (var docSnapshot in querySnapshot.docs) {
           Map<String, dynamic> response = docSnapshot.data();
           profDB = ProfissionalModel.fromMap(response, '');
         }
       },
       onError: (e) => print("Error completing: $e"),
     );
   }catch(e){
     print(e);
   }

    atividadeHora.status = 'A';
    atividadeHora.obra = _obraModel.nome;
    atividadeHora.valorHora = profDB.vlrHora.toDouble();
    atividadeHora.totalProfissional = 0;
    atividadeHora.dtAtividade = DateFormat("dd.MM.yyyy").format(DateTime.now());
    atividadeHora.dtHoraEntrada = DateTime.now();
    atividadeHora.dtHoraSaida = null;
    atividadeHora.profissional = profDB.nome;

    try {
      docRef = await db
          .collection(FirebaseConst.atividadeHora)
          .withConverter(
        fromFirestore: AtividadeHoraModel.fromFirestore,
        toFirestore: (value, options) {
          return atividadeHora.toFirestore();
        },
      )
      //.doc()
          .add(atividadeHora);

    }
    catch (e)
    {
      print(e.toString());
      throw Exception(e.toString());
    } finally
    {
      //await Future.delayed(const Duration(milliseconds: 1000));
    }
    setState(() {
      idAtividade = docRef.id;
    });
   // _createWorkTables(idAtividade,atividade.tabela);
    showMessage();
    return docRef;
  }

  Future<bool> encerrarAtividadeHora() async {
    final db = FirebaseFirestore.instance;
    AtividadeHoraModel atividadeHora =  AtividadeHoraModel();
    ProfissionalModel profDB = ProfissionalModel();
    DocumentReference docRef;
    bool atualizou = false;

    try{
    DocumentSnapshot snapshot =
    await FirebaseFirestore.instance.collection(FirebaseConst.atividadeHora)
        .doc(idAtividade)
        .get();

    atividadeHora = AtividadeHoraModel.fromMap(snapshot.data() as Map,'');
    }
    catch(e){
      print(e);
    }

    atividadeHora.status = 'C';
    if (atividadeHora.valorHora > 0) {
      atividadeHora.valorHora = profDB.vlrHora.toDouble();
    }
    atividadeHora.dtHoraSaida = DateTime.now();
    Duration? difference = atividadeHora.dtHoraSaida?.difference(atividadeHora.dtHoraEntrada);
    int hours = difference!.inHours % 24;
    print("hora");
    print(hours);
    if(atividadeHora.valorHora > 0) {
      atividadeHora.totalProfissional = (hours * atividadeHora.valorHora);
    }

    try {
      //await _auth.currentUser?.updateEmail(model.email);
      await FirebaseFirestore.instance
          .collection(FirebaseConst.atividadeHora)
          .doc(idAtividade)
          .update({
        "status": atividadeHora.status,
        "dtHoraSaida": atividadeHora.dtHoraSaida,
        "totalProfissional": atividadeHora.totalProfissional,
      });
      atualizou = true;
    }
    catch (error)
    {
      print(error);
      atualizou =  false;
    }

    showFinalMessage(atividadeHora.dtHoraSaida!.toLocal().toString());
    return atualizou;
  }

  Future<bool> validaGeolocalizacao() async{
    bool localOk = true;
    await getDetailObra();
    String endereco = '${_obraModel.endereco},${_obraModel.cidade},${_obraModel.estado}';
    await getLatLngFromAddress(endereco);

    var distanceInMeters = Geolocator.distanceBetween(
      latObra,
      longObra,
      latitude,
      longitude,
    );

     if(distanceInMeters > 1000){
       //localização inválida fora do local de trabalho
       localOk = false;
     }
      return localOk;
  }

  Future<dynamic> showMessage() async{
    WidgetsBinding.instance.addPostFrameCallback((_) => alertDialog(
        context,
        AlertType.info,
        AppLocalizations.of(context)!.save.toUpperCase(),
        'Atividade iniciada com sucesso.Ao finalizar o seu trabalho clique em "Registrar saída" '));
  }
  Future<dynamic> showFinalMessage(String horaFinal) async{

    WidgetsBinding.instance.addPostFrameCallback((_) => alertDialog(
        context,
        AlertType.info,
        AppLocalizations.of(context)!.save.toUpperCase(),
        'Atividade encerrada com sucesso em $horaFinal.Suas horas foram registradas" '));

    await Future.delayed(const Duration(milliseconds: 5000));
    Modular.to.navigate('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child:Text('Registrar Trabalho',style: TextStyle(color: Colors.white,),)),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ?
      const Center(
        child: CircularProgressIndicator(),
      )
          :
      Expanded(
      child: Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.0,width: 300,child:
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: SizedBox(height: 40.0,
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
          const SizedBox(height: 20.0),
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
          SizedBox(height: 50.0,width: 300,child:
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(
                FontAwesomeIcons.unity,
                color: Colors.blueGrey,
              ),
              hintText: 'Tabela Hora',
              labelText: 'Tabela Hora',
            ),
            keyboardType: TextInputType.text,
            //controller: unidadeController,
            readOnly: true,
          )),
          const SizedBox(height: 25.0),
          SizedBox(height:300,width:400, child:
          GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 16.0,
          ),
        )),
          const SizedBox(height: 20.0),
          Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                ElevatedButton(
                  child: const Text("Registrar Entrada",style: TextStyle(color: Colors.white)),
                  onPressed: isDisabled ? null : () async {
                    if(selectedObra == null)
                      {const snackBar = SnackBar(
                        content: Text(
                          'Por favor selecione a obra onde irá trabalhar',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    else
                    {
                      var localOk = await validaGeolocalizacao();
                      localOk = true;
                      if(localOk) {
                        await iniciaTrabalhoValorHora();
                        _statesEntrar.update(
                          WidgetState.disabled,
                          true, // or false depending on your logic
                        );
                        btnVisible = true;
                        isDisabled = true;
                      }else{
                        const snackBar = SnackBar(
                          content: Text(
                            'Sua localização não corresponde à localização da obra.',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      //_pressedCreate = true;
                      //_disabled = false;*/
                    }},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(40,50),
                      maximumSize: const Size(50,50)
                  ),
                  statesController: _statesEntrar,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                btnVisible?
                ElevatedButton(
                       onPressed: () async {
                         await encerrarAtividadeHora();
                       },
                       statesController: _statesEncerrar,
                       child: Text("Registrar Saída",style: TextStyle(color: Colors.white)),
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.red,
                       ),
                     )
                  : const SizedBox.shrink()
              ]
          )
      ]),
          )
      ),
    );
  }
  /*Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_currentPosition != null) Text(
                "LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}"
            ),
            ElevatedButton(
              child: Text("Get location"),
              onPressed: () {
                _getCurrentLocation();
              },
            ),
          ],
        ),
      ),
    );
  }*/

  _getCurrentLocation() {
    /*Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });*/
  }
  validateFields(dynamic value) {
    if (value == "") {
      return [AlertType.info, "Por favor preencha todos os campos"];
      return("Por favor preencha todos os campos");

    }
    return null;
  }
}