import 'dart:convert';
import '../models/paciente.dart';
import 'arquivo.dart';
import '../constants/dicionario_dados.dart';

class ControlePaciente {
  final Map<String, Paciente> _pacientes = {}; // id -> Paciente

  // Lê os pacientes do arquivo e popula o mapa
  Future<void> lerPacientes() async {
    String conteudo = await Arquivo.instancia().lerArquivo();
    Map<String, dynamic> mapaCompleto = json.decode(conteudo);
    List<dynamic> listaPacientes = mapaCompleto[DicionarioDados.pacientes];
    for (var mapa in listaPacientes) {
      Paciente p = Paciente.fromMap(mapa);
      _pacientes[p.id] = p;
    }
  }

  // Retorna a lista de pacientes (ordenada por nome, por exemplo)
  Future<List<Paciente>> obterListaPacientes() async {
    if (_pacientes.isEmpty) {
      await lerPacientes();
    }
    List<Paciente> lista = _pacientes.values.toList();
    lista.sort((a, b) => a.nome.compareTo(b.nome));
    return lista;
  }

  // Gera o mapa completo para salvar
  Map<String, dynamic> _gerarMapa() {
    List<Map<String, dynamic>> mapasPacientes = [];
    for (var paciente in _pacientes.values) {
      mapasPacientes.add(paciente.toMap());
    }
    return {DicionarioDados.pacientes: mapasPacientes};
  }

  // Salva o arquivo (chamado internamente após cada alteração)
  Future<void> _salvar() async {
    Map<String, dynamic> mapa = _gerarMapa();
    String conteudo = json.encode(mapa);
    await Arquivo.instancia().salvarArquivo(conteudo);
  }

  // Incluir novo paciente
  Future<bool> incluir(Paciente paciente) async {
    try {
      _pacientes[paciente.id] = paciente;
      await _salvar();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Alterar paciente existente
  Future<bool> alterar(Paciente paciente) async {
    try {
      _pacientes[paciente.id] = paciente;
      await _salvar();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Excluir paciente pelo id
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