import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:viska_erp_mobile/app/modules/home/store/home_store.dart';
import 'package:viska_erp_mobile/app/widgets/custom_animated_button.dart';
import 'package:viska_erp_mobile/app/widgets/input_customized.dart';
import 'package:viska_erp_mobile/app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viska_erp_mobile/flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeStore controller = Modular.get();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final telController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    onInit();
  }

  void onInit() async {
    await controller.recoverUserData();
    setState(() {
      nameController.text = controller.userModel.name;
      emailController.text = controller.userModel.email;
      telController.text = controller.userModel.phone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Observer(
        builder: (_) => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: purple,
            elevation: 0,
            actions: [_buildIconTheme()],
            title: _buildTitleAppBar(context),
          ),
          drawer: _buildDrawer(),
          body: _buildBody(),
        ),
      ),
    );
  }

  IconButton _buildIconTheme() {
    return IconButton(
      icon: controller.appStore.isDark
          ? const Icon(Icons.light_mode_sharp)
          : const Icon(Icons.dark_mode_sharp),
      onPressed: () async {
        controller.appStore.changeTheme();
      },
    );
  }

  Text _buildTitleAppBar(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.myProfile.toUpperCase(),
      style: GoogleFonts.syne(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: white,
      ),
    );
  }

  Widget _buildDrawer() {
    var syne = GoogleFonts.syne(fontSize: 16);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(color: purple),
              child: Container(child:Text('VISKA DRYWALL\n${DateFormat('dd/MM/yyyy').format(DateTime.now())} -  \n${DateTime.now().hour}:${DateTime.now().minute}'
                  ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),textAlign:TextAlign.center))),
          ListTile(
            leading: const Icon(Icons.arrow_back),
            title: Text('Voltar', style: syne),
            onTap: () {
              Modular.to.navigate('/');
            },
          ),

          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(AppLocalizations.of(context)!.editProfile, style: syne),
            onTap: () {
              Modular.to.navigate('/home/edit');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_remove_alt_1_rounded),
            title:
                Text(AppLocalizations.of(context)!.deleteAccount, style: syne),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _alertShowDialog(
                    message:
                        AppLocalizations.of(context)!.youWantDeleteYourAccount,
                    buttonText:
                        AppLocalizations.of(context)!.delete.toUpperCase(),
                    onTap: () async {
                      await controller.deleteAccount();
                    },
                  );
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(AppLocalizations.of(context)!.language, style: syne),
            onTap: () => Modular.to.pushNamed('/home/language'),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(AppLocalizations.of(context)!.toGoOut, style: syne),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _alertShowDialog(
                    message: AppLocalizations.of(context)!.disconnectFromApp,
                    buttonText:
                        AppLocalizations.of(context)!.toGoOut.toUpperCase(),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Modular.to.navigate('/login');
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: controller.loading
          ? const Center(
              child: Center(child: CircularProgressIndicator(color: purple)))
          : _buildUserData(),
    );
  }

  Widget _buildUserData() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildUserPhoto(),
            _buildUserInformation(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserPhoto() {
    return Stack(
      children: [
        SizedBox(
          height: 180,
          width: 180,
          child: Card(
            elevation: 8.0,
            color: Colors.white.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(150),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(150),
              child: CachedNetworkImage(
                filterQuality: FilterQuality.high,
                colorBlendMode: BlendMode.colorBurn,
                imageUrl: controller.userModel.userImage.isEmpty
                    ? "https://img.myloview.com.br/posters/user-icon-human-person-symbol-avatar-login-sign-700-258992648.jpg"
                    : controller.userModel.userImage,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ),
        if (controller.readOnly == false)
          Positioned(
            right: 0,
            left: 0,
            top: 0,
            bottom: 0,
            child: Icon(
              Icons.camera_alt_outlined,
              color: Colors.white.withOpacity(0.6),
              size: 45,
            ),
          ),
      ],
    );
  }

  Widget _buildUserInformation() {
    return Column(
      children: [
        const SizedBox(height: 15),
        InputCustomized(
          icon: Icons.person,
          readOnly: true,
          hintText: controller.userModel.name,
          hintStyle: const TextStyle(color: darkPurple),
          keyboardType: TextInputType.text,
          controller: nameController,
        ),
        const SizedBox(height: 10),
        InputCustomized(
          icon: Icons.email_outlined,
          readOnly: true,
          hintText: controller.userModel.email,
          hintStyle: const TextStyle(color: darkPurple),
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
        ),
        const SizedBox(height: 10),
        InputCustomized(
          icon: Icons.phone,
          readOnly: true,
          hintText: controller.userModel.phone,
          hintStyle: const TextStyle(color: darkPurple),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            TelefoneInputFormatter(),
          ],
          controller: telController,
        ),
        const SizedBox(height: 10),
        InputCustomized(
          icon: Icons.credit_card_rounded,
          readOnly: true,
          hintText: controller.userModel.cpf,
          hintStyle: GoogleFonts.syne(color: darkPurple),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 10),
        InputCustomized(
          icon: Icons.person_outline_outlined,
          readOnly: true,
          hintText: controller.userModel.genre,
          hintStyle: GoogleFonts.syne(color: darkPurple),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 10),
        InputCustomized(
          icon: Icons.people,
          readOnly: true,
          hintText: controller.userModel.maritalStatus,
          hintStyle: GoogleFonts.syne(color: darkPurple),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  _alertShowDialog({
    String? message,
    String? buttonText,
    Function? onTap,
  }) {
    return AlertDialog(
      title: Center(
          child: Text(AppLocalizations.of(context)!.attention,
              style: GoogleFonts.syne(fontWeight: FontWeight.bold))),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 180,
        child: Column(
          children: [
            Text(
              message!,
              textAlign: TextAlign.center,
              style: GoogleFonts.syne(fontSize: 16),
            ),
            const Spacer(),
            CustomAnimatedButton(
              onTap: onTap,
              widhtMultiply: 1,
              height: 45,
              colorText: white,
              color: purple,
              text: buttonText!,
            ),
            const SizedBox(height: 10),
            CustomAnimatedButton(
              onTap: () => Modular.to.pop(),
              widhtMultiply: 1,
              height: 45,
              colorText: black,
              color: grey.withOpacity(0.2),
              text: AppLocalizations.of(context)!.cancel.toUpperCase(),
            ),
          ],
        ),
      ),
    );
  }
}
