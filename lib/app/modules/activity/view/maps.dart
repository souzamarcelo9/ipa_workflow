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
import '../../../model/card_tabela.dart';
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
  LatLng ?_currentPosition;
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

    /*_statesEntrar.update(
      WidgetState.disabled,
      false, // or false depending on your logic
    );
    _statesEncerrar.update(
      WidgetState.disabled,
      true, // or false depending on your logic
    );*/
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
    atividadeHora.dtHoraEntrada = DateTime.now();
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
    getLocation();

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
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,//_center,
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
        ),
      ),
    );
  }

  Future<bool> checkUserIsWorking() async {
    var db = FirebaseFirestore.instance;
    AtividadeHoraModel atividade = AtividadeHoraModel();
    bool isWorking = false;

    try {
      await db.collection(FirebaseConst.atividadeHora)
          .where("idUsuario", isEqualTo:_auth.currentUser?.uid)
          .where("dtHoraSaida",isEqualTo: null)
          .get().then(
            (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            Map<String, dynamic> response = docSnapshot.data();
            atividade = AtividadeHoraModel.fromMap(response, '');
          }
        },
        onError: (e) => print("Error completing: $e"),
      );
    }catch(e)
    {
      print(e);
    }

    if(atividade.idUsuario.isNotEmpty){
      //usuário está trabalhando
      isWorking = true;
    }

    return isWorking;
  }

  Future<bool> showBatidaDialog(BuildContext context, String message) async {
    // set up the buttons
    var isWorking = await checkUserIsWorking();
    var pergunta = isWorking ? 'Confirma saída em: ' : 'Confirma batida em';

    Widget cancelButton = ElevatedButton(
      child: Text("Cancelar"),
      onPressed: () {
        // returnValue = false;
        Navigator.of(context).pop(false);
      },
    );
    Widget continueButton = ElevatedButton(
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
    AlertDialog alert = AlertDialog(
      title: Text("$pergunta ${DateFormat("dd.MM.yyyy").format(DateTime.now())} às ${DateTime.now().hour}:${DateTime.now().minute}?"),
      content:SizedBox(width: 100,
        child:
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
      actions: [
        cancelButton,
        continueButton,
      ],
    ); // show the dialog

    final result = await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return alert;
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