import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:estudos_app/domain/entities/task.dart' as domain;
import 'tasks_provider.dart';

class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> {
  String _filter = 'todas';

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(tasksProvider);
    final filter = _filter;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  tasksAsync.when(
                    loading: () => const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tarefas',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w800)),
                        Text('carregando...',
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    error: (_, __) => const Text('Tarefas'),
                    data: (tasks) {
                      final pending =
                          tasks.where((t) => !t.isCompleted).length;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tarefas',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800)),
                          Text('$pending pendentes',
                              style: const TextStyle(fontSize: 12)),
                        ],
                      );
                    },
                  ),
                  FloatingActionButton.small(
                    onPressed: () => _showCreateSheet(context, ref),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),

            // Filtros
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: ['todas', 'pendente', 'concluída'].map((f) {
                  final selected = filter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _filter = f),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          f,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: selected
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Lista
            Expanded(
              child: tasksAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Erro: $e')),
                data: (tasks) {
                  final filtered = tasks.where((t) {
                    if (filter == 'pendente') return !t.isCompleted;
                    if (filter == 'concluída') return t.isCompleted;
                    return true;
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline,
                              size: 48, color: Colors.grey),
                          SizedBox(height: 12),
                          Text('Tudo em dia ✨',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) =>
                        _TaskCard(task: filtered[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateSheet(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    int selectedPriority = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Nova Tarefa',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                autofocus: true,
                decoration: const InputDecoration(
                    hintText: 'Título da tarefa'),
              ),
              const SizedBox(height: 12),
              // Seletor de prioridade
              Row(
                children: [
                  {'label': 'Alta', 'value': 0},
                  {'label': 'Média', 'value': 1},
                  {'label': 'Baixa', 'value': 2},
                ].map((p) {
                  final selected = selectedPriority == p['value'];
                  final colors = [
                    Colors.red.shade400,
                    Colors.amber.shade400,
                    Colors.green.shade400
                  ];
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(
                            () => selectedPriority = p['value'] as int),
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade300,
                            ),
                            color: selected
                                ? Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.08)
                                : Colors.transparent,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                  radius: 4,
                                  backgroundColor:
                                      colors[p['value'] as int]),
                              const SizedBox(width: 6),
                              Text(p['label'] as String,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: selected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isEmpty) return;

                  final task = domain.Task(
                    id: 0,
                    title: titleController.text,
                    isCompleted: false,
                    priority: selectedPriority,
                    axisId: 1,
                    createdAt: DateTime.now(),
                  );

                  await ref.read(createTaskProvider).call(task);
                  ref.invalidate(tasksProvider);

                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Criar tarefa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskCard extends ConsumerWidget {
  final domain.Task task;
  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priorityColors = [
      Colors.red.shade400,
      Colors.amber.shade400,
      Colors.green.shade400,
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: GestureDetector(
          onTap: () async {
            await ref.read(completeTaskProvider).call(task.id);
            ref.invalidate(tasksProvider);
          },
          child: Icon(
            task.isCompleted
                ? Icons.check_circle
                : Icons.circle_outlined,
            color: task.isCompleted
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade400,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: task.isCompleted ? Colors.grey : null,
          ),
        ),
        trailing: task.isCompleted
            ? null
            : CircleAvatar(
                radius: 5,
                backgroundColor: priorityColors[task.priority.clamp(0, 2)],
              ),
      ),
    );
  }
}