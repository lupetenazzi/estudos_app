import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:http/http.dart' as http;
import 'package:estudos_app/domain/repositories/i_calendar_repository.dart';

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

class GoogleCalendarDatasource implements ICalendarRepository {
  final _googleSignIn = GoogleSignIn(
    scopes: [calendar.CalendarApi.calendarReadonlyScope],
  );

  @override
  Future<List<calendar.Event>> getEventsToday() async {
  try {
    final account = await _googleSignIn.signInSilently();
    if (account == null) return [];

    final auth = await account.authentication;
    final authHeaders = {
      'Authorization': 'Bearer ${auth.accessToken}',
      'X-Goog-AuthUser': '0',
    };

    final authClient = GoogleAuthClient(authHeaders);
    final calendarApi = calendar.CalendarApi(authClient);

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final calendarList = await calendarApi.calendarList.list();
    final allEvents = <calendar.Event>[];

    for (final cal in calendarList.items ?? []) {
      if (cal.id == null) continue;
      final events = await calendarApi.events.list(
        cal.id!,
        timeMin: startOfDay.toUtc(),
        timeMax: endOfDay.toUtc(),
        singleEvents: true,
        orderBy: 'startTime',
      );
      allEvents.addAll(events.items ?? []);
    }

    allEvents.sort((a, b) {
      final aStart = a.start?.dateTime ?? a.start?.date;
      final bStart = b.start?.dateTime ?? b.start?.date;
      if (aStart == null || bStart == null) return 0;
      return aStart.compareTo(bStart);
    });

    return allEvents;
  } catch (e) {
    return [];
  }
}

Future<bool> signIn() async {
  final account = await GoogleSignIn(
    scopes: [calendar.CalendarApi.calendarReadonlyScope],
  ).signIn();
  return account != null;
}
}