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
}