import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/paciente.dart';

class PacienteFormScreen extends StatefulWidget {
  final Paciente? paciente;
  final Function(Paciente) onSalvar;

  PacienteFormScreen({this.paciente, required this.onSalvar});

  @override
  _PacienteFormScreenState createState() => _PacienteFormScreenState();
}

class _PacienteFormScreenState extends State<PacienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _nome;
  late int _idade;
  late String _diagnostico;
  late String _telefone;
  late String _dataInternacao;
  late String _gravidade;

  // Controllers para manipular os textos
  late TextEditingController _telefoneController;
  late TextEditingController _dataController;

  final List<String> _gravidades = ['Leve', 'Moderado', 'Grave'];

  @override
  void initState() {
    super.initState();
    if (widget.paciente != null) {
      _nome = widget.paciente!.nome;
      _idade = widget.paciente!.idade;
      _diagnostico = widget.paciente!.diagnostico;
      _telefone = widget.paciente!.telefone;
      _dataInternacao = widget.paciente!.dataInternacao;
      _gravidade = widget.paciente!.gravidade;
    } else {
      _nome = '';
      _idade = 0;
      _diagnostico = '';
      _telefone = '';
      _dataInternacao = '';
      _gravidade = 'Leve';
    }
    _telefoneController = TextEditingController(text: _telefone);
    _dataController = TextEditingController(text: _dataInternacao);

    // Adiciona listeners para formatar enquanto digita
    _telefoneController.addListener(_formatarTelefone);
    _dataController.addListener(_formatarData);
  }

  @override
  void dispose() {
    _telefoneController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  void _formatarTelefone() {
    String texto = _telefoneController.text;
    // Remove tudo que não for número1
    String numeros = texto.replaceAll(RegExp(r'[^0-9]'), '');

    if (numeros.length > 11) numeros = numeros.substring(0, 11);

    String formatado = '';
    if (numeros.length <= 7) {
      formatado = numeros;
    } else if (numeros.length <= 9) {
      formatado = '${numeros.substring(0, 4)}-${numeros.substring(4)}';
    } else if (numeros.length <= 10) {
      formatado = '(${numeros.substring(0, 2)}) ${numeros.substring(2, 6)}-${numeros.substring(6)}';
    } else {
      formatado = '(${numeros.substring(0, 2)}) ${numeros.substring(2, 7)}-${numeros.substring(7, 11)}';
    }

    if (_telefoneController.text != formatado) {
      _telefoneController.value = TextEditingValue(
        text: formatado,
        selection: TextSelection.collapsed(offset: formatado.length),
      );
    }
    _telefone = formatado;
  }

  void _formatarData() {
    String texto = _dataController.text;
    // Remove tudo que não for número
    String numeros = texto.replaceAll(RegExp(r'[^0-9]'), '');

    if (numeros.length > 8) numeros = numeros.substring(0, 8);

    String formatado = '';
    if (numeros.length <= 2) {
      formatado = numeros;
    } else if (numeros.length <= 4) {
      formatado = '${numeros.substring(0, 2)}/${numeros.substring(2)}';
    } else {
      formatado = '${numeros.substring(0, 2)}/${numeros.substring(2, 4)}/${numeros.substring(4)}';
    }

    if (_dataController.text != formatado) {
      _dataController.value = TextEditingValue(
        text: formatado,
        selection: TextSelection.collapsed(offset: formatado.length),
      );
    }
    _dataInternacao = formatado;
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final paciente = Paciente(
        id: widget.paciente?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        nome: _nome,
        idade: _idade,
        diagnostico: _diagnostico,
        telefone: _telefone,
        dataInternacao: _dataInternacao,
        gravidade: _gravidade,
      );

      widget.onSalvar(paciente);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.paciente == null ? 'Incluir Paciente' : 'Editar Paciente'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                initialValue: _nome,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o nome';
                  return null;
                },
                onSaved: (value) => _nome = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Idade',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.cake),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                initialValue: _idade == 0 ? '' : _idade.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe a idade';
                  if (int.tryParse(value) == null) return 'Idade inválida';
                  return null;
                },
                onSaved: (value) => _idade = int.parse(value!),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Diagnóstico',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.medical_services),
                ),
                initialValue: _diagnostico,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o diagnóstico';
                  return null;
                },
                onSaved: (value) => _diagnostico = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(
                  labelText: 'Telefone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                  hintText: '(11) 99999-9999',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o telefone';
                  String numeros = value.replaceAll(RegExp(r'[^0-9]'), '');
                  if (numeros.length < 8) return 'Mínimo 8 dígitos';
                  return null;
                },
                onSaved: (value) => _telefone = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _dataController,
                decoration: InputDecoration(
                  labelText: 'Data de Internação',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                  hintText: 'DD/MM/AAAA',
                ),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe a data';
                  String numeros = value.replaceAll(RegExp(r'[^0-9]'), '');
                  if (numeros.length < 8) return 'Mínimo 8 números (DDMMAAAA)';
                  return null;
                },
                onSaved: (value) => _dataInternacao = value!,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Gravidade',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.warning),
                ),
                value: _gravidade,
                items: _gravidades.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (value) => setState(() => _gravidade = value!),
                validator: (value) => value == null ? 'Selecione a gravidade' : null,
                onSaved: (value) => _gravidade = value!,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _salvar,
                child: Text(
                  widget.paciente == null ? 'INCLUIR' : 'SALVAR ALTERAÇÕES',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}