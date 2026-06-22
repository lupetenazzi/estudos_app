import 'package:googleapis/calendar/v3.dart' as calendar;
import '../repositories/i_calendar_repository.dart';

class GetTodayEvents {
  final ICalendarRepository repository;

  GetTodayEvents(this.repository);

  Future<List<calendar.Event>> call() async {
    return await repository.getEventsToday();
  }
}