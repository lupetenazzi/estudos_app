import 'package:googleapis/calendar/v3.dart' as calendar;
import "../../data/datasources/google_calendar_datasource.dart";

class GetTodayEvents {
  final GoogleCalendarDatasource datasource;

  GetTodayEvents(this.datasource);

  Future<List<calendar.Event>> call() async {
    return await datasource.getEventsToday();
  }
}