enum GravidadePaciente { leve, moderado, grave }
enum OperacaoCadastro { inclusao, edicao, selecao }

const nomesGravidades = ['Leve', 'Moderado', 'Grave'];

extension GravidadeExtension on GravidadePaciente {
  String get nome {
    switch (this) {
      case GravidadePaciente.leve:
        return 'Leve';
      case GravidadePaciente.moderado:
        return 'Moderado';
      case GravidadePaciente.grave:
        return 'Grave';
    }
  }

  static GravidadePaciente fromString(String nome) {
    switch (nome) {
      case 'Leve':
        return GravidadePaciente.leve;
      case 'Moderado':
        return GravidadePaciente.moderado;
      case 'Grave':
        return GravidadePaciente.grave;
      default:
        return GravidadePaciente.leve;
    }
  }
}