// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

// Para facilitar a leitura do código, cada Planta é um Card personalizado que
// criei aqui, passando os parametros necessários

class Plant extends StatefulWidget {
  Plant(
      {Key? key,
      required this.name,
      required this.imageUrl,
      required this.description,
      required this.showered,
      this.onPressed,
      this.onTap})
      : super(key: key);
  final String name;
  final String imageUrl;
  String description;
  final bool showered;
  final Function()? onPressed;
  final Function()? onTap;

  @override
  State<Plant> createState() => _PlantState();
}

class _PlantState extends State<Plant> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Caso a imagem nao seja passada, retorna uma imagem de erro
          Image.network(
            widget.imageUrl == ''
                ? 'https://icon-library.com/images/picture-unavailable-icon/picture-unavailable-icon-7.jpg'
                : widget.imageUrl,
            height: 150,
            width: 150,
            loadingBuilder: ((context, child, loadingProgress) {
              if (loadingProgress == null) {
                // Se o loading terminar, carrega a imagem
                return child;
              }
              return Container(
                // O widget responsavel por mostrar o loading
                child: CircularProgressIndicator(color: Colors.green),
                height: 50,
                width: 50,
              );
            }),
            errorBuilder: ((context, error, stackTrace) {
              // Caso haja algum erro (como não ser um link válido), retorna um icone
              // de erro no lugar da imagem
              return Icon(
                Icons.error,
                color: Colors.red,
                size: 100,
              );
            }),
          ),
          ListTile(
            title: Text(widget.name),
            subtitle: Text(widget.description),
            trailing: Wrap(
              spacing: 1,
              children: [
                GestureDetector(
                    onTap: widget.onTap,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        Icons.edit,
                        color: Colors.blue,
                        size: 25,
                      ),
                    )),
                IconButton(
                    onPressed: widget.onPressed,
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
