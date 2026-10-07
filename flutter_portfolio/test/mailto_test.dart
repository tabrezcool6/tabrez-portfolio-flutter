import 'package:flutter_test/flutter_test.dart';
import 'package:tabrez_portfolio/presentation/widgets/contact_section.dart';

void main() {
  test('mailto link carries every form field', () {
    final link = buildMailtoLink(
      name: ' Jane Doe ',
      email: 'jane@example.com',
      projectType: 'Architecture & State Audit',
      message: 'Hi Tabrez,\nLet\'s talk & plan.',
    );
    final uri = Uri.parse(link);
    expect(uri.scheme, 'mailto');
    expect(uri.path, 'dev.tabrez6@gmail.com');
    expect(uri.queryParameters['subject'], 'Portfolio Inquiry: Architecture & BLoC/Clean Arch Audit — Jane Doe');
    expect(uri.queryParameters['body'],
        'Name: Jane Doe\nEmail: jane@example.com\nProject / Inquiry Scope: Architecture & BLoC/Clean Arch Audit\n\nMessage:\nHi Tabrez,\nLet\'s talk & plan.');
    expect(link, isNot(contains('+')));
    // ignore: avoid_print
    print('DART $link');
  });
}
