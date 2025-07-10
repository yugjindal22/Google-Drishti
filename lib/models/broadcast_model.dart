enum BroadcastType { info, warning, emergency, panic }

class LiveBroadcast {
  final String id;
  final String title;
  final String message;
  final BroadcastType type;
  final DateTime timestamp;
  final bool isActive;
  final String? zoneId;

  LiveBroadcast({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isActive = true,
    this.zoneId,
  });

  factory LiveBroadcast.fromMap(Map<String, dynamic> map) {
    return LiveBroadcast(
      id: map['id'],
      title: map['title'],
      message: map['message'],
      type: BroadcastType.values.byName(map['type']),
      timestamp: DateTime.parse(map['timestamp']),
      isActive: map['isActive'] ?? true,
      zoneId: map['zoneId'],
    );
  }
}

enum SentimentType {
  calm, // 😌
  alert, // 😐
  panic // 😨
}

class CrowdSentiment {
  final String zoneId;
  final SentimentType sentiment;
  final double confidence; // 0.0-1.0
  final DateTime timestamp;
  final Map<String, double> emotions; // joy, anger, fear, etc.

  CrowdSentiment({
    required this.zoneId,
    required this.sentiment,
    required this.confidence,
    required this.timestamp,
    required this.emotions,
  });

  factory CrowdSentiment.fromMap(Map<String, dynamic> map) {
    return CrowdSentiment(
      zoneId: map['zoneId'],
      sentiment: SentimentType.values.byName(map['sentiment']),
      confidence: (map['confidence'] as num).toDouble(),
      timestamp: DateTime.parse(map['timestamp']),
      emotions: Map<String, double>.from(map['emotions']),
    );
  }
}

class ChatMessage {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final String? location;
  final Map<String, dynamic>? metadata;

  ChatMessage({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.location,
    this.metadata,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      message: map['message'],
      isUser: map['isUser'],
      timestamp: DateTime.parse(map['timestamp']),
      location: map['location'],
      metadata: map['metadata'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'location': location,
      'metadata': metadata,
    };
  }
}
