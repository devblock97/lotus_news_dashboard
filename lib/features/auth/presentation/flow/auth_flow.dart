import 'package:lotus_news_web/features/auth/domain/usecases/login_usecase.dart';
import 'package:lotus_news_web/features/auth/presentation/flow/auth_event.dart';
import 'package:lotus_news_web/features/auth/presentation/flow/auth_state.dart';
import 'package:rxdart/rxdart.dart';

class AuthFlow {
  final LoginUseCase loginUseCase;

  // Use BehaviorSubject for state so new subscribers get the latest state immediately
  final _stateController = BehaviorSubject<AuthState>.seeded(AuthInitialize());
  Stream<AuthState> get state => _stateController.stream;

  // Use PublishSubject for events (Intents)
  final _eventController = PublishSubject<AuthEvent>();
  Sink<AuthEvent> get eventSink => _eventController.sink;

  AuthFlow({required this.loginUseCase}) {
    _eventController.listen(_mapEventToState);
  }

  void _mapEventToState(AuthEvent event) async {
    if (event is LoginEvent) {
      await _onLogin(email: event.email, password: event.password);
    } else if (event is CurrentStateEvent) {
      await _onCurrentAuthState();
    }
  }

  Future<void> _onCurrentAuthState() async {}

  Future<void> _onLogin({
    required String email,
    required String password,
  }) async {
    _stateController.add(LoginLoading());
    try {
      final login = await loginUseCase(email, password);
      _stateController.add(LoginSuccess(data: login));
      _stateController.add(Authenticated());
    } catch (e) {
      _stateController.add(LoginError(message: e.toString()));
      throw Exception(e.toString());
    }
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}
