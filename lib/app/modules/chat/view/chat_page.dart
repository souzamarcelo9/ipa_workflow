// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:viska_erp_mobile/app/model/card_equipment.dart';
import 'package:viska_erp_mobile/app/model/messenger.dart';
import 'package:viska_erp_mobile/app/model/profissional.dart';
import '../../../core/firebase_const.dart';
import '../../../model/ferramenta.dart';
import '../../../model/formam.dart';
import '../../../model/veiculo.dart';
import '../../home/store/home_store.dart';
import 'chatDetailPage.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String name = "";
  final HomeStore controller = Modular.get();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final urlController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  late String idFormam = '';
  late FormamModel formamModel = FormamModel();
  late ProfissionalModel _profissionalModel = ProfissionalModel();
  late FerramentaModel _ferramentaModel = FerramentaModel();
  late VeiculoModel _veiculoModel = VeiculoModel();
  late List<CardEquipment> listaEquipamentos = [];
  late List<CardEquipment> listaEquipamentosSelect = [];
  final _auth = FirebaseAuth.instance;
  late MessengerModel _messengerModel = MessengerModel();
  late List<MessengerModel> listaMessenger = [];
  late List<MessengerModel> listaMessengerBD = [];

  void onInit() async {
    await controller.recoverUserData();
    setState(() {
      nameController.text = controller.userModel.name;
      emailController.text = controller.userModel.email;
      urlController.text = controller.userModel.userImage;
      //_profissionalModel = Modular.args.data;
    });

    // _selectDate(context);

    await getData();
    //Recupera os equipamentos do profissional
    setState(() {
      listaMessenger = listaMessengerBD;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    onInit();
    super.initState();
    //addData();
  }

  Future<void> getData() async {
    //RECUPERA AS MENSAGENS DO USUÁRIO E PARA O USUÁRIO
    listaMessenger = [];
    listaMessengerBD = [];

    try {
      await FirebaseFirestore.instance.collection(FirebaseConst.messenger)
          .where(
          "idUsuario", isEqualTo: _auth.currentUser!.uid)
          .orderBy('dtHora', descending: true)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> response = docSnapshot.data();
          _messengerModel = MessengerModel.fromMap(response, docSnapshot.reference.id);
          listaMessengerBD.add(_messengerModel);

        }
      });
    }
    catch (e) {
      print(e);
    }
    setState(() {
      listaMessenger = listaMessengerBD;
    });

  }

  Future<void> saveMessage() async {
    //SALVA AS MENSAGENS
    DocumentReference docRef;
    var db = FirebaseFirestore.instance;
    MessengerModel message = MessengerModel();
    message.idUsuario = _auth.currentUser!.uid;
    message.messageContent = messageController.text;
    message.status = 'unread';
    message.dtHora = Timestamp.now();
    message.messageType = 'receiver';
    message.idMessage = message.id;

    try {
      docRef = await db
          .collection(FirebaseConst.messenger)
          .withConverter(
        fromFirestore: MessengerModel.fromFirestore,
        toFirestore: (value, options) {
          return message.toFirestore();
        },
      )
          .add(message);

      await getData();
    }
    catch (e)
    {
      print(e.toString());
      throw Exception(e.toString());
    } finally
    {
      //await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.greenAccent,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back,color: Colors.black,),
                  ),
                  SizedBox(width: 2,),
                  CircleAvatar(
                    backgroundImage: NetworkImage(urlController.text.isNotEmpty ? urlController.text : 'https://e7.pngegg.com/pngimages/455/105/png-clipart-anonymity-computer-icons-anonymous-user-anonymous-purple-violet.png'),
                    maxRadius: 20,
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(nameController.text,style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                        SizedBox(height: 6,),
                        Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                      ],
                    ),
                  ),
                  IconButton(
                    //iconSize: 30,
                    tooltip: 'Atualizar',
                    icon:  Icon(Icons.refresh),
                    // the method which is called
                    // when button is pressed
                    onPressed: () async => await getData() ,
                  ),
                ],
              ),
            ),
          ),
        ),
        body:
        Stack(
          children: <Widget>[
        SingleChildScrollView(
        child:
            ListView.builder(
              itemCount: listaMessenger.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10,bottom: 10),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return Container(
                  padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                  child: Align(
                    alignment: (listaMessenger[index].messageType == "receiver"?Alignment.topLeft:Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (listaMessenger[index].messageType  == "receiver"?Colors.blueGrey[100]:Colors.blue[200]),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(listaMessenger[index].messageContent, style: TextStyle(fontSize: 15),),
                    ),
                  ),
                );
              },
            )),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(Icons.add, color: Colors.white, size: 20, ),
                      ),
                    ),
                    SizedBox(width: 15,),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "Escreva uma mensagem...",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none,

                        ),
                        controller: messageController,
                      ),
                    ),
                    SizedBox(width: 15,),
                    FloatingActionButton(
                      onPressed: () async => {
                        if(messageController.text.isNotEmpty){
                          await saveMessage()
                        }
                      },
                      child: Icon(Icons.send,color: Colors.white,size: 18,),
                      backgroundColor: Colors.blue,
                      elevation: 0,
                    ),
                  ],

                ),
              ),
            ),
          ],
        ),
    );
         // },
      //  ));
  }
}