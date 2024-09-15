
import 'package:viska_erp_mobile/app/app_store.dart';
import 'package:viska_erp_mobile/app/model/user.dart';
import 'package:viska_erp_mobile/app/modules/login/repository/login_repository.dart';
import 'package:mobx/mobx.dart';

part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  LoginStoreBase(this.appStore);

  final AppStore appStore;

  @observable
  String email = "";

  @observable
  String password = "";

  @action
  void setEmail(String text) => email = text;

  @action
  void setPassword(String text) => password = text;

  @observable
  bool loading = false;

  @observable
  dynamic result = false;

  @observable
  bool passwordHide = true;

  @action
  void viewPassword() => passwordHide = !passwordHide;

  @computed
  bool get finish => email.isNotEmpty && password.isNotEmpty;

  @action
  Future<bool>signInWithEmailAndPassword(UserModel model) async {
    final repository = LoginRepository();
    final user = await repository.loginUser(model);

    //if(user != null)
     if(user.runtimeType == bool)
    {
      //return await repository.loginUser(model);
      return true;
    }
    else
    {
      //return alertDialog(context, AlertType.info, "ATENÇÃO", result);
      return false;
    }
  }
}
