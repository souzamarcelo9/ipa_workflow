import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import '../../../model/accountSeg.dart';
import '../../../model/card_tabela.dart';
import '../../../model/formam.dart';
import '../../../model/obra.dart';
import '../../../model/profissional.dart';
import '../../../widgets/alert.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


class MapActivityPage extends StatefulWidget {
  const MapActivityPage({super.key});
  @override
  State<MapActivityPage> createState() => _MapActivityPageState();
}

class _MapActivityPageState extends State<MapActivityPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(-23.5613496, -46.6590692);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;
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
  //late LatLng _currentPosition;
  late Future<LatLng> _currentPosition;
  var selectedObra, selectedType,selectedTabela;
  bool _isLoading = true;
  late DateTime _chosenDateTime;
  late double latitude;
  late double longitude;
  late double latObra;
  late double longObra;
  late FormamModel _formamModel = FormamModel();
  late FormamModel _formamDB = FormamModel();
  final _statesEntrar = WidgetStatesController();
  final _statesEncerrar = WidgetStatesController();
  bool mapVisible = false;
  bool isDisabled = false;
  final _auth = FirebaseAuth.instance;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Sua localização',
          snippet: 'Hora: ${DateTime.now().hour}:${DateTime.now().minute}',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  Future<LatLng> getLocation()  async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      //_currentPosition = location;
      //latitude = lat;
      //longitude = long;
      _isLoading = false;
    });

    return location;
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Future<Position> get() async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest);
  }

  void onInit() async {

    await controller.recoverUserData();
    setState(() {
      nameController.text = controller.userModel.name;
      emailController.text = controller.userModel.email;
      telController.text = controller.userModel.phone;
    });

    await getLocation();

    setState(() {
      _isLoading = false;
    });
    /*_statesEntrar.update(
      WidgetState.disabled,
      false, // or false depending on your logic
    );
    _statesEncerrar.update(
      WidgetState.disabled,
      true, // or false depending on your logic
    );*/

    await getFormamByEmail();

    setState(() {
      _formamModel = _formamDB;
    });
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
    atividadeHora.dtHoraEntrada = Timestamp.now();
    atividadeHora.dtHoraSaida = null;
    atividadeHora.profissional = profDB.nome;
    atividadeHora.idUsuario = _auth.currentUser!.uid;

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
   // if (atividadeHora.valorHora > 0) {
     // atividadeHora.valorHora = profDB.vlrHora.toDouble();
   // }
    atividadeHora.dtHoraSaida = Timestamp.now();

    DateTime dateTime1 = DateTime.parse(atividadeHora.dtHoraSaida!.toDate().toString());
    DateTime dateTime2 = DateTime.parse(atividadeHora.dtHoraEntrada.toDate().toString());
    //Duration? difference = atividadeHora.dtHoraSaida?.difference(atividadeHora.dtHoraEntrada);

    int minutes = dateTime1.difference(dateTime2).inMinutes;
    //int hours = difference!.inHours % 24;
    //print("hora");
    double hours = (minutes / 60);
    String inString = hours.toStringAsFixed(2); // '2.35'
    double inDouble = double.parse(inString); // 2.35

    if(atividadeHora.valorHora > 0) {
      atividadeHora.totalProfissional = (inDouble * atividadeHora.valorHora);
    }

    String totalString = atividadeHora.totalProfissional.toStringAsFixed(2);
    double totalRetorno = double.parse(totalString); // 2.35

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

    await _createAccDocFromProd(atividadeHora,idAtividade);
    showFinalMessage(DateTime.parse(atividadeHora.dtHoraSaida!.toDate().toString()).toLocal().toString());
    return atualizou;
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

  Future<void> _createAccDocFromProd(AtividadeHoraModel atividade,String idAtividade) async {
    final db = FirebaseFirestore.instance;
    AccountSegModel bsegModel = AccountSegModel();
    bsegModel.docNumber = await _getLastAccNumber('KR');
    bsegModel.docNumber += 1;
    bsegModel.data = DateFormat("dd.MM.yyyy").format(DateTime.now());
    bsegModel.mes = DateTime.now().month;
    bsegModel.ano = DateTime.now().year;
    bsegModel.profissional = controller.userModel.name;
    bsegModel.refkey = idAtividade;
    bsegModel.status = "A";
    bsegModel.tpDoc = "KR";
    bsegModel.urlImagem = controller.userModel.userImage;
    bsegModel.wrbtr = atividade.totalProfissional;
    bsegModel.grupo = '03';
    bsegModel.hkont = '03.01';
    bsegModel.augdt = '';
    bsegModel.waers = 'USD';
    bsegModel.vencimento = '';
    bsegModel.history = 'Pagamento para o profissional';
    bsegModel.fornecedor = controller.userModel.name;

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
    catch (e) {
      print(e.toString());
      throw Exception(e.toString());
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

  Future<bool> validaGeolocalizacao(bool isWorking) async{
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

    //distanceInMeters = 100;
    if(distanceInMeters > 1000){
      //localização inválida fora do local de trabalho
      localOk = false;
      WidgetsBinding.instance.addPostFrameCallback((_) => alertDialog(
          context,
          AlertType.error,
          AppLocalizations.of(context)!.attention.toUpperCase(),
          'Sua localização não é a mesma em que a obra será realizada. '));
    }else{
      if(isWorking){
        await encerrarAtividadeHora();
      }else{
       await iniciaTrabalhoValorHora();
      }
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
  void initState() {
    onInit();
    super.initState();
    _currentPosition = getLocation();

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child:Text('Registrar Trabalho')),
          backgroundColor: Colors.green[700],
        ),
        body:buildContainer()
      ),
    );
  }

  buildContainer() {
    return Container(
        child: FutureBuilder<LatLng>(
            future: _currentPosition,//getLocation(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  children: <Widget>[
                    GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: snapshot.data!,//_center,
                        zoom: 11.0,
                      ),
                      mapType: _currentMapType,
                      markers: _markers,
                      onCameraMove: _onCameraMove,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          children: <Widget> [
                            FloatingActionButton(
                              onPressed: () => showBatidaDialog(context,'Atividade Hora'),//_onMapTypeButtonPressed,
                              materialTapTargetSize: MaterialTapTargetSize.padded,
                              backgroundColor: Colors.green,
                              child: const Icon(Icons.access_time_filled_sharp, size: 36.0),
                              heroTag: "btn1",
                            ),
                            SizedBox(height: 16.0),
                            FloatingActionButton(
                              onPressed: _onAddMarkerButtonPressed,
                              materialTapTargetSize: MaterialTapTargetSize.padded,
                              backgroundColor: Colors.green,
                              child: const Icon(Icons.add_location, size: 36.0),
                              heroTag: "btn2",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
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


  Future<bool> checkUserIsWorking() async {
    var db = FirebaseFirestore.instance;
    AtividadeHoraModel atividadeHora = AtividadeHoraModel();
    bool isWorking = false;

    try {
      await db.collection(FirebaseConst.atividadeHora)
          .where("idUsuario", isEqualTo:_auth.currentUser?.uid)
          .where("status",isEqualTo: 'A')
          .get().then(
            (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            Map<String, dynamic> response = docSnapshot.data();
            atividadeHora = AtividadeHoraModel.fromMap(response, docSnapshot.id);
          }
        },
        onError: (e) => print("Error completing: $e"),
      );
    }catch(e)
    {
      print(e);
    }

    if(atividadeHora.idUsuario.isNotEmpty){
      //usuário está trabalhando
      isWorking = true;
      setState(() {
        idAtividade = atividadeHora.id;
      });
    }

    return isWorking;
  }

  Future<bool> showBatidaDialog(BuildContext context, String message) async {
    // set up the buttons
    var isWorking = await checkUserIsWorking();
    var pergunta = isWorking ? 'Confirma saída em: ' : 'Confirma batida em';

    /*Widget cancelButton = ElevatedButton(
      child: Text("Cancelar"),
      onPressed: () {
        // returnValue = false;
        Navigator.pop(context,false);
            //Modular.to.pushNamed('/activity/map');
      },
    );*/
   /* Widget continueButton = ElevatedButton(
      child: Text("Confirmar"),
      onPressed: () async {

        if(validateFields(''))
        {
          await validaGeolocalizacao(isWorking);
        }
        else
        {
          const snackBar = SnackBar(
            content: Text(
              'Por favor selecione a obra.',
              style: TextStyle(color: Color(0xff11b719)),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
    ); // set up the AlertDialog
*/

    final result = await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("$pergunta ${DateFormat("dd.MM.yyyy").format(DateTime.now())} às ${DateTime.now().hour}:${DateTime.now().minute}?"),
          content:SizedBox(width: 100,
              child:
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
                                  //validator: validateFields(selectedObra),
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
                                    "Selecione a obra:",
                                    style: TextStyle(color: Color(0xff11b719)),
                                  ),

                                ),
                              ))
                        ],
                      );
                    }
                  })),                     //Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Cancelar"),
              onPressed: () {
              Navigator.pop(context,false);
          }),

            ElevatedButton(
              child: Text("Confirmar"),
              onPressed: () async {

                if(validateFields(''))
                {
                await validaGeolocalizacao(isWorking);
                }
                else
                {
                  const snackBar = SnackBar(
                  content: Text(
                  'Por favor selecione a obra.',
                  style: TextStyle(color: Color(0xff11b719)),
                  ),
                );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            ) // set up the AlertDia
          ]
        ); // show the dialog
      },
    );
    return result ?? false;
  }

  bool validateFields(dynamic value) {
   var validado = true;

   if (selectedObra == null) {
      validado = false;
    }
    return validado;
  }
}