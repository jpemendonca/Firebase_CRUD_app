import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../data/plants_functions.dart';
import '../models/plant.dart';

// Essa classe é responsavel por formar a view das plantas disponiveis no Firebase

class PlantInformation extends StatefulWidget {
  static String tag = '/home';
  @override
  _PlantInformationState createState() => _PlantInformationState();
}

class _PlantInformationState extends State<PlantInformation> {
  // Essas variáveis são necessárias para o funcionamento e integração com o Firebase

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('plants2').snapshots();
  CollectionReference plants = FirebaseFirestore.instance.collection('plants2');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Autoponia',
          style: TextStyle(),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        leading: Icon(Icons.nature_people_sharp),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            // Se houver algum erro ao carregar os dados do Firebase

            return Text('Something went wrong');
          }

          // Enquanto os dados estão sendo carregados, retorna um círculo de carregamento

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: 200,
              height: 200,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
            );
          }

          // Se tudo ocorrer bem, retorna a ListView

          return ListView(
            clipBehavior: Clip.antiAlias,
            physics: ScrollPhysics(parent: BouncingScrollPhysics()),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Plant(
                  onTap: () {
                    var plantName = data['name'];
                    var descriptionName = data['description'];
                    var imageUrlName = data['imageUrl'];
                    var docId = document.id;

                    return editPlant(context, plantName, descriptionName,
                        imageUrlName, docId);
                  },
                  onPressed: () {
                    plants
                        .doc(document.id)
                        .delete()
                        .then((value) => print("Plant Deleted"))
                        .catchError(
                            (error) => print("Failed to delete plant: $error"));
                  },
                  name: data['name'],
                  imageUrl: data['imageUrl'],
                  description: data['description'],
                  showered: data['showered']);
            }).toList(),
          );
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniStartDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => modalCreate(context),
        backgroundColor: Colors.green,
        tooltip: 'Adicionar nova planta',
        child: Icon(Icons.add),
      ),
    );
  }
}
