// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:viska_erp_mobile/app/model/user.dart';
import 'package:viska_erp_mobile/app/modules/login/store/login_store.dart';
import 'package:viska_erp_mobile/app/utils/colors.dart';
import 'package:viska_erp_mobile/app/widgets/alert.dart';
import 'package:viska_erp_mobile/app/widgets/custom_animated_button.dart';
import 'package:viska_erp_mobile/app/widgets/custom_text_field.dart';
import 'package:viska_erp_mobile/app/widgets/custom_text_field_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:validatorless/validatorless.dart';
import 'package:viska_erp_mobile/flutter_gen/gen_l10n/app_localizations.dart';

import '../../../model/profissional.dart';

class ForgotMyPasswordPage extends StatefulWidget {
  const ForgotMyPasswordPage({super.key});

  @override
  _ForgotMyPasswordPageState createState() => _ForgotMyPasswordPageState();
}

class _ForgotMyPasswordPageState extends State<ForgotMyPasswordPage> {
  final controller = Modular.get<LoginStore>();
  final _formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  ProfissionalModel _profissionalModel = ProfissionalModel();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    Size size = MediaQuery.of(context).size;
    return Observer(
      builder: (_) => SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              imageTop(size),
              imageBottom(size),
              centerContent(size),
            ],
          ),
        ),
      ),
    );
  }

  Positioned imageTop(Size size) {
    return Positioned(
      top: 0,
      left: 0,
      width: size.width * 0.3,
      child: Image.asset(
        'assets/images/main_top.png',
      ),
    );
  }

  Positioned imageBottom(Size size) {
    return Positioned(
      bottom: 0,
      left: 0,
      width: size.width * 0.2,
      child: Image.asset(
        'assets/images/main_bottom.png',
      ),
    );
  }

  Column centerContent(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/images/security_password.svg', height: size.height * 0.30),
        const SizedBox(height: 20),
        _buildForm(),
        SizedBox(height: size.height * 0.04),
        _buildButtonSignIn(),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            CustomTextField(
              hintText: AppLocalizations.of(context)!.email,
              icon: const Icon(Icons.alternate_email_rounded, color: grey),
              textInputType: TextInputType.emailAddress,
              controller: emailController,
              onChange: controller.setEmail,
              validator: Validatorless.multiple([
                Validatorless.required(
                    AppLocalizations.of(context)!.fillFieldWithYourEmail),
                Validatorless.email(AppLocalizations.of(context)!.invalidEmail),
              ]),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonSignIn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: CustomAnimatedButton(
        onTap: () async {
          final isValid = _formKey.currentState?.validate() ?? false;
          final user = UserModel(
            email: emailController.text.trim(),
          );

          if (isValid) {

            var enviado = await resetPassword(user);

            if (enviado)
            {
              alertDialog(
                  context,
                  AlertType.error,
                  AppLocalizations.of(context)!.attention.toUpperCase(),
                  'Email enviado com sucesso');

              Modular.to.navigate('/login');
              setState(() => controller.loading = false);
            }
            else {
              alertDialog(
                  context,
                  AlertType.error,
                  AppLocalizations.of(context)!.attention.toUpperCase(),
                  'O email não foi enviado.Tente novamente mais tarde');
                 // AppLocalizations.of(context)!.errorOccurredLoggingAccount);
            }
          }
        },
        widhtMultiply: 1,
        height: 45,
        colorText: white,
        color: purple,
        text: AppLocalizations.of(context)!.recoverMyPassword,
      ),
    );
  }

  Widget _buildSignGoogleButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width * 1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade200,
        ),
        child: GestureDetector(
          onTap: () => Modular.to.pushNamed('/login/forgotMyPassword'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             // Image.asset('assets/images/google.png', height: 20),
              const SizedBox(width: 10),
              Text(
                AppLocalizations.of(context)!.forgotMyPassword,
                style: const TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextSignUp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.notHaveAccountRegister,
          style: GoogleFonts.syne(
              color: controller.appStore.isDark ? white : darkPurple),
        ),
        GestureDetector(
          onTap: () {
            Modular.to.pushNamed('/login/register');
          },
          child: Text(
            AppLocalizations.of(context)!.register,
            style: GoogleFonts.syne(
                color: controller.appStore.isDark ? white : darkPurple,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Future<bool> checkProfissionalLogon(String email) async {
    var ativo = false;

    try{
      await FirebaseFirestore.instance.collection("profissionais")
          .where("email", isEqualTo: controller.email)
          .get()
          .then(
            (querySnapshot) {

          for (var docSnapshot in querySnapshot.docs) {
            Map<String, dynamic> response = docSnapshot.data();
            _profissionalModel = ProfissionalModel.fromMap(response,docSnapshot.reference.id);
          }

        },
        onError: (e) => print("Error completing: $e"),
      );

      if(_profissionalModel.status == 'Ativo'){
        ativo = true;
      }

    }
    catch (e){
      print(e);

    }
    return ativo;
  }

  Future<bool> resetPassword(UserModel user) async {
    bool emailEnviado = true;
    try {
      await _auth.sendPasswordResetEmail(email: user.email);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      alertDialog(
          context,
          AlertType.error,
          AppLocalizations.of(context)!.attention.toUpperCase(),
          e.message!
      );
// show the snackbar here
    }
    return emailEnviado;
  }
}
