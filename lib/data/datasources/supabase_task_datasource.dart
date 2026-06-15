import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:estudos_app/domain/entities/task.dart' as domain;

class SupabaseTaskDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> insertTask(domain.Task task) async {
    await _client.from('tasks').insert({
      'title': task.title,
      'description': task.description,
      'due_date': task.dueDate?.toIso8601String(),
      'is_completed': task.isCompleted,
      'priority': task.priority,
      'axis_id': task.axisId,
    });
  }

  Future<void> completeTask(int id) async {
    await _client
        .from('tasks')
        .update({'is_completed': true})
        .eq('id', id);
  }

  Future<void> deleteTask(int id) async {
    await _client.from('tasks').delete().eq('id', id);
  }
}