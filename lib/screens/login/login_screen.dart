import 'package:app_loja_virtual/helpers/validators.dart';
import 'package:app_loja_virtual/models/user_manager.dart';
import 'package:app_loja_virtual/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/signup');
            },
            textColor: Colors.white,
            child: const Text(
              'CRIAR CONTA',
              style: TextStyle(fontSize: 14),
            ),
          )
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Form(
              key: formKey,
              child: Consumer<UserManager>(
                builder: (context, userManager, child) {
                  if (userManager.loadingFace) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).primaryColor),
                      ),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.all(10),
                    shrinkWrap: true,
                    children: <Widget>[
                      TextFormField(
                        enabled: !userManager.loading,
                        controller: emailController,
                        decoration: const InputDecoration(hintText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        validator: (email) {
                          if (!emailValid(email)) {
                            return 'Email Invalido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        enabled: !userManager.loading,
                        controller: passController,
                        decoration: const InputDecoration(hintText: 'Senha'),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        obscureText: true,
                        validator: (pass) {
                          if (pass.isEmpty || pass.length < 6) {
                            return "Senha invalida";
                          }
                          return null;
                        },
                      ),
                      child,
                      const SizedBox(
                        height: 16,
                      ),
                      RaisedButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: userManager.loading
                            ? null
                            : () async {
                                if (formKey.currentState.validate()) {
                                  debugPrint(emailController.text);
                                  debugPrint(passController.text);
                                  //FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passController.text);
                                  //context.read<UserManager>().signIn(
                                  userManager.signIn(
                                    user: UserModel(
                                        email: emailController.text,
                                        password: passController.text),
                                    onFail: (e) {
                                      debugPrint(e.toString());
                                      scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
                                          content: Text('Falha ao entrar: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    },
                                    onSuccess: () {
                                      debugPrint('success');
                                      // TODO: FECHAR ALGUMA COISA
                                      Navigator.of(context).pop();
                                    },
                                  );
                                }
                              },
                        color: Theme.of(context).primaryColor,
                        disabledColor:
                            Theme.of(context).primaryColor.withAlpha(100),
                        textColor: Colors.white,
                        child: userManager.loading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              )
                            : const Text(
                                'Entrar',
                                style: TextStyle(fontSize: 15),
                              ),
                      ),
                      SignInButton(
                        Buttons.Facebook,
                        onPressed: () {
                          userManager.facebookLogin(
                            onFail: (e) {
                              debugPrint(e.toString());
                              scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text('Falha ao entrar: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                            onSuccess: () {
                              debugPrint('success');
                              // TODO: FECHAR ALGUMA COISA
                              Navigator.of(context).pop();
                            },
                          );
                        },
                        text: 'Entrar com Facebook',
                      ),
                    ],
                  );
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    child: const Text('Esqueci Minha Senha'),
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
