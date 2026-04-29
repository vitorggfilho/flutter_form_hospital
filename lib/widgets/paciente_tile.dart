import 'package:flutter/material.dart';
import '../models/paciente.dart';

class PacienteTile extends StatelessWidget {
  final Paciente paciente;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;

  PacienteTile({
    required this.paciente,
    required this.onEditar,
    required this.onExcluir,
  });

  Color _getGravidadeColor() {
    switch (paciente.gravidade) {
      case 'Leve':
        return Colors.green;
      case 'Moderado':
        return Colors.orange;
      case 'Grave':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: _getGravidadeColor(),
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          paciente.nome,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text('Idade: ${paciente.idade} anos'),
            Text('Diagnóstico: ${paciente.diagnostico}'),
            Text('Telefone: ${paciente.telefone}'),
            Text('Internação: ${paciente.dataInternacao}'),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getGravidadeColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Gravidade: ${paciente.gravidade}',
                    style: TextStyle(
                      color: _getGravidadeColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.greenAccent),
              onPressed: onEditar,
              tooltip: 'Editar',
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onExcluir,
              tooltip: 'Excluir',
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}