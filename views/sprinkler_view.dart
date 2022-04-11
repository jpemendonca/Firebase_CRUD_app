import 'package:app_plantas/data/sprinkler_functions.dart';
import 'package:app_plantas/models/sprinkler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Aqui a página com a lista dos irrigadores disponíveis no Firebase

class SprinklerInfo extends StatefulWidget {
  static String tag = '/home';
  @override
  _SprinklerInfoState createState() => _SprinklerInfoState();
}

class _SprinklerInfoState extends State<SprinklerInfo> {
  // Essas variáveis são necessárias para o funcionamento e integração com o Firebase

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('irrigador').snapshots();
  CollectionReference sprinkler =
      FirebaseFirestore.instance.collection('irrigador');

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
          // Se houver algum erro ao carregar os dados do Firebase

          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            // Enquanto os dados estão sendo carregados, retorna um círculo de carregamento
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
              // O data são os dados lá do Firebase, em formato de json
              return Sprinkler(
                  onTap: () {
                    var sprinklerName = data['name'];
                    var diametroName = data['diametro'];
                    var instrucoesName = data['instrucoes'];
                    var numPecaName = data['numPeca'];
                    var docId = document.id;
                    print(document.id);

                    // Para a função responsável por editar os irrigadores, passo
                    // como parametros os dados do irrigador
                    editSprinkler(context, sprinklerName, diametroName,
                        instrucoesName, numPecaName, docId);
                  },
                  // Essa é a função que deleta o irrigador, ao tocar na lixeira vermelha
                  onLongPress: () {
                    sprinkler
                        .doc(document.id)
                        .delete()
                        .then((value) => print("Sprinkler Deleted"))
                        .catchError((error) =>
                            print("Failed to delete sprinkler: $error"));
                  },
                  // Essa é a funçao que liga o irrigador
                  onPressed: () async {
                    var docId = document.id;
                    await FirebaseFirestore.instance
                        .collection('irrigador')
                        .doc(docId)
                        .update({'ligado': !data['ligado']})
                        .then((value) => print("Sprinkler on"))
                        .catchError((error) =>
                            print("Failed to turn on sprinkler: $error"));
                  },
                  // E por último os dados para formar cada um dos irrigadores
                  name: data['name'],
                  diametro: data['diametro'],
                  ligado: data['ligado'],
                  instrucoes: data['instrucoes'],
                  numPeca: data['numPeca']);
            }).toList(),
          );
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniStartDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => createSprinkler(context),
        backgroundColor: Colors.green,
        tooltip: 'Adicionar nova planta',
        child: Icon(Icons.add),
      ),
    );
  }
}
