import 'package:google_maps_flutter/google_maps_flutter.dart';

enum EmergencyType { medical, violence, lostPerson, fire, other }

enum IncidentStatus { reported, dispatched, responding, resolved }

class Emergency {
  final String id;
  final EmergencyType type;
  final LatLng location;
  final String description;
  final String reporterId;
  final DateTime reportedAt;
  final IncidentStatus status;
  final String? assignedResponder;
  final int? eta; // in minutes

  Emergency({
    required this.id,
    required this.type,
    required this.location,
    required this.description,
    required this.reporterId,
    required this.reportedAt,
    required this.status,
    this.assignedResponder,
    this.eta,
  });

  factory Emergency.fromMap(Map<String, dynamic> map) {
    return Emergency(
      id: map['id'],
      type: EmergencyType.values.byName(map['type']),
      location: LatLng(map['lat'], map['lng']),
      description: map['description'],
      reporterId: map['reporterId'],
      reportedAt: DateTime.parse(map['reportedAt']),
      status: IncidentStatus.values.byName(map['status']),
      assignedResponder: map['assignedResponder'],
      eta: map['eta'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'lat': location.latitude,
      'lng': location.longitude,
      'description': description,
      'reporterId': reporterId,
      'reportedAt': reportedAt.toIso8601String(),
      'status': status.name,
      'assignedResponder': assignedResponder,
      'eta': eta,
    };
  }
}

class Incident {
  final String id;
  final String title;
  final String description;
  final LatLng location;
  final DateTime timestamp;
  final String? videoUrl;
  final String? zoneId;
  final EmergencyType type;

  Incident({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.timestamp,
    this.videoUrl,
    this.zoneId,
    required this.type,
  });

  factory Incident.fromMap(Map<String, dynamic> map) {
    return Incident(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      location: LatLng(map['lat'], map['lng']),
      timestamp: DateTime.parse(map['timestamp']),
      videoUrl: map['videoUrl'],
      zoneId: map['zoneId'],
      type: EmergencyType.values.byName(map['type']),
    );
  }
}
