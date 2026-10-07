import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/apple_theme.dart';
import 'common.dart';

class _Snippet {
  final String id;
  final String name;
  final String label;
  final String description;
  final String code;
  const _Snippet(this.id, this.name, this.label, this.description, this.code);
}

const _snippets = [
  _Snippet(
    'bloc',
    'auth_bloc.dart',
    'BLoC State Engine',
    'Event-driven unidirectional state stream with zero mutation and fail-safe recovery.',
    r"""import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  const LoginRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

// BLoC Implementation
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticateUserUseCase _authenticateUser;

  AuthBloc({required AuthenticateUserUseCase authenticateUser})
      : _authenticateUser = authenticateUser,
        super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authenticateUser(
      UserCredentials(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }
}""",
  ),
  _Snippet(
    'repo',
    'task_repository.dart',
    'Offline Hive Repo',
    'Sub-millisecond local binary storage read/write with Clean Architecture domain boundaries.',
    r"""import 'package:hive/hive.dart';
import 'package:dartz/dartz.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<TaskEntity>>> getActiveTasks();
  Future<Either<Failure, void>> saveTask(TaskEntity task);
}

class TaskRepositoryImpl implements TaskRepository {
  final Box<TaskModel> _taskBox;

  TaskRepositoryImpl(this._taskBox);

  @override
  Future<Either<Failure, List<TaskEntity>>> getActiveTasks() async {
    try {
      final tasks = _taskBox.values
          .where((t) => !t.isCompleted)
          .map((m) => m.toEntity())
          .toList();
      return Right(tasks);
    } catch (e) {
      return Left(CacheFailure('Unable to read binary box: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveTask(TaskEntity task) async {
    try {
      await _taskBox.put(task.id, TaskModel.fromEntity(task));
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Hive write failed: $e'));
    }
  }
}""",
  ),
  _Snippet(
    'test',
    'counter_widget_test.dart',
    'Automated Widget Test',
    'Isolated UI verification using testWidgets and widget tester pumps (from Medium article).',
    r"""import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rokkun_app/features/counter/presentation/counter_view.dart';

void main() {
  group('CounterView Widget Tests', () {
    testWidgets('Initial count displays 0', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: CounterView()),
      );

      // Verify counter starts at 0
      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);
    });

    testWidgets('Tapping increment button updates count to 1',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: CounterView()),
      );

      // Find and tap the floating action button
      final fab = find.byKey(const Key('counter_increment_btn'));
      await tester.tap(fab);
      await tester.pump();

      // Assert verified increment
      expect(find.text('1'), findsOneWidget);
    });
  });
}""",
  ),
];

/// macOS-style code inspector (src/components/CodeInspector.tsx).
class CodeInspectorSection extends StatefulWidget {
  const CodeInspectorSection({super.key});

  @override
  State<CodeInspectorSection> createState() => _CodeInspectorSectionState();
}

class _CodeInspectorSectionState extends State<CodeInspectorSection> {
  String _activeId = 'bloc';
  bool _copied = false;
  Timer? _timer;

  _Snippet get _active => _snippets.firstWhere((s) => s.id == _activeId, orElse: () => _snippets.first);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _copy() {
    Clipboard.setData(ClipboardData(text: _active.code));
    setState(() => _copied = true);
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 2), () => mounted ? setState(() => _copied = false) : null);
  }

  @override
  Widget build(BuildContext context) {
    final bp = Bp.of(context);

    return Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 48,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: SectionHeader(
              kicker: 'Source Code Inspection',
              title: 'The Engine Under the Hood.',
              subtitle: 'Clean, typed, and testable.',
              body: "Inspect real production-grade Dart patterns used in Syed's daily engineering workflow at Rokkun.",
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D0F),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Tw.w(0.1)),
              boxShadow: TwShadow.xl2,
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _topBar(bp),
                _descriptionBar(bp),
                Container(
                  color: const Color(0xFF0A0A0C),
                  padding: EdgeInsets.all(bp.v(16.0, sm: 24.0)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      _active.code,
                      softWrap: false,
                      style: tw(bp.v(TwSize.xs, sm: TwSize.sm),
                          mono: true, color: Tw.neutral300, leading: Leading.relaxed),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(Bp bp) {
    Widget light(Color fill, Color border) => Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: fill, shape: BoxShape.circle, border: Border.all(color: border)),
        );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF161618),
        border: Border(bottom: BorderSide(color: Tw.w(0.1))),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 16,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              light(const Color(0xFFFF5F56), const Color(0xFFE0443E)),
              light(const Color(0xFFFFBD2E), const Color(0xFFDEA123)),
              light(const Color(0xFF27C93F), const Color(0xFF1AAB29)),
              if (bp.sm)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text('Tabrez-MacBook-Pro · Dart SDK 3.x',
                      style: tw(TwSize.xs, mono: true, color: Tw.neutral400)),
                ),
            ],
          ),
          // Snippet tabs (scroll horizontally on very narrow screens)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Tw.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Tw.w(0.05)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  for (final s in _snippets)
                    Hover(
                      onTap: () => setState(() => _activeId = s.id),
                      builder: (context, hovered) {
                        final active = s.id == _activeId;
                        return AnimatedContainer(
                          duration: twDuration,
                          curve: twCurve,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: active ? Tw.neutral800 : Tw.neutral800.withValues(alpha: 0),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: active ? TwShadow.sm() : null,
                          ),
                          child: Text(s.label,
                              style: tw(TwSize.xs,
                                  weight: FontWeight.w500,
                                  color: active || hovered ? Tw.white : Tw.neutral400)),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
          Hover(
            onTap: _copy,
            builder: (context, hovered) => AnimatedContainer(
              duration: twDuration,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Tw.w(hovered ? 0.1 : 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Tw.w(0.1)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  _copied
                      ? const Icon(LucideIcons.check, size: 14, color: Tw.emerald400)
                      : Icon(LucideIcons.copy, size: 14, color: hovered ? Tw.white : Tw.neutral300),
                  Text(_copied ? 'Copied' : 'Copy',
                      style: tw(TwSize.xs, weight: FontWeight.w500, color: hovered ? Tw.white : Tw.neutral300)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _descriptionBar(Bp bp) {
    final style = tw(TwSize.xs, color: Tw.neutral400);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF111113),
        border: Border(bottom: BorderSide(color: Tw.w(0.05))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              spacing: 8,
              children: [
                const Icon(LucideIcons.fileCode, size: 16, color: Tw.blue400),
                Text(_active.name, style: tw(TwSize.xs, mono: true, color: Tw.neutral200)),
                Text('·', style: style),
                if (bp.sm) Flexible(child: Text(_active.description, style: style)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text('Null Safety Verified', style: tw(TwSize.px(11), mono: true, color: Tw.emerald400)),
        ],
      ),
    );
  }
}
