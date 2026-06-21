import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:estudos_app/domain/entities/task.dart' as domain;
import 'package:flutter/foundation.dart';


class SupabaseTaskDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> insertTask(domain.Task task) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      debugPrint('Supabase: usuário não autenticado, sync ignorado');
      return;
    }

    await _client.from('tasks').insert({
      'title': task.title,
      'description': task.description,
      'due_date': task.dueDate?.toIso8601String(),
      'is_completed': task.isCompleted,
      'priority': task.priority,
      'axis_id': task.axisId,
      'user_id': userId,
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

  Future<void> updateTask(domain.Task task) async {
    await _client.from('tasks').update({
      'title': task.title,
      'description': task.description,
      'due_date': task.dueDate?.toIso8601String(),
      'priority': task.priority,
    }).eq('id', task.id);
  }

  Future<void> uncompleteTask(int id) async {
    await _client
        .from('tasks')
        .update({'is_completed': false})
        .eq('id', id);
  }
}