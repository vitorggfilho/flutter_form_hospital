import '../constants/dicionario_dados.dart';

class Paciente {
  String id;
  String nome;
  int idade;
  String diagnostico;
  String telefone;
  String dataInternacao;
  String gravidade;

  Paciente({
    required this.id,
    required this.nome,
    required this.idade,
    required this.diagnostico,
    required this.telefone,
    required this.dataInternacao,
    required this.gravidade,
  });

  Paciente.fromMap(Map<String, dynamic> map)
      : id = map[DicionarioDados.id],
        nome = map[DicionarioDados.nome],
        idade = map[DicionarioDados.idade],
        diagnostico = map[DicionarioDados.diagnostico],
        telefone = map[DicionarioDados.telefone],
        dataInternacao = map[DicionarioDados.dataInternacao],
        gravidade = map[DicionarioDados.gravidade];

  Map<String, dynamic> toMap() {
    return {
      DicionarioDados.id: id,
      DicionarioDados.nome: nome,
      DicionarioDados.idade: idade,
      DicionarioDados.diagnostico: diagnostico,
      DicionarioDados.telefone: telefone,
      DicionarioDados.dataInternacao: dataInternacao,
      DicionarioDados.gravidade: gravidade,
    };
  }
}