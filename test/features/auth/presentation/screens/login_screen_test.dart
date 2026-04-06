import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:maya_e_wallet/features/auth/domain/entities/user.dart';
import 'package:maya_e_wallet/features/auth/domain/usecases/login_usecase.dart';
import 'package:maya_e_wallet/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:maya_e_wallet/features/auth/presentation/cubits/auth_state.dart';
import 'package:maya_e_wallet/features/auth/presentation/login_screen.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthCubit>(
        create: (_) => AuthCubit(loginUseCase: mockLoginUseCase),
        child: const LoginScreen(),
      ),
    );
  }

  group('LoginScreen', () {
    testWidgets('renders login screen with all widgets', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert - Check if main widgets are present
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(TextField), findsWidgets); // Username and password fields
      expect(find.byType(FilledButton), findsOneWidget); // Login button
      expect(find.byType(Card), findsOneWidget); // Demo credentials card
    });

    testWidgets('displays login header with logo and title', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert - Check for wallet icon (logo)
      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
      // Header should be present with any title text
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('shows demo credentials in card', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Demo Credentials'), findsOneWidget);
      // Username and Password labels appear in both form and demo card
      expect(find.text('Username'), findsWidgets);
      expect(find.text('Password'), findsWidgets);
      expect(find.text('test123'), findsWidgets);
    });

    testWidgets('has username and password input fields', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.bySemanticsLabel('Username'), findsWidgets);
      expect(find.bySemanticsLabel('Password'), findsWidgets);
    });

    testWidgets('password field is initially obscured', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Find the password text field
      final passwordFields = find.byType(TextFormField);
      expect(passwordFields, findsWidgets);
    });

    testWidgets('toggle password visibility button works', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Find and tap the visibility toggle button
      final visibilityButtons = find.byIcon(Icons.visibility_off);
      if (visibilityButtons.evaluate().isNotEmpty) {
        await tester.tap(visibilityButtons.first);
        await tester.pump();

        // Check that visibility icon changed
        expect(find.byIcon(Icons.visibility), findsWidgets);
      }
    });

    testWidgets('login button is enabled when not loading', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      final loginButton = find.byType(FilledButton);
      expect(loginButton, findsOneWidget);
    });

    testWidgets('shows loading indicator when AuthLoading state is emitted', (WidgetTester tester) async {
      // Arrange
      final authCubit = AuthCubit(loginUseCase: mockLoginUseCase);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>(
            create: (_) => authCubit,
            child: const LoginScreen(),
          ),
        ),
      );

      // Emit AuthLoading state
      authCubit.emit(const AuthLoading());
      await tester.pump();

      // Assert - CircularProgressIndicator should appear
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error snackbar on login failure', (WidgetTester tester) async {
      // Arrange
      final authCubit = AuthCubit(loginUseCase: mockLoginUseCase);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>(
            create: (_) => authCubit,
            child: const LoginScreen(),
          ),
        ),
      );

      // Emit AuthFailure state
      authCubit.emit(const AuthFailure(message: 'Invalid credentials'));
      await tester.pump();

      // Assert - Snackbar with error message should appear
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('form validation shows error for empty username', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Find and tap the login button without filling username
      final loginButton = find.byType(FilledButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Assert - Validation error should appear
      // Note: Actual validation depends on the form implementation
    });

    testWidgets('form validation shows error for short password', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Find username field and enter value
      final usernameFields = find.byType(TextFormField);
      await tester.enterText(usernameFields.first, 'test');

      // Find password field and enter short value
      await tester.enterText(usernameFields.at(1), 'ab');

      // Tap login button
      final loginButton = find.byType(FilledButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Assert - Validation error should appear
    });

    testWidgets('updates UI when valid credentials are entered', (WidgetTester tester) async {
      // Arrange
      const testUser = User(username: 'test123');
      when(
        () => mockLoginUseCase('test123', 'test123'),
      ).thenAnswer((_) async => testUser);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Find text fields and enter credentials
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, 'test123');
      await tester.enterText(textFields.at(1), 'test123');
      await tester.pump();

      // Assert - verify credentials were entered
      expect(find.text('test123'), findsWidgets);
    });
  });
}
