import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:http/http.dart' as http;

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

class GoogleCalendarDatasource {
  final _googleSignIn = GoogleSignIn(
    scopes: [calendar.CalendarApi.calendarReadonlyScope],
  );

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

    final events = await calendarApi.events.list(
      'primary',
      timeMin: startOfDay.toUtc(),
      timeMax: endOfDay.toUtc(),
      singleEvents: true,
      orderBy: 'startTime',
    );

    return events.items ?? [];
  } catch (e) {
    return [];
  }
}

Future<bool> signIn() async {
  final account = await _googleSignIn.signIn();
  return account != null;
}
}