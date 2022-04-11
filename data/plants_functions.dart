import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../views/plant_form_field.dart';

// Essa função abre o dialog para editar uma planta
editPlant(
    BuildContext context, plantName, descriptionName, imageUrlName, docId) {
  var form = GlobalKey<FormState>();

  var plantController = TextEditingController(text: plantName.toString());
  var descriptionController =
      TextEditingController(text: descriptionName.toString());
  var imageUrlController = TextEditingController(text: imageUrlName.toString());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Editar planta'),
        content: Form(
          key: form,
          child: Container(
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomTextField(
                    controller: plantController, hintText: 'Nome da planta'),
                SizedBox(height: 15),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'Descrição',
                ),
                SizedBox(height: 15),
                CustomTextField(
                  controller: imageUrlController,
                  hintText: 'Url da imagem',
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
                  .collection('plants2')
                  .doc(docId)
                  .update({
                    'name': plantController.text,
                    'description': descriptionController.text,
                    'imageUrl': imageUrlController.text
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

// Essa função abre o dialog para criar uma nova planta
modalCreate(BuildContext context) {
  var form = GlobalKey<FormState>();

  var plantName = TextEditingController();
  var description = TextEditingController();
  var imageUrl = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Criar nova planta'),
        content: Form(
          key: form,
          child: Container(
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomTextField(
                    controller: plantName, hintText: 'Nome da planta'),
                SizedBox(height: 15),
                CustomTextField(
                  controller: description,
                  hintText: 'Descrição',
                ),
                SizedBox(height: 15),
                CustomTextField(
                  controller: imageUrl,
                  hintText: 'Url da imagem',
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
                  .collection('plants2')
                  .doc()
                  .set({
                    'name': plantName.text,
                    'description': description.text,
                    'imageUrl': imageUrl.text,
                    'showered': false
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
