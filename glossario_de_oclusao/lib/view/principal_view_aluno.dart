// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../controller/login_controller.dart';
import '../controller/tarefa_controller.dart';
import '../model/tarefa.dart';

class PrincipalViewAluno extends StatefulWidget {
  const PrincipalViewAluno({super.key});

  @override
  State<PrincipalViewAluno> createState() => _PrincipalViewAlunoState();
}

class _PrincipalViewAlunoState extends State<PrincipalViewAluno> {
  var busca = TextEditingController();
  var txtEnunciado = TextEditingController();
  var txtA = TextEditingController();
  var txtB = TextEditingController();
  var txtC = TextEditingController();
  var txtD = TextEditingController();
  var txtAlternativa_correta = TextEditingController();
  var criado_em;
  var atualizado_em;
  var ativo;
  bool checkboxA = false;
  bool checkboxB = false;
  bool checkboxC = false;
  bool checkboxD = false;
  
  var index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 75, 75, 75),
        title: Row(
          children: [
            Expanded(child: Text('Area do aluno')),
            FutureBuilder<String>(
              future: LoginController().usuarioLogado(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(fontSize: 12),
                      ),
                      onPressed: () {
                        LoginController().logout();
                        Navigator.pushReplacementNamed(context, 'login');
                      },
                      icon: Icon(Icons.exit_to_app, size: 20),
                      label: Text('Sair'),
                    ),
                  );
                }
                TextField(
                      controller: busca,
                      decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'Pesquisar'),    
                      onChanged: searchBar,                  
                    );
                return Visibility(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Area do Aluno',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    const SizedBox(height: 20),

                    // create a searchbar
                    
                  ],
                  ),
                  
                );
                
              },
              
            ),
            
          ],
        ),
      ),

      // BODY
      backgroundColor: Color.fromARGB(255, 126, 126, 126),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: TarefaController().listar().snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(
                  child: Text('Não foi possível conectar.'),
                );
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                final dados = snapshot.requireData;
                if (dados.size > 0) {
                  return ListView.builder(
                    itemCount: dados.size,
                    itemBuilder: (context, index) {
                      String id = dados.docs[index].id;
                      dynamic item = dados.docs[index].data();
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.description),
                          title: Text(item['enunciado']),
                          onTap: () {
                            txtEnunciado.text = item['enunciado'];
                            txtA.text = item['alternativa_a'];
                            txtB.text = item['alternativa_b'];
                            txtC.text = item['alternativa_c'];
                            txtD.text = item['alternativa_d'];
                            txtAlternativa_correta.text =
                                item['alternativa_correta'];
                            alternativas(context, docId: id);
                          },
                          onLongPress: () {
                            TarefaController().excluir(context, id);
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text('Nenhuma tarefa encontrada.'),
                  );
                }
            }
          },
        ),
      ),
    );
  }

  void alternativas(context, {docId}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: Text("Adicionar Tarefa"),
          content: SizedBox(
            child: Column(
              children: <Widget>[
                Text(txtEnunciado.text),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: checkboxA,
                  title: const Text('Alternativa A'),
                  subtitle: Text(txtA.text),
                  onChanged: (bool? value) {
                    setState(() {
                      checkboxA = value!;
                    });
                  },
                ),
                const Divider(height: 0),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: checkboxB,
                  title: const Text('Alternativa B'),
                  subtitle: Text(txtB.text),
                  onChanged: (bool? value) {
                    setState(() {
                      checkboxB = value!;
                    });
                  },
                ),
                const Divider(height: 0),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: checkboxC,
                  title: const Text('Alternativa C'),
                  subtitle: Text(txtC.text),
                  onChanged: (bool? value) {
                    setState(() {
                      checkboxC = value!;
                    });
                  },
                ),
                const Divider(height: 0),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.blue,
                  value: checkboxD,
                  title: const Text('Alternativa D'),
                  subtitle: Text(txtD.text),
                  onChanged: (bool? value) {
                    setState(() {
                      checkboxD = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actionsPadding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          actions: [
            TextButton(
              child: Text("fechar"),
              onPressed: () {
                txtEnunciado.clear();
                txtA.clear();
                txtB.clear();
                txtC.clear();
                txtD.clear();
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("salvar"),
              onPressed: () {
                var t = Tarefa(
                  LoginController().idUsuario(),
                  txtEnunciado.text,
                  txtA.text,
                  txtB.text,
                  txtC.text,
                  txtD.text,
                  txtAlternativa_correta.text,
                  criado_em,
                  atualizado_em,
                  ativo
                );
                txtEnunciado.clear();
                txtA.clear();
                txtB.clear();
                txtC.clear();
                txtD.clear();
                txtAlternativa_correta.clear();
                if (docId == null) {
                  //
                  // ADICIONAR TAREFA
                  //
                  TarefaController().adicionar(context, t);
                } else {
                  //
                  // ATUALIZAR TAREFA
                  //
                  TarefaController().atualizar(context, docId, t);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void searchBar(String query){
    child: StreamBuilder<QuerySnapshot>(
          stream: TarefaController().listar().snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(
                  child: Text('Não foi possível conectar.'),
                );
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                final dados = snapshot.requireData;
                String id = dados.docs[index].id;
                dynamic item = dados.docs[index].data();
                final suggestions = item['enunciado'].where((tarefa) {
                  final title = tarefa.title.toLowerCase();
                  final input = query.toLowerCase();

                  return title.contains(input);
                }).toList();
                        };
                        return Text('');
                      },
          
    );
  }
}
