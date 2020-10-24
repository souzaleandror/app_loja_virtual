import 'package:app_loja_virtual/helpers/validators.dart';
import 'package:app_loja_virtual/models/user_manager.dart';
import 'package:app_loja_virtual/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final UserModel user = UserModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (_, userManager, __) {
                return ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(10),
                  children: <Widget>[
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(hintText: 'Nome'),
                      autocorrect: false,
                      validator: (name) {
                        if (name.isEmpty) {
                          return 'Campo Obrigatorio';
                        } else if (name.trim().split(' ').length <= 1) {
                          return 'Preencha seu nome completo';
                        }
                        return null;
                      },
                      onSaved: (name) => user.name = name,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(hintText: 'Email'),
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      validator: (email) {
                        if (email.isEmpty) {
                          return 'Campo Obrigatorio';
                        } else if (!emailValid(email)) {
                          return 'Email Invalido';
                        }
                        return null;
                      },
                      onSaved: (email) => user.email = email,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(hintText: 'Senha'),
                      autocorrect: false,
                      validator: (pass) {
                        if (pass.isEmpty) {
                          return 'Campo Obrigatorio';
                        } else if (pass.length < 6) {
                          return 'Senha muito curta';
                        }
                        return null;
                      },
                      onSaved: (pass) => user.password = pass,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: confirmPasswordController,
                      decoration:
                          const InputDecoration(hintText: 'Confirm Password'),
                      autocorrect: false,
                      obscureText: true,
                      validator: (pass) {
                        if (pass.isEmpty) {
                          return 'Campo obrigatorio';
                        } else if (pass.length < 6) {
                          return 'Senha curta';
                        }
                        return null;
                      },
                      onSaved: (confirmPassword) =>
                          user.confirmPassword = confirmPassword,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: userManager.loading
                          ? null
                          : () async {
                              if (formKey.currentState.validate()) {
                                formKey.currentState.save();
                                if (user.password != user.confirmPassword) {
                                  scaffoldKey.currentState.showSnackBar(
                                    const SnackBar(
                                      content: Text('Senha nao coincidem !'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                context.read<UserManager>().signUp(
                                    user: user,
                                    onSuccess: () {
                                      debugPrint('Success');
                                      // TODO: POP
                                      Navigator.of(context).pop();
                                    },
                                    onFail: (e) {
                                      scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Falha ao cadastrar: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    });
                              }
                            },
                      color: Theme.of(context).primaryColor,
                      disabledColor:
                          Theme.of(context).primaryColor.withAlpha(100),
                      textColor: Colors.white,
                      child: userManager.loading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                          : const Text(
                              'Criar Conta',
                              style: TextStyle(fontSize: 14),
                            ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
