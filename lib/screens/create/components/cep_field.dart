import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:olx_mobx/stores/cep_stores.dart';

class CepField extends StatelessWidget {
  final CepStore cepStore = CepStore();
  //const CepField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          onChanged: cepStore.setCep,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CepInputFormatter()
          ],
          decoration: InputDecoration(
              labelText: "CEP *",
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.grey,
                  fontSize: 18),
              contentPadding: EdgeInsets.fromLTRB(16, 10, 12, 10)),
        ),
        Observer(builder: (_) {
          if (cepStore.adress == null &&
              cepStore.error == null &&
              !cepStore.loading)
            return Container();
          else if (cepStore.adress == null && cepStore.error == null)
            return LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.purple),
              backgroundColor: Colors.transparent,
            );
          else if (cepStore.error != null)
            return Container(
              color: Colors.red.withAlpha(100),
              height: 50,
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text(
                cepStore.error,
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
              ),
            );
          else {
            final a = cepStore.adress;
            return Container(
                color: Colors.purple.withAlpha(150),
                height: 50,
                padding: EdgeInsets.all(8),
                alignment: Alignment.center,
                child: Text(
                  'Loacalização: ${a.district}, ${a.city.name} - ${a.uf.initials}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ));
          }
        })
      ],
    );
  }
}