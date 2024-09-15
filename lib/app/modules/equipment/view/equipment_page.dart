// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:viska_erp_mobile/app/model/card_equipment.dart';
import 'package:viska_erp_mobile/app/model/profissional.dart';
import '../../../core/firebase_const.dart';
import '../../../model/ferramenta.dart';
import '../../../model/formam.dart';
import '../../../model/veiculo.dart';
import '../../home/store/home_store.dart';


class EquipmentPage extends StatefulWidget {
  const EquipmentPage({super.key});

  @override
  State<EquipmentPage> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  String name = "";
  final HomeStore controller = Modular.get();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  late String idFormam = '';
  late FormamModel formamModel = FormamModel();
  late ProfissionalModel _profissionalModel = ProfissionalModel();
  late FerramentaModel _ferramentaModel = FerramentaModel();
  late VeiculoModel _veiculoModel = VeiculoModel();
  late List<CardEquipment> listaEquipamentos = [];
  late List<CardEquipment> listaEquipamentosSelect = [];

  void onInit() async {
    await controller.recoverUserData();
    setState(() {
      nameController.text = controller.userModel.name;
      emailController.text = controller.userModel.email;
      _profissionalModel = Modular.args.data;
    });

    // _selectDate(context);

    await getData();
    //Recupera os equipamentos do profissional
    setState(() {
      idFormam = formamModel.id;
      listaEquipamentos = listaEquipamentosSelect;
    });
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
    //addData();
  }

  Future<void> getData() async {
    //RECUPERA AS FERRAMENTAS

    try {
      await FirebaseFirestore.instance.collection(FirebaseConst.ferramentas)
          .where(
          "profissional", isEqualTo: _profissionalModel.id)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> response = docSnapshot.data();
          _ferramentaModel = FerramentaModel.fromMap(response, docSnapshot.reference.id);
          CardEquipment card = CardEquipment();
          card.date = _ferramentaModel.dtEntrega;
          card.lname = 'Ferramenta';
          card.fname = _ferramentaModel.nome;
          card.image = 'assets/images/settings_78352.png';
          listaEquipamentosSelect.add(card);
        }
      });
    }
    catch (e) {
      print(e);
    }

    try {
      await FirebaseFirestore.instance.collection(FirebaseConst.veiculos)
          .where(
          "alocado", isEqualTo: _profissionalModel.id)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> response = docSnapshot.data();
          _veiculoModel = VeiculoModel.fromMap(response, docSnapshot.reference.id);
          CardEquipment card = CardEquipment();
          card.date = _veiculoModel.dtModf;
          card.lname = 'Veículo';
          card.fname = _veiculoModel.nome;
          card.image = 'assets/images/ExecutiveCar_Black.png';
          listaEquipamentosSelect.add(card);
        }
      });
    }
    catch (e) {
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Card(
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search), hintText: 'Buscar...'),
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
            )),
        body: //StreamBuilder<QuerySnapshot>(
        /*  stream: FirebaseFirestore.instance.collection('obras').where("formam", isEqualTo: idFormam).snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? Center(
              child: CircularProgressIndicator(),
            )
                :*/ ListView.builder(
                itemCount: listaEquipamentos.length, //snapshots.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = listaEquipamentos[index];//snapshots.data!.docs[index].data()
                  //as Map<String, dynamic>;

                  if (name.isEmpty) {
                    return ListTile(
                      title: Text(
                        data.fname,//data['dtCriacao'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        data.lname,//data['empresa'] + ' - ' + data['nome'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(data.image ),
                      ),
                    );
                  }
                  if (data.fname//data['nome']
                      .toString()
                      .toLowerCase()
                      .startsWith(name.toLowerCase())) {
                    return ListTile(
                      title: Text(
                        data.fname,//data['nome'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        data.lname,//data['dtCriacao'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(data.image),
                      ),
                    );
                  }
                  return Container();
                }));
         // },
      //  ));
  }
}