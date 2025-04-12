import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/domain/entities/push_message.dart';
import 'package:push_app/presentation/blocs/blocs.dart';

class DetailsScreen extends StatelessWidget {
  final String pushMessageId;
  const DetailsScreen({super.key, required this.pushMessageId});

  @override
  Widget build(BuildContext context) {
    final PushMessage? pushMessage = context
        .watch<NotificationsBloc>()
        .getNotificationById(pushMessageId);
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles de la notificacion')),
      body:
          pushMessage != null
              ? _DetailsView(pushMessage)
              : const Center(child: Text('No se encontro la notificacion')),
    );
  }
}

class _DetailsView extends StatelessWidget {
  final PushMessage pushMessage;

  const _DetailsView(this.pushMessage);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          if (pushMessage.imageUrl != null)
            Image.network(pushMessage.imageUrl!, fit: BoxFit.cover),

          const SizedBox(height: 30),

          Text(pushMessage.title, style: textStyle.titleMedium),
          Text(pushMessage.body),
          Divider(),
          Text(pushMessage.data.toString()),
        ],
      ),
    );
  }
}
