import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:olx_mobx/components/error_box.dart';
import 'package:olx_mobx/screens/signup/signup_screens.dart';
import 'package:olx_mobx/stores/login_stores.dart';

class LoginScreen extends StatelessWidget {
  // const LoginScreen({Key key}) : super(key: key);

  final LoginStores loginStore = LoginStores();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Entrar"), centerTitle: true),
        body: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 32),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Acessar com E-mail",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[900],
                        ),
                      ),
                      Observer(builder: (_) {
                        return ErrorBox(loginStore.error);
                      }),
                      Padding(
                        padding: const EdgeInsets.only(left: 3, bottom: 4),
                        child: Text(
                          "E-mail",
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Observer(builder: (_) {
                        return TextField(
                          enabled: !loginStore.loading,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                              errorText: loginStore.emailError),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: loginStore.setEmail,
                        );
                      }),
                      const SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 3, bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Senha",
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                "Esqueceu sua senha?",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.purple),
                              ),
                            )
                          ],
                        ),
                      ),
                      Observer(builder: (_) {
                        return TextField(
                          enabled: !loginStore.loading,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                              errorText: loginStore.passwordError),
                          obscureText: true,
                          onChanged: loginStore.setPassoword,
                        );
                      }),
                      Observer(builder: (_) {
                        return Container(
                          height: 40,
                          margin: EdgeInsets.only(top: 20, bottom: 12),
                          child: RaisedButton(
                            onPressed: loginStore.loginPressed,
                            color: Colors.orange,
                            disabledColor: Colors.orange.withAlpha(120),
                            child: loginStore.loading
                                ? CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  )
                                : Text("ENTRAR"),
                            textColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        );
                      }),
                      Divider(color: Colors.black),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              "Não tem uma conta?",
                              style: TextStyle(fontSize: 16),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => SignUpScreens()));
                                },
                                child: Text(
                                  "Cadastre - se",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.purple,
                                    fontSize: 16,
                                  ),
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }
}
