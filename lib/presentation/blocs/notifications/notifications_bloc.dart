import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_app/firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

// Colocamos esta funcion de Top Level Function ya que va a manejar rapidamente las notificaciones cuando la app esta en segundo plano o cerrada
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationsBloc() : super(const NotificationsState()) {
    on<NotificationsStatusChanged>(_notificationStatusChanged);

    // Verificar el estado de las notificaciones al iniciar la aplicacion
    _initialStatusCheck();

    // Listener para notificaciones en primer plano
    _onForegroundMessage();
  }

  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(NotificationsStatusChanged(settings.authorizationStatus));
  }

  // Get the Firebase Coud Messaging Token (FCM)
  void _getFCMToken() async {
    if (state.status != AuthorizationStatus.authorized) return;
    String? token = await messaging.getToken();
    print("TOKEN -------> $token");
  }

  void _notificationStatusChanged(
    NotificationsStatusChanged event,
    Emitter<NotificationsState> emit,
  ) {
    emit(state.copyWith(status: event.status));
    _getFCMToken();
  }

  void requestPremission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    add(NotificationsStatusChanged(settings.authorizationStatus));
  }

  void _handleRemoteMessage(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification == null) return;

    print('Message also contained a notification: ${message.notification}');
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
  }
}
