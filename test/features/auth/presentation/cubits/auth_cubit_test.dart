import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:maya_e_wallet/features/auth/domain/entities/user.dart';
import 'package:maya_e_wallet/features/auth/domain/usecases/login_usecase.dart';
import 'package:maya_e_wallet/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:maya_e_wallet/features/auth/presentation/cubits/auth_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late AuthCubit authCubit;
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    authCubit = AuthCubit(loginUseCase: mockLoginUseCase);
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit', () {
    test('initial state is AuthInitial', () {
      expect(authCubit.state, isA<AuthInitial>());
    });

    const testUsername = 'test123';
    const testPassword = 'test123';
    const testUser = User(username: testUsername);

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthSuccess] when login is successful',
      build: () {
        when(
          () => mockLoginUseCase(testUsername, testPassword),
        ).thenAnswer((_) async => testUser);
        return authCubit;
      },
      act: (cubit) => cubit.login(testUsername, testPassword),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>()
            .having((state) => state.user, 'user', equals(testUser)),
      ],
      verify: (_) {
        verify(
          () => mockLoginUseCase(testUsername, testPassword),
        ).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthFailure] when login fails',
      build: () {
        when(
          () => mockLoginUseCase(testUsername, 'wrongPassword'),
        ).thenThrow(Exception('Invalid credentials'));
        return authCubit;
      },
      act: (cubit) => cubit.login(testUsername, 'wrongPassword'),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthFailure>().having(
          (state) => state.message,
          'message',
          contains('Invalid credentials'),
        ),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthFailure] when exception occurs',
      build: () {
        when(
          () => mockLoginUseCase('wrongUser', testPassword),
        ).thenThrow(Exception('User not found'));
        return authCubit;
      },
      act: (cubit) => cubit.login('wrongUser', testPassword),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthFailure>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits AuthInitial when logout is called',
      build: () => authCubit,
      seed: () => const AuthSuccess(user: testUser),
      act: (cubit) => cubit.logout(),
      expect: () => [
        isA<AuthInitial>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'logout clears user data',
      build: () => authCubit,
      seed: () => const AuthSuccess(user: testUser),
      act: (cubit) => cubit.logout(),
      expect: () => [
        isA<AuthInitial>(),
      ],
      verify: (_) {
        expect(authCubit.state, isA<AuthInitial>());
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits AuthFailure with message when login fails with custom message',
      build: () {
        when(
          () => mockLoginUseCase(testUsername, testPassword),
        ).thenThrow(Exception('Network error'));
        return authCubit;
      },
      act: (cubit) => cubit.login(testUsername, testPassword),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthFailure>().having(
          (state) => state.message,
          'message',
          isNotEmpty,
        ),
      ],
    );
  });
}
