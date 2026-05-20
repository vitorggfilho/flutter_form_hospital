import 'package:flutter/material.dart';
import '../models/paciente.dart';
import 'paciente_form_screen.dart';
import '../widgets/paciente_tile.dart';
import '../services/ControlePaciente.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ControlePaciente _controle = ControlePaciente();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestão de Pacientes'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      body: FutureBuilder<List<Paciente>>(
        future: _controle.obterListaPacientes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.health_and_safety, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Nenhum paciente cadastrado',
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 8),
                  Text('Clique no botão + para adicionar',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            );
          }
          final pacientes = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: pacientes.length,
            itemBuilder: (context, index) {
              return PacienteTile(
                paciente: pacientes[index],
                onEditar: () => _navegarParaForm(paciente: pacientes[index]),
                onExcluir: () => _confirmarExclusao(pacientes[index]),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navegarParaForm(),
        child: Icon(Icons.add),
        backgroundColor: Colors.greenAccent,
      ),
    );
  }

  void _navegarParaForm({Paciente? paciente}) async {
    final pacienteSalvo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PacienteFormScreen(
          paciente: paciente,
          onSalvar: (p) => p,
        ),
      ),
    );

    if (pacienteSalvo != null) {
      setState(() {}); // Força rebuild do FutureBuilder
      bool sucesso;
      if (paciente == null) {
        sucesso = await _controle.incluir(pacienteSalvo);
      } else {
        sucesso = await _controle.alterar(pacienteSalvo);
      }
      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Operação realizada com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _confirmarExclusao(Paciente paciente) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar exclusão'),
        content: Text('Tem certeza que deseja excluir ${paciente.nome}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              bool sucesso = await _controle.excluir(paciente.id);
              if (sucesso) {
                setState(() {}); //
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Paciente excluído')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao excluir'), backgroundColor: Colors.red),
                );
              }
            },
            child: Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}