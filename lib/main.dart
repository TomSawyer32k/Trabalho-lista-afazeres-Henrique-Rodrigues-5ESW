import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const MeuApp());
}

class MeuHomePage extends StatefulWidget {
  const MeuHomePage({Key? key}) : super(key: key);

  @override
  State<MeuHomePage> createState() => _MeuHomePageState();
}

class _MeuHomePageState extends State<MeuHomePage> {
  final List<Tarefa> _tarefas = [];
  final TextEditingController _controlador = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Afazeres'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                child: _tarefas.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _tarefas.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            elevation: 3,
                            child: ListTile(
                              title: Text(
                                _tarefas[index].descricao,
                                style: TextStyle(
                                  decoration: _tarefas[index].status
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              leading: Checkbox(
                                value: _tarefas[index].status,
                                onChanged: (novoValor) {
                                  setState(() {
                                    _tarefas[index].status = novoValor ?? false;
                                  });
                                },
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.green),
                                    tooltip: 'Editar tarefa',
                                    onPressed: () {
                                      _editarTarefa(index);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    tooltip: 'Excluir tarefa',
                                    onPressed: () {
                                      _confirmarExclusaoTarefa(index);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'Nenhuma tarefa adicionada.',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controlador,
                        decoration: const InputDecoration(
                          hintText: 'Descrição da tarefa',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(140, 60),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        _adicionarTarefa();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Adicionar'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _adicionarTarefa() {
    if (_controlador.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A descrição da tarefa não pode estar vazia!'),
        ),
      );
      return;
    }

    setState(() {
      _tarefas.add(Tarefa(descricao: _controlador.text, status: false));
      _controlador.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tarefa adicionada com sucesso!')),
    );
  }

  void _editarTarefa(int index) {
    final TextEditingController editControlador =
        TextEditingController(text: _tarefas[index].descricao);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Tarefa'),
          content: TextField(
            controller: editControlador,
            decoration: const InputDecoration(
              hintText: 'Nova descrição',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tarefas[index].descricao = editControlador.text;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tarefa editada com sucesso!')),
                );
              },
              child: const Text('Salvar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _confirmarExclusaoTarefa(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza que deseja excluir esta tarefa?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tarefas.removeAt(index);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tarefa excluída com sucesso!')),
                );
              },
              child: const Text('Excluir'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}

class Tarefa {
  String descricao;
  bool status;

  Tarefa({required this.descricao, required this.status});
}
