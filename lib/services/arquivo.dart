import 'package:shared_preferences/shared_preferences.dart';
import '../constants/dicionario_dados.dart';

class Arquivo {
  static const String _chavePacientes = DicionarioDados.pacientes;

  Arquivo();

  factory Arquivo.instancia() => Arquivo();

  Future<String> lerArquivo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? conteudo = prefs.getString(_chavePacientes);
    if (conteudo == null) {
      // Retorna um JSON vazio com a lista de pacientes
      conteudo = '{"$_chavePacientes":[]}';
    }
    return conteudo;
  }

  Future<void> salvarArquivo(String conteudo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chavePacientes, conteudo);
  }
}