import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/broadcast_model.dart';
import '../../providers/auth_provider.dart';

final broadcastsProvider = FutureProvider<List<LiveBroadcast>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getLiveBroadcasts();
});

class LiveBroadcastsScreen extends ConsumerWidget {
  const LiveBroadcastsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broadcastsAsync = ref.watch(broadcastsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Broadcasts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(broadcastsProvider),
          ),
        ],
      ),
      body: broadcastsAsync.when(
        data: (broadcasts) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: broadcasts.length,
          itemBuilder: (context, index) {
            final broadcast = broadcasts[index];
            return _buildBroadcastCard(broadcast);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading broadcasts: $error'),
        ),
      ),
    );
  }

  Widget _buildBroadcastCard(LiveBroadcast broadcast) {
    Color cardColor;
    IconData icon;

    switch (broadcast.type) {
      case BroadcastType.emergency:
        cardColor = Colors.red[50]!;
        icon = Icons.emergency;
        break;
      case BroadcastType.warning:
        cardColor = Colors.orange[50]!;
        icon = Icons.warning;
        break;
      case BroadcastType.panic:
        cardColor = Colors.purple[50]!;
        icon = Icons.psychology;
        break;
      default:
        cardColor = Colors.blue[50]!;
        icon = Icons.info;
    }

    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: _getTypeColor(broadcast.type)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    broadcast.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  _formatTime(broadcast.timestamp),
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(broadcast.message),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(BroadcastType type) {
    switch (type) {
      case BroadcastType.emergency:
        return Colors.red;
      case BroadcastType.warning:
        return Colors.orange;
      case BroadcastType.panic:
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${difference.inHours}h ago';
    }
  }
}
