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

class EditActivityTablePage extends StatefulWidget {
  const EditActivityTablePage({super.key, required action});

  final String title = 'Folhas para a atividade';
  final String title2 = 'SoftBag para a atividade';
  @override
  _EditActivityTablePageState createState() => _EditActivityTablePageState();
}

class _EditActivityTablePageState extends State<EditActivityTablePage> {
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
    ListTile makeListTile(CardTabela card) =>
        ListTile(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: const EdgeInsets.only(right: 12.0),
            decoration: const BoxDecoration(
                border: Border(
                    right: BorderSide(width: 1.0, color: Colors.white24))),
            child: const Icon(Icons.autorenew, color: Colors.white),
          ),
          title: Text(
            card.title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

          subtitle: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    // tag: 'hero',
                    child: LinearProgressIndicator(
                        backgroundColor: const Color.fromRGBO(209, 224, 224, 0.2),
                        value: card.indicatorValue?.toDouble(),
                        valueColor: const AlwaysStoppedAnimation(Colors.green)),
                  )),
              Expanded(
                flex: 4,
                child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(card.level,
                        style: const TextStyle(color: Colors.white))),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(card.quantity.toString(),
                        style: const TextStyle(color: Colors.white))),
              ),
            ],
          ),
          trailing:
          const Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
            if(card.tipo == 'P') {
              Modular.to.pushNamed('/activity/detail/', arguments: CardTabela(
                  id: card.id,
                  tipo: card.tipo,
                  title: card.title,
                  level: card.level,
                  indicatorValue: card.indicatorValue,
                  price: card.price,
                  quantity: card.quantity));
            }else{
              Modular.to.pushNamed('/activity/detailInsul/', arguments: CardTabela(
                  id: card.id,
                  tipo: card.tipo,
                  title: card.title,
                  level: card.level,
                  indicatorValue: card.indicatorValue,
                  price: card.price,
                  quantity: card.quantity));
            }
           /* Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DetailPage(card: card, tbProd: tipoTabela)));*/
          },
        );

    Card makeCard(CardTabela card) =>
        Card(
          elevation: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: const BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: makeListTile(card),
          ),
        );

    final makeBody = Container(
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: lstCards.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(lstCards[index]);
        },
      ),
    );

    final makeBottom = SizedBox(
      height: 55.0,
      child: BottomAppBar(
        color: const Color.fromRGBO(58, 66, 86, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              tooltip: 'Home',
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () => Modular.to.navigate('/home')
            ),
            IconButton(
              tooltip: 'Atualizar',
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () async => { getTableCards() },
            ),
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.white),
               onPressed: () async =>  {
                   await deleteData()
                }
            ),
            IconButton(
              icon: const Icon(Icons.save, color: Colors.white),
                onPressed: () => saveCard()
            )
          ],
        ),
      ),
    );

    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
      title: Center(child:Text(tipoTabela.length == 1 ? widget.title :widget.title2,textAlign: TextAlign.center,style: const TextStyle(color: Colors.white))),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.list),
          onPressed: () {},
        )
      ],
    );

    return Scaffold(
      backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      body: makeBody,
      bottomNavigationBar: makeBottom,
    );
  }

//}

  /*@override
  Widget build(BuildContext context) {
    //Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    //String someResult = arguments['idAtividade'];
    print(Modular.args.params['atividade'] );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          //AppLocalizations.of(context)!.editProfile.toUpperCase(),
          'Editar Atividade'.toUpperCase(),
          style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Observer(
        builder: (_) => controller.loading
            ? const Center(child: CircularProgressIndicator(color: purple))
            : SingleChildScrollView(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //_buildUserProfilePhoto(),
                _buildForm(),
                _buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }*/

  /*Widget _buildForm() {
    return Column(
      children: [
        const SizedBox(height: 15),
        InputCustomized(
          icon: Icons.person,
          hintText: 'Editar atividade',
          hintStyle: GoogleFonts.syne(color: darkPurple),
          keyboardType: TextInputType.text,
          controller: nameController,
        ),
        const SizedBox(height: 15),
        InputCustomized(
          icon: Icons.email_outlined,
          hintText: AppLocalizations.of(context)!.email,
          hintStyle: GoogleFonts.syne(color: darkPurple),
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
        ),
        const SizedBox(height: 15),
        InputCustomized(
          icon: Icons.phone,
          hintText: AppLocalizations.of(context)!.cellPhone,
          hintStyle: GoogleFonts.syne(color: darkPurple),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            TelefoneInputFormatter(),
          ],
          controller: telController,
        ),
        const SizedBox(height: 30),
      ],
    );
  }
*/
  /*Widget _buildButton() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45),
          child: CustomAnimatedButton(
            onTap: () async {
              await _saveChange();
            },
            widhtMultiply: 1,
            height: 45,
            colorText: white,
            color: Colors.green,
            text: AppLocalizations.of(context)!.saveEditions.toUpperCase(),
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45),
          child: CustomAnimatedButton(
            onTap: () async {
              Modular.to.navigate('/home');
            },
            widhtMultiply: 1,
            height: 45,
            colorText: black,
            color: Colors.grey.withOpacity(0.2),
            text: AppLocalizations.of(context)!.cancel.toUpperCase(),
          ),
        ),
      ],
    );
  }*/

  /*Future _saveChange() async {
    final user = UserModel(
      name: nameController.text,
      email: emailController.text,
      phone: telController.text,
    );

    final atividade = AtividadeModel(
      id: nameController.text,
      profissional: emailController.text,
      obra: nameController.text,
      data: nameController.text,
      tabela: nameController.text,
      unidade: 1,
      altura: nameController.text,
    );
    List result = controller.validateUpdatedFields(user);

    if (result.first == true) {
      setState(() => controller.loading = true);
      if (controller.file != null) {
        _repository.updateUserImage(
            imageFile: controller.file!,
            oldImageUrl: controller.userModel.userImage);
      }
      await _repository.updateActivityData(atividade).then((value) {
        Modular.to.navigate('/home');
      }).catchError((_) {
        alertDialog(
            context,
            AlertType.error,
            AppLocalizations.of(context)!.attention,
            AppLocalizations.of(context)!.errorOccurredUpdatingProfile);
      });
      setState(() => controller.loading = false);
    } else {
      alertDialog(context, AlertType.error, 'Erro', result[2]);
    }
  }*/
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
