class Tarefa {
  final String uid;
  final String enunciado;
  final String alternativa_a;
  final String alternativa_b;
  final String alternativa_c;
  final String alternativa_d;
  final String alternativa_correta;

  Tarefa(this.uid, this.enunciado, this.alternativa_a, this.alternativa_b, this.alternativa_c, this.alternativa_d, this.alternativa_correta);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'enunciado': enunciado,
      'alternativa_a': alternativa_a,
      'alternativa_b': alternativa_b,
      'alternativa_c': alternativa_c,
      'alternativa_d': alternativa_d,
      'alternativa_correta': alternativa_correta
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
      json['alternativa_correta']
    );
  }
}