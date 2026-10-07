import React, { useState } from 'react';
import { Copy, Check, FileCode } from 'lucide-react';

interface CodeSnippet {
  id: string;
  name: string;
  label: string;
  language: string;
  description: string;
  code: string;
}

const SNIPPETS: CodeSnippet[] = [
  {
    id: 'bloc',
    name: 'auth_bloc.dart',
    label: 'BLoC State Engine',
    language: 'dart',
    description: 'Event-driven unidirectional state stream with zero mutation and fail-safe recovery.',
    code: `import 'package:flutter_bloc/flutter_bloc.dart';
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
}`,
  },
  {
    id: 'repo',
    name: 'task_repository.dart',
    label: 'Offline Hive Repo',
    language: 'dart',
    description: 'Sub-millisecond local binary storage read/write with Clean Architecture domain boundaries.',
    code: `import 'package:hive/hive.dart';
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
      return Left(CacheFailure('Unable to read binary box: \$e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveTask(TaskEntity task) async {
    try {
      await _taskBox.put(task.id, TaskModel.fromEntity(task));
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Hive write failed: \$e'));
    }
  }
}`,
  },
  {
    id: 'test',
    name: 'counter_widget_test.dart',
    label: 'Automated Widget Test',
    language: 'dart',
    description: 'Isolated UI verification using testWidgets and widget tester pumps (from Medium article).',
    code: `import 'package:flutter/material.dart';
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
}`,
  },
];

export const CodeInspector: React.FC = () => {
  const [activeSnippetId, setActiveSnippetId] = useState('bloc');
  const [copied, setCopied] = useState(false);

  const activeSnippet = SNIPPETS.find((s) => s.id === activeSnippetId) || SNIPPETS[0];

  const handleCopy = () => {
    navigator.clipboard.writeText(activeSnippet.code);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <section id="architecture" className="py-20 sm:py-28 relative">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        
        {/* Section Header */}
        <div className="max-w-3xl space-y-3">
          <p className="text-xs font-mono uppercase tracking-widest text-blue-400">
            Source Code Inspection
          </p>
          <h2 className="text-3xl sm:text-5xl font-bold tracking-tight text-white leading-tight text-balance">
            The Engine Under the Hood. <br />
            <span className="text-neutral-400">Clean, typed, and testable.</span>
          </h2>
          <p className="text-sm sm:text-base text-neutral-400 leading-relaxed text-balance">
            Inspect real production-grade Dart patterns used in Syed's daily engineering workflow at Rokkun.
          </p>
        </div>

        {/* macOS Window Shell */}
        <div className="rounded-3xl bg-[#0d0d0f] border border-white/10 shadow-2xl overflow-hidden">
          
          {/* macOS Top Bar */}
          <div className="px-5 py-3.5 bg-[#161618] border-b border-white/10 flex flex-wrap items-center justify-between gap-4">
            
            {/* macOS Window Dots */}
            <div className="flex items-center gap-2">
              <span className="w-3 h-3 rounded-full bg-[#ff5f56] inline-block border border-[#e0443e]"></span>
              <span className="w-3 h-3 rounded-full bg-[#ffbd2e] inline-block border border-[#dea123]"></span>
              <span className="w-3 h-3 rounded-full bg-[#27c93f] inline-block border border-[#1aab29]"></span>
              <span className="text-xs font-mono text-neutral-400 ml-2 hidden sm:inline">
                Tabrez-MacBook-Pro · Dart SDK 3.x
              </span>
            </div>

            {/* Snippet Tabs */}
            <div className="flex items-center gap-1 bg-black/60 p-1 rounded-xl border border-white/5">
              {SNIPPETS.map((snippet) => (
                <button
                  key={snippet.id}
                  type="button"
                  onClick={() => setActiveSnippetId(snippet.id)}
                  className={`px-3 py-1.5 text-xs font-medium rounded-lg transition-all cursor-pointer whitespace-nowrap ${
                    activeSnippetId === snippet.id
                      ? 'bg-neutral-800 text-white shadow-sm'
                      : 'text-neutral-400 hover:text-white'
                  }`}
                >
                  {snippet.label}
                </button>
              ))}
            </div>

            {/* Copy Button */}
            <button
              type="button"
              onClick={handleCopy}
              className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-white/5 hover:bg-white/10 text-xs font-medium text-neutral-300 hover:text-white transition-colors cursor-pointer border border-white/10"
            >
              {copied ? <Check className="w-3.5 h-3.5 text-emerald-400" /> : <Copy className="w-3.5 h-3.5" />}
              <span>{copied ? 'Copied' : 'Copy'}</span>
            </button>
          </div>

          {/* Snippet Description Bar */}
          <div className="px-6 py-3 bg-[#111113] border-b border-white/5 flex items-center justify-between text-xs text-neutral-400">
            <div className="flex items-center gap-2">
              <FileCode className="w-4 h-4 text-blue-400" />
              <span className="font-mono text-neutral-200">{activeSnippet.name}</span>
              <span aria-hidden="true">·</span>
              <span className="text-neutral-400 hidden sm:inline">{activeSnippet.description}</span>
            </div>
            <span className="font-mono text-[11px] text-emerald-400">Null Safety Verified</span>
          </div>

          {/* Code Viewer Area */}
          <div className="p-4 sm:p-6 overflow-x-auto text-xs sm:text-sm font-mono leading-relaxed bg-[#0a0a0c]">
            <pre className="text-neutral-300">
              <code>{activeSnippet.code}</code>
            </pre>
          </div>
        </div>

      </div>
    </section>
  );
};
