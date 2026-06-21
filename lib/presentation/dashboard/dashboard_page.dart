import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:estudos_app/domain/entities/task.dart' as domain;
import 'dashboard_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia';
    if (hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  String _formatDate() {
    final now = DateTime.now();
    final weekdays = ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'];
    final months = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez'];
    return '${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';
  }

  void _shareResume(BuildContext context, WidgetRef ref) async {
  final tasksAsync = ref.read(todayTasksProvider);
  final focusMinutes = await ref.read(todayFocusMinutesProvider.future);

  tasksAsync.whenData((tasks) {
    final completed = tasks.where((t) => t.isCompleted).toList();
    final text = StringBuffer();
    text.writeln('📚 Resumo do dia — ${_formatDate()}');
    text.writeln('');
    text.writeln('✅ Tarefas concluídas: ${completed.length}/${tasks.length}');
    if (completed.isNotEmpty) {
      for (final task in completed) {
        text.writeln('  • ${task.title}');
      }
    }
    text.writeln('');
    text.writeln('⏱️ Minutos de foco: $focusMinutes min');
    Share.share(text.toString());
  });
}


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayTasksAsync = ref.watch(todayTasksProvider);
    final todayEventsAsync = ref.watch(todayEventsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(todayEventsProvider);
            ref.invalidate(todayTasksProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  _formatDate(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_getGreeting()} 👋',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 28),

                // Tarefas de hoje
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tarefas de hoje',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 12),
                todayTasksAsync.when(
                  loading: () => const Center(
                      child: CircularProgressIndicator()),
                  error: (e, _) => const Text('Erro ao carregar tarefas'),
                  data: (tasks) => tasks.isEmpty
                      ? _EmptyState(message: 'Nenhuma tarefa para hoje!')
                      : Column(
                          children: tasks
                              .map((task) => _TaskCard(task: task))
                              .toList(),
                        ),
                ),
                const SizedBox(height: 28),

                // Agenda de hoje
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Agenda de hoje',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    GestureDetector(
                      onTap: () => ref.invalidate(todayEventsProvider),
                      child: Icon(
                        Icons.refresh_rounded,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                todayEventsAsync.when(
                  loading: () => const Center(
                      child: CircularProgressIndicator()),
                  error: (e, _) =>
                      const Text('Erro ao carregar agenda'),
                  data: (events) => events.isEmpty
                      ? _EmptyState(message: 'Nenhum evento hoje!')
                      : Column(
                          children: events.map((event) {
                            final start = event.start?.dateTime?.toLocal();
                            final time = start != null
                                ? '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}'
                                : '';
                            return _EventCard(
                              title: event.summary ?? 'Sem título',
                              time: time,
                            );
                          }).toList(),
                        ),
                ),
                const SizedBox(height: 28),

                // Botão compartilhar
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () => _shareResume(context, ref),
                    icon: const Icon(Icons.share_outlined, size: 18),
                    label: const Text('Compartilhar resumo do dia'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final domain.Task task;
  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final priorityColors = [
      Colors.red.shade400,
      Colors.amber.shade400,
      Colors.green.shade400,
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            task.isCompleted
                ? Icons.check_circle
                : Icons.circle_outlined,
            size: 20,
            color: task.isCompleted
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade400,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: task.isCompleted ? Colors.grey : null,
                  ),
                ),
              ],
            ),
          ),
          if (!task.isCompleted)
            CircleAvatar(
              radius: 4,
              backgroundColor: priorityColors[task.priority.clamp(0, 2)],
            ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final String title;
  final String time;

  const _EventCard({required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Text(
              time,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 13,
        ),
      ),
    );
  }
}