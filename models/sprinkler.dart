// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

// Assim como fiz na planta, criei um widget personalizado para o irrigador,
// que tambem retorna um Card
class Sprinkler extends StatefulWidget {
  Sprinkler(
      {Key? key,
      required this.name,
      this.onPressed,
      this.onTap,
      required this.diametro,
      required this.ligado,
      required this.instrucoes,
      required this.numPeca,
      this.onLongPress})
      : super(key: key);
  final String name;
  final String diametro;
  final bool ligado;
  final String instrucoes;
  final String numPeca;

  final Function()? onPressed;
  final Function()? onTap;
  final Function()? onLongPress;

  @override
  State<Sprinkler> createState() => _SprinklerState();
}

// Uma diferença ao widget da Planta, é que aqui nao passei a imagem do irrigador
// como parametro, apenas que caso ele esteja ligado retorna um gif de irrigador
// ligado, e se desligado retorna uma imagem de um irrigador desligado

// Outra diferença é que para excluir um irrigador é necessario dar um longPress
// no botão de deletar

class _SprinklerState extends State<Sprinkler> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Image.network(
            widget.ligado
                ? 'https://media.giphy.com/media/Ynou5pGmbqMXw0kfpS/giphy.gif'
                : 'https://img.freepik.com/fotos-gratis/irrigador-de-gramado-em-grama-verde-desligado_361816-2793.jpg',
            height: 300,
            width: 300,
            loadingBuilder: ((context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Container(
                child: CircularProgressIndicator(color: Colors.green),
                height: 50,
                width: 50,
              );
            }),
            errorBuilder: ((context, error, stackTrace) {
              return Icon(
                Icons.error,
                color: Colors.red,
                size: 100,
              );
            }),
          ),
          Column(
            children: [
              ListTile(
                title: Text(
                  widget.name,
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: Text(
                  'Instruções: ${widget.instrucoes}',
                  style: TextStyle(fontSize: 18),
                ),
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
                    GestureDetector(
                      onLongPress: widget.onLongPress,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 25,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Text(
                'Diametro de irrigação: ${widget.diametro} metros',
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      widget.ligado
                          ? 'Deseja desligar manualmente?'
                          : 'Deseja ligar manualmente?',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(width: 30),
                  IconButton(
                    onPressed: widget.onPressed,
                    icon: Icon(widget.ligado
                        ? Icons.check_box
                        : Icons.check_box_outline_blank_sharp),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                'Numero da peça: ${widget.numPeca}',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
