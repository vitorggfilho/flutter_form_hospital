import 'dart:convert';
import '../models/paciente.dart';
import 'arquivo.dart';
import '../constants/dicionario_dados.dart';

class ControlePaciente {
  final Map<String, Paciente> _pacientes = {};

  Future<void> lerPacientes() async {
    String conteudo = await Arquivo.instancia().lerArquivo();
    Map<String, dynamic> mapaCompleto = json.decode(conteudo);
    List<dynamic> listaPacientes = mapaCompleto[DicionarioDados.pacientes];
    for (var mapa in listaPacientes) {
      Paciente p = Paciente.fromMap(mapa);
      _pacientes[p.id] = p;
    }
  }

  Future<List<Paciente>> obterListaPacientes() async {
    if (_pacientes.isEmpty) {
      await lerPacientes();
    }
    List<Paciente> lista = _pacientes.values.toList();
    lista.sort((a, b) => a.nome.compareTo(b.nome));
    return lista;
  }

  Map<String, dynamic> _gerarMapa() {
    List<Map<String, dynamic>> mapasPacientes = [];
    for (var paciente in _pacientes.values) {
      mapasPacientes.add(paciente.toMap());
    }
    return {DicionarioDados.pacientes: mapasPacientes};
  }

  Future<void> _salvar() async {
    Map<String, dynamic> mapa = _gerarMapa();
    String conteudo = json.encode(mapa);
    await Arquivo.instancia().salvarArquivo(conteudo);
  }

  Future<bool> incluir(Paciente paciente) async {
    try {
      _pacientes[paciente.id] = paciente;
      await _salvar();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> alterar(Paciente paciente) async {
    try {
      _pacientes[paciente.id] = paciente;
      await _salvar();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> excluir(String id) async {
    try {
      _pacientes.remove(id);
      await _salvar();
      return true;
    } catch (e) {
      return false;
    }
  }
}