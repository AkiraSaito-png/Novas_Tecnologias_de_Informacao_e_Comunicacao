import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class Tarefa {
  final String uid;
  final String enunciado;
  final String alternativa_a;
  final String alternativa_b;
  final String alternativa_c;
  final String alternativa_d;
  final String alternativa_correta;
  final Timestamp criado_em;
  final Timestamp atualizado_em;
  final bool ativo;
  

  Tarefa(this.uid, this.enunciado, this.alternativa_a, this.alternativa_b, this.alternativa_c, this.alternativa_d, this.alternativa_correta, this.criado_em, this.atualizado_em, this.ativo);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'enunciado': enunciado,
      'alternativa_a': alternativa_a,
      'alternativa_b': alternativa_b,
      'alternativa_c': alternativa_c,
      'alternativa_d': alternativa_d,
      'alternativa_correta': alternativa_correta,
      'criado_em': criado_em,
      'atualizado_em': atualizado_em,
      'ativo': ativo
    };
  }

  factory Tarefa.fromJson(Map<String, dynamic> json) {
    return Tarefa(
      json['uid'],
      json['enunciado'],
      json['alternativa_a'],
      json['alternativa_b'],
      json['alternativa_c'],
      json['alternativa_d'],
      json['alternativa_correta'],
      json['criado_em'],
      json['atualizado_em'],
      json['ativo']
    );
  }
}