import 'package:flutter/material.dart';

import '../model/task.dart';
import '../repository/task_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskRepository repository = TaskRepository();

  final TextEditingController controller =
      TextEditingController();

  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    tasks = await repository.getAll();

    setState(() {});
  }

  Future<void> addTask() async {
    if (controller.text.isEmpty) return;

    await repository.create(
      Task(
        task: controller.text,
        done: 0,
        created: DateTime.now().toString(),
      ),
    );

    controller.clear();

    loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await repository.delete(id);

    loadTasks();
  }

  Future<void> toggleTask(Task task) async {
    task.done = task.done == 1 ? 0 : 1;

    await repository.update(task);

    loadTasks();
  }

  Future<void> editTask(Task task) async {
    TextEditingController editController =
        TextEditingController(text: task.task);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar tarefa'),
        content: TextField(
          controller: editController,
        ),
        actions: [
          TextButton(
            onPressed: () async {
  task.task = editController.text;

  await repository.update(task);

  if (!mounted) return;

  Navigator.pop(context);

  loadTasks();
},
            child: const Text('Salvar'),
          )
        ],
      ),
    );
  }

  Future<void> searchById() async {
    TextEditingController idController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Buscar por ID"),
        content: TextField(
          controller: idController,
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final task = await repository.getById(
                int.parse(idController.text),
              );

              Navigator.pop(context);

              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Resultado"),
                  content: Text(
                    task != null
                        ? "ID: ${task.id}\nTarefa: ${task.task}"
                        : "Não encontrada",
                  ),
                ),
              );
            },
            child: const Text("Buscar"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Tarefas"),
        actions: [
          IconButton(
            onPressed: searchById,
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Nova tarefa",
                    ),
                  ),
                ),
                IconButton(
                  onPressed: addTask,
                  icon: const Icon(Icons.add),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (_, index) {
                final task = tasks[index];

                return ListTile(
                  title: Text(
                    task.task,
                    style: TextStyle(
                      decoration: task.done == 1
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  leading: Checkbox(
                    value: task.done == 1,
                    onChanged: (_) => toggleTask(task),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => editTask(task),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            deleteTask(task.id!),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}