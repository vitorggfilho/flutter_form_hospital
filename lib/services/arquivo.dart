import 'package:shared_preferences/shared_preferences.dart';
import '../constants/dicionario_dados.dart';

class Arquivo {
  // Chave única para armazenar a lista de pacientes no SharedPreferences
  static const String _chavePacientes = DicionarioDados.pacientes;

  Arquivo();

  // Singleton (opcional, mas mantém o padrão)
  factory Arquivo.instancia() => Arquivo();

  /// Lê o conteúdo do arquivo (na verdade, do SharedPreferences)
  Future<String> lerArquivo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? conteudo = prefs.getString(_chavePacientes);
    if (conteudo == null) {
      // Retorna um JSON vazio com a lista de pacientes
      conteudo = '{"$_chavePacientes":[]}';
    }
    return conteudo;
  }

  /// Salva o conteúdo no SharedPreferences
  Future<void> salvarArquivo(String conteudo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chavePacientes, conteudo);
  }
}