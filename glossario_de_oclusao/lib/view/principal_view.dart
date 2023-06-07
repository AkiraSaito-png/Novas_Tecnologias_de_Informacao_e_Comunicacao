// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../controller/login_controller.dart';
import '../controller/tarefa_controller.dart';
import '../model/tarefa.dart';

class PrincipalView extends StatefulWidget {
  const PrincipalView({super.key});

  @override
  State<PrincipalView> createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView> {
  var txtEnunciado = TextEditingController();
  var txtA = TextEditingController();
  var txtB = TextEditingController();
  var txtC = TextEditingController();
  var txtD = TextEditingController();
  var txtAlternativa_correta = TextEditingController();
  bool checkboxA = false;
  bool checkboxB = false;
  bool checkboxC = false;
  bool checkboxD = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: Text('Tarefas')),
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
                      icon: Icon(Icons.exit_to_app, size: 14),
                      label: Text(snapshot.data.toString()),
                    ),
                  );
                }
                return Text('');
              },
            ),
          ],
        ),
      ),

      // BODY
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
                            txtAlternativa_correta.text = item['alternativa_correta'];
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          salvarTarefa(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  //
  // ADICIONAR TAREFA
  //
  void salvarTarefa(context, {docId}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: Text("Adicionar Tarefa"),
          content: SizedBox(
            child: Column(
              children: [
                TextField(
                  controller: txtEnunciado,
                  decoration: InputDecoration(
                    labelText: 'Enunciado',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: txtA,
                  decoration: InputDecoration(
                    labelText: 'Alternativa A',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: txtB,
                  decoration: InputDecoration(
                    labelText: 'Alternativa B',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: txtC,
                  decoration: InputDecoration(
                    labelText: 'Alternativa C',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: txtD,
                  decoration: InputDecoration(
                    labelText: 'Alternativa D',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: txtAlternativa_correta,
                  decoration: InputDecoration(
                    labelText: 'Alternativa correta',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
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
                txtAlternativa_correta.clear();
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
                  value: checkboxA,
                  onChanged: (bool? value) {
                    setState(() {
                      checkboxA = value!;
                    });
                  },
                  title: const Text('Alternativa A'),
                  subtitle: Text(txtA.text)
                ),
                const Divider(height: 0),
                CheckboxListTile(
                  value: checkboxB,
                  onChanged: (bool? value) {
                    setState(() {
                      checkboxB = value!;
                    });
                  },
                  title: const Text('Alternativa B'),
                  subtitle: Text(txtB.text),
                ),
                const Divider(height: 0),
                CheckboxListTile(
                  value: checkboxC,
                  onChanged: (bool? value) {
                    setState(() {
                      checkboxC = value!;
                    });
                  },
                  title: const Text('Alternativa C'),
                  subtitle: Text(txtC.text),
                ),
                const Divider(height: 0),
                CheckboxListTile(
                  value: checkboxD,
                  onChanged: (bool? value) {
                    setState(() {
                      checkboxD = value!;
                    });
                  },
                  title: const Text('Alternativa D'),
                  subtitle: Text(txtD.text),
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
                txtAlternativa_correta.clear();
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
}