import 'package:flutter_test/flutter_test.dart';
import 'package:tabrez_portfolio/presentation/widgets/experience_section.dart';

void main() {
  test('durations count both start and end months', () {
    expect(formatDuration('July 2025 – Dec 2025'), '6 months');
    expect(formatDuration('Jul 2022 – Jun 2025'), '3 years');
    expect(formatDuration('Jan 2022 – Jun 2022'), '6 months');
    expect(formatDuration('Jan 2024 – Jan 2024'), '1 month');
    expect(formatDuration('Jan 2023 – Jan 2024'), '1 year, 1 month');
    expect(formatDuration('not a range'), isNull);
  });
}
