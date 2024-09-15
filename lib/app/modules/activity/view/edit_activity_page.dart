// ignore_for_file: library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:viska_erp_mobile/app/model/AtividadeInsuladora.dart';
import 'package:viska_erp_mobile/app/model/AtividadeProducao.dart';
import 'package:viska_erp_mobile/app/modules/activity/repository/activity_repository.dart';
import 'package:viska_erp_mobile/app/modules/home/store/home_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/firebase_const.dart';
import '../../../model/atividade.dart';
import '../../../model/card_tabela.dart';
import '../../../widgets/alert.dart';
import 'package:editable/editable.dart';

class EditActivityPage extends StatefulWidget {
  const EditActivityPage({super.key, required action});

  final String title = 'Folhas para a atividade';
  final String title2 = 'SoftBag para a atividade';
  @override
  _EditActivityPageState createState() => _EditActivityPageState();
}

class _EditActivityPageState extends State<EditActivityPage> {
  final controller = Modular.get<HomeStore>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final telController = TextEditingController();
  final _repository = ActivityRepository();
  late  String tipoTabela = '';
  late String idAtividade = Modular.args.params['action'];
  List<AtividadeProducaoModel> tbProducao =  [];
  List<AtividadeInsuladoraModel> tbInsuladora = [];
  //AtividadeModel atividadeModel = AtividadeModel();
  late List<CardTabela> lstCards  = [];
  late List<CardTabela> lstCardsInit  = [];
  final _editableKey = GlobalKey<EditableState>();

  List rows = [
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
  ];
  List cols = [
    {"title": 'Folha DryWall', 'widthFactor': 0.4, 'key': 'folha', 'editable': false},
    {"title": 'Quantidade', 'widthFactor': 0.3, 'key': 'qtde'},
    {"title": 'FT', 'widthFactor': 0.2, 'key': 'ft'},
    //{"title": 'Status', 'key': 'status'},
  ];
  void _addNewRow() {
    setState(() {
      _editableKey.currentState?.createRow();
    });
  }

  ///Print only edited rows.
  void _printEditedRows() {
    List editedRows = _editableKey.currentState!.editedRows;
    print(editedRows);
  }

  void onInit() async {
    await controller.recoverUserData();
    setState(() {
      nameController.text = controller.userModel.name;
      emailController.text = controller.userModel.email;
      telController.text = controller.userModel.phone;
    });

    DocumentSnapshot snapshot =
    await FirebaseFirestore.instance.collection(FirebaseConst.atividade)
        .doc(Modular.args.params['action'])
        .get();
     final atividadeModel = AtividadeModel.fromMap(snapshot.data() as Map,'');

     setState(() {
      tipoTabela = atividadeModel.tabela;
      //lstCards = lstCardsInit;
       idAtividade = Modular.args.params['action'];
    });

  }

