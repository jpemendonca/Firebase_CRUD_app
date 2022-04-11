import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../views/plant_form_field.dart';

// Essa função é usada para editar o irrigador
// Ela recebe como parametros, além do contexto, os dados do irrigador, que são
// nome, diametro de irrigacao, instruções, numero da peça. Também recebe o
// id do documento que vamos modificar lá no Firebase
editSprinkler(BuildContext context, sprinklerName, diametroName, instrucoesName,
    numPecaName, docId) {
  var form = GlobalKey<FormState>();

// Os controllers são criados para termos um controle do que está escrito
// em cada textField, e recebem como valor inicial os dados que já estavam salvos
// lá no firebase
  var sprinklerNameController =
      TextEditingController(text: sprinklerName.toString());
  var diametroNameController =
      TextEditingController(text: diametroName.toString());
  var instrucoesNameController =
      TextEditingController(text: instrucoesName.toString());
  var numPecaNameController =
      TextEditingController(text: numPecaName.toString());

// Abre a caixa de diálogo
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Editar irrigador'),
        content: Form(
          key: form,
          child: Container(
            height: MediaQuery.of(context).size.height / 2.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomTextField(
                    controller: sprinklerNameController,
                    hintText: 'Nome do irrigador'),
                SizedBox(height: 15),
                CustomTextField(
                  controller: diametroNameController,
                  hintText: 'Cobertura do irrigador (em metros)',
                ),
                SizedBox(height: 15),
                CustomTextField(
                  controller: instrucoesNameController,
                  hintText: 'Defina as instruções do irrigador',
                ),
                SizedBox(height: 15),
                CustomTextField(
                  controller: numPecaNameController,
                  hintText: 'Número da peça',
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('irrigador')
                  .doc(docId)
                  .update({
                    'name': sprinklerNameController.text,
                    'instrucoes': instrucoesNameController.text,
                    'numPeca': numPecaNameController.text,
                    'diametro': diametroNameController.text
                  })
                  .then((value) => print("User Added"))
                  .catchError((error) => print("Failed to add user: $error"));
              Navigator.of(context).pop();
            },
            child: Text(
              'Salvar',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      );
    },
  );
}

// Essa função é usada para criar um irrigador
createSprinkler(BuildContext context) {
  var form = GlobalKey<FormState>();

  var sprinklerNameController = TextEditingController();
  var diametroNameController = TextEditingController();
  var instrucoesNameController = TextEditingController();
  var numPecaNameController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Criar nova planta'),
        content: Form(
          key: form,
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomTextField(
                    controller: sprinklerNameController,
                    hintText: 'Nome do irrigador'),
                SizedBox(height: 15),
                CustomTextField(
                  controller: diametroNameController,
                  hintText: 'Diametro do irrigador',
                ),
                SizedBox(height: 15),
                CustomTextField(
                  controller: instrucoesNameController,
                  hintText: 'Instruções: Ex ligar a cada 15h',
                ),
                SizedBox(height: 15),
                CustomTextField(
                  controller: numPecaNameController,
                  hintText: 'Numero da peça',
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('irrigador')
                  .doc()
                  .set({
                    'name': sprinklerNameController.text,
                    'diametro': diametroNameController.text,
                    'instrucoes': instrucoesNameController.text,
                    'ligado': false,
                    'numPeca': numPecaNameController.text
                  })
                  .then((value) => print("User Added"))
                  .catchError((error) => print("Failed to add user: $error"));
              Navigator.of(context).pop();
            },
            child: const Text(
              'Salvar',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      );
    },
  );
}
