import 'package:googleapis/calendar/v3.dart' as calendar;

abstract class ICalendarRepository {
  Future<List<calendar.Event>> getEventsToday();
}