  @override
  void initState () {
    //onInit();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      //onInit();
      getTableCards();
    });

  }
  /*void initState(){
    onInit();
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        leadingWidth: 200,
        leading: TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),//_addNewRow(),
            icon: const Icon(Icons.arrow_back),
            label: const Text(
              'Voltar',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: () => _printEditedRows(),
                child: const Text('Print Edited Rows',
                    style: TextStyle(fontWeight: FontWeight.bold))),
          )
        ],
      ),
      body:
      Editable(
        key: _editableKey,
        columns: cols,
        rows: rows,
        zebraStripe: true,
        stripeColor1: Colors.blue[200]!,
        stripeColor2: Colors.green[50]!,
        onRowSaved: (value) {
          print(value);
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
        showSaveIcon: true,
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
      ),
    );
  }
   
   Future<void> getTableCards() async{
     final db = FirebaseFirestore.instance;
     await getTipoTabela();
     var tabela = getNomeTabela();
     DocumentReference docRef;
     tbProducao.clear();
     tbInsuladora.clear();
     lstCardsInit.clear();

     await db.collection(tabela).where("idAtividade", isEqualTo:idAtividade ).get().then(
           (querySnapshot) {

         for (var docSnapshot in querySnapshot.docs) {
           //print('${docSnapshot.id} => ${docSnapshot.data()}');
           //var value = Map<String, dynamic>.from(snapshot.value as Map);
           Map<String, dynamic> response = docSnapshot.data();
           if(tipoTabela.length == 1) {

             tbProducao.add(AtividadeProducaoModel.fromMap(response,docSnapshot.id));
           }
           else
           {
             tbInsuladora.add(AtividadeInsuladoraModel.fromMap(response,docSnapshot.id));
           }
         }

       },
       onError: (e) => print("Error completing: $e"),
     );

     tbProducao.isNotEmpty ? fillListCards('P') : fillListCards("I");
     setState(() {
       lstCards = lstCardsInit;
     });
     //return lstCards;
  }

  Future<void> getTipoTabela() async{

     await controller.recoverUserData();
    setState(() {
      nameController.text = controller.userModel.name;
      emailController.text = controller.userModel.email;
      telController.text = controller.userModel.phone;
    });

    DocumentSnapshot snapshot =
    await FirebaseFirestore.instance.collection(FirebaseConst.atividade)
        .doc(idAtividade)
        .get();
    final atividadeModel = AtividadeModel.fromMap(snapshot.data() as Map,'');

    setState(() {
      tipoTabela = atividadeModel.tabela;
    });
  }

  String getNomeTabela() {
    if (tipoTabela.length == 1) {
      return "tbAtividadeProducao";
    }
    else {
      return "tbAtividadeInsuladora";
    }
  }

    void fillListCards(String tipoTabela) {

     if(tipoTabela == 'P') {
       for (var tabela in tbProducao) {

         lstCardsInit.add(
             CardTabela(
                 id:tabela.id,
                 title: "Folha Drywall:",
                 level: tabela.drywall,
                 indicatorValue: tabela.psqt,
                 quantity: tabela.quantidade,
                 tipo:'P',
                 content: "Texto"));
       }
     }
     else
     {
       for (var tabela in tbInsuladora) {

         lstCardsInit.add(
             CardTabela(
                 id:tabela.id,
                 title: "Soft Bag:",
                 level: tabela.tipoBag,
                 indicatorValue: tabela.qtdSoftBag,
                 quantity: tabela.quantidade,
                 tipo:'I',
                 content: "Texto"));
       }

     }

   }

   void showMessage(bool deletado) {

     WidgetsBinding.instance.addPostFrameCallback((_) => alertDialog(
         context,
         AlertType.info,
         AppLocalizations.of(context)!.attention.toUpperCase(),
         'Atividades serão canceladas'));

       //Modular.to.navigate('/home');

   }

   Future<bool> deleteData() async{
   bool retorno = true;

   showMessage(retorno);
   try {
      if(tipoTabela.length  == 1){
          for (var tabela in tbProducao) {

            await FirebaseFirestore.instance
                .collection("tbAtividadeProducao")
                .doc(tabela.id)
                .delete();
          }
        }
      else{
          for (var tabela in tbInsuladora) {
            await FirebaseFirestore.instance
                .collection("tbAtividadeInsuladora")
                .doc(tabela.id)
                .delete();
          }
        }
      }
      catch (e){
      print (e.toString());
      retorno = false;
    }

      try {
        //Deleta a atividade nó
        await FirebaseFirestore.instance.collection(FirebaseConst.atividade)
            .doc(idAtividade)
            .delete();
      }
      catch (e) {
        print(e.toString());
        retorno = false;
      }

      Modular.to.navigate('/home');
     //showMessage(retorno);
     return retorno;
    }

   saveCard(){
     WidgetsBinding.instance.addPostFrameCallback((_) => alertDialog(
         context,
         AlertType.info,
         AppLocalizations.of(context)!.save.toUpperCase(),
         'Atividades salvas com sucesso'));
     //Modular.to.navigate('/home');
   }

}
