import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:viska_erp_mobile/app/core/firebase_const.dart';
import 'package:viska_erp_mobile/app/model/atividade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ActivityRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore dataBase = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  ///Recuperar dados do usuário:
  Future recoverActivityData(idActivity) async {

    AtividadeModel atividadeModel = AtividadeModel();
    DocumentSnapshot snapshot =
    await dataBase.collection(FirebaseConst.atividade).doc(idActivity).get();
    atividadeModel = AtividadeModel.fromMap(snapshot.data() as Map,'');
    return atividadeModel;
  }

//******************************************************************************

  ///Atualizar dados da atividade:
  Future<bool> updateActivityData(AtividadeModel model) async {
    try {
      //await _auth.currentUser?.updateEmail(model.email);
      await dataBase
          .collection(FirebaseConst.atividade)
          .doc(model.id)
          .update({
        "obra": model.obra,
        "tabela": model.tabela,
        "data": model.data,
        "unidade": model.unidade,
        "altura": model.altura,
      });
      return true;
    } catch (error) {
      return false;
    }
  }
//******************************************************************************

  ///Atualizar imagem:
  Future<String> updateImage({
    required File file,
    required String path,
    required String userId,
  }) async {
    String imageName = userId + DateTime.now().toString();
    final UploadTask uploadTask =
    storage.ref().child('$path/$imageName').putFile(file);
    final TaskSnapshot snapshot = await uploadTask;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }

//******************************************************************************
  Future<void> updateUserImage(
      {required File imageFile, String? oldImageUrl, int? index}) async {
    String uploadPath = "uploads/updated_image";
    if (oldImageUrl != null) {
      await FirebaseStorage.instance.refFromURL(oldImageUrl).delete();
    }
    final imageLink = await updateImage(
      file: imageFile,
      path: uploadPath,
      userId: _auth.currentUser!.uid,
    );
    await dataBase
        .collection(FirebaseConst.usuarios)
        .doc(_auth.currentUser!.uid)
        .update({"imagem_usuario": imageLink});
  }

//******************************************************************************

  /// Excluir atividade:
  Future<bool> deleteAccount() async {
    try {
      User user = _auth.currentUser!;
      await dataBase.collection(FirebaseConst.usuarios).doc(user.uid).delete();
      String? imageUrl = (await dataBase
          .collection(FirebaseConst.usuarios)
          .doc(user.uid)
          .get())
          .data()?["imagem_usuario"];
      await FirebaseStorage.instance.refFromURL(imageUrl!).delete();
      await user.delete();
      return true;
    } catch (error) {
      return false;
    }
  }

//******************************************************************************

  ///Verificar o usuário atual:
  bool checkCurrentUser() {
    User? user = _auth.currentUser;
    return user != null ? true : false;
  }
}
