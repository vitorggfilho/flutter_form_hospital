import 'package:flutter/material.dart';
import '../models/paciente.dart';
import 'paciente_form_screen.dart';
import '../widgets/paciente_tile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Paciente> _pacientes = [];

  void _adicionarPaciente(Paciente paciente) {
    setState(() {
      _pacientes.add(paciente);
    });
  }

  void _atualizarPaciente(Paciente pacienteAtualizado) {
    setState(() {
      int index = _pacientes.indexWhere((p) => p.id == pacienteAtualizado.id);
      if (index != -1) {
        _pacientes[index] = pacienteAtualizado;
      }
    });
  }

  void _excluirPaciente(String id) {
    setState(() {
      _pacientes.removeWhere((p) => p.id == id);
    });
  }

  void _navegarParaForm({Paciente? paciente}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PacienteFormScreen(
          paciente: paciente,
          onSalvar: (pacienteSalvo) {
            if (paciente == null) {
              _adicionarPaciente(pacienteSalvo);
            } else {
              _atualizarPaciente(pacienteSalvo);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestão de Pacientes'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        elevation: 4,
      ),
      body: _pacientes.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.health_and_safety, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Nenhum paciente cadastrado',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Clique no botão + para adicionar',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: _pacientes.length,
        itemBuilder: (context, index) {
          return PacienteTile(
            paciente: _pacientes[index],
            onEditar: () => _navegarParaForm(paciente: _pacientes[index]),
            onExcluir: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Confirmar exclusão'),
                  content: Text(
                    'Tem certeza que deseja excluir ${_pacientes[index].nome}?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        _excluirPaciente(_pacientes[index].id);
                        Navigator.pop(context);
                      },
                      child: Text('Excluir', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navegarParaForm(),
        child: Icon(Icons.add),
        tooltip: 'Adicionar Paciente',
        backgroundColor: Colors.greenAccent,
      ),
    );
  }
}