import 'package:web/web.dart' as web;

String? readViewFromUrl() => Uri.base.queryParameters['view'];

void persistView(String view) {
  // Update ?view= in place, keeping Flutter's #/ route fragment intact.
  final uri = Uri.base;
  final next = uri.replace(queryParameters: {...uri.queryParameters, 'view': view});
  web.window.history.replaceState(null, '', next.toString());
}
