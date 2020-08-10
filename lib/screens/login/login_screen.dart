import 'package:app_loja_virtual/helpers/validators.dart';
import 'package:app_loja_virtual/models/user.dart';
import 'package:app_loja_virtual/models/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text("Entrar"),
        centerTitle: true,
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
                      SizedBox(
                        height: 46,
                        child: RaisedButton(
                          onPressed: userManager.loading
                              ? null
                              : () async {
                                  if (formKey.currentState.validate()) {
                                    debugPrint(emailController.text);
                                    debugPrint(passController.text);
                                    //FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passController.text);
                                    //context.read<UserManager>().signIn(
                                    userManager.signIn(
                                      user: User(emailController.text,
                                          passController.text),
                                      onFail: (e) {
                                        print(e);
                                        scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                            content:
                                                Text('Falha ao entrar: $e'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      },
                                      onSuccess: () {
                                        print('success');
                                        // TODO: FECHAR ALGUMA COISA
                                      },
                                    );
                                  }
                                },
                          color: Theme.of(context).primaryColor,
                          disabledColor:
                              Theme.of(context).primaryColor.withAlpha(100),
                          textColor: Colors.white,
                          child: userManager.loading
                              ? CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : const Text(
                                  'Entrar',
                                  style: TextStyle(fontSize: 12),
                                ),
                        ),
                      ),
                    ],
                  );
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    child: Text('Esqueci Minha Senha'),
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
