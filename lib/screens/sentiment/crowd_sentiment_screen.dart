import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/broadcast_model.dart';
import '../../providers/auth_provider.dart';

class CrowdSentimentScreen extends ConsumerStatefulWidget {
  const CrowdSentimentScreen({super.key});

  @override
  ConsumerState<CrowdSentimentScreen> createState() =>
      _CrowdSentimentScreenState();
}

class _CrowdSentimentScreenState extends ConsumerState<CrowdSentimentScreen> {
  CrowdSentiment? _currentSentiment;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSentiment();
  }

  Future<void> _loadSentiment() async {
    try {
      final apiService = ref.read(apiServiceProvider);
      final sentiment =
          await apiService.getZoneSentiment('zone_1'); // Mock zone

      setState(() {
        _currentSentiment = sentiment;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crowd Sentiment'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSentiment,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildSentimentCard(),
                  const SizedBox(height: 24),
                  _buildEmotionBreakdown(),
                  const SizedBox(height: 24),
                  _buildTips(),
                ],
              ),
            ),
    );
  }

  Widget _buildSentimentCard() {
    if (_currentSentiment == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('No sentiment data available'),
        ),
      );
    }

    String emoji = _getSentimentEmoji(_currentSentiment!.sentiment);
    String description = _getSentimentDescription(_currentSentiment!.sentiment);
    Color color = _getSentimentColor(_currentSentiment!.sentiment);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Confidence: ${(_currentSentiment!.confidence * 100).toInt()}%',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: ${_formatTime(_currentSentiment!.timestamp)}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmotionBreakdown() {
    if (_currentSentiment == null) return const SizedBox();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Emotion Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._currentSentiment!.emotions.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        entry.key.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: entry.value,
                        backgroundColor: Colors.grey[300],
                        valueColor:
                            AlwaysStoppedAnimation(_getEmotionColor(entry.key)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${(entry.value * 100).toInt()}%'),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTips() {
    return Card(
      color: Colors.blue[50],
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Tips',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text('• Green areas indicate calm, relaxed crowds'),
            Text('• Yellow areas may have higher energy or excitement'),
            Text('• Red areas suggest increased stress or discomfort'),
            Text('• Use this info to choose your route and timing'),
          ],
        ),
      ),
    );
  }

  String _getSentimentEmoji(SentimentType sentiment) {
    switch (sentiment) {
      case SentimentType.calm:
        return '😌';
      case SentimentType.alert:
        return '😐';
      case SentimentType.panic:
        return '😨';
    }
  }

  String _getSentimentDescription(SentimentType sentiment) {
    switch (sentiment) {
      case SentimentType.calm:
        return 'Calm & Relaxed';
      case SentimentType.alert:
        return 'Alert & Attentive';
      case SentimentType.panic:
        return 'Tense & Anxious';
    }
  }

  Color _getSentimentColor(SentimentType sentiment) {
    switch (sentiment) {
      case SentimentType.calm:
        return Colors.green;
      case SentimentType.alert:
        return Colors.orange;
      case SentimentType.panic:
        return Colors.red;
    }
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'joy':
        return Colors.yellow;
      case 'excitement':
        return Colors.orange;
      case 'anxiety':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${difference.inHours}h ago';
    }
  }
}
