import 'package:google_maps_flutter/google_maps_flutter.dart';

enum ZoneStatus {
  safe, // Green
  congested, // Yellow
  highRisk, // Red
  incident // Blue
}

class SafetyZone {
  final String id;
  final String name;
  final List<LatLng> boundaries;
  final ZoneStatus status;
  final DateTime lastUpdated;
  final String? description;
  final int crowdDensity; // 0-100
  final double riskLevel; // 0.0-1.0

  SafetyZone({
    required this.id,
    required this.name,
    required this.boundaries,
    required this.status,
    required this.lastUpdated,
    this.description,
    required this.crowdDensity,
    required this.riskLevel,
  });

  factory SafetyZone.fromMap(Map<String, dynamic> map) {
    return SafetyZone(
      id: map['id'],
      name: map['name'],
      boundaries: (map['boundaries'] as List)
          .map((point) => LatLng(point['lat'], point['lng']))
          .toList(),
      status: ZoneStatus.values.byName(map['status']),
      lastUpdated: DateTime.parse(map['lastUpdated']),
      description: map['description'],
      crowdDensity: map['crowdDensity'],
      riskLevel: (map['riskLevel'] as num).toDouble(),
    );
  }
}

enum MarkerType { exit, medical, food, stage, restroom, security }

class EventMarker {
  final String id;
  final String name;
  final LatLng position;
  final MarkerType type;
  final String description;
  final bool isActive;

  EventMarker({
    required this.id,
    required this.name,
    required this.position,
    required this.type,
    required this.description,
    this.isActive = true,
  });

  factory EventMarker.fromMap(Map<String, dynamic> map) {
    return EventMarker(
      id: map['id'],
      name: map['name'],
      position: LatLng(map['lat'], map['lng']),
      type: MarkerType.values.byName(map['type']),
      description: map['description'],
      isActive: map['isActive'] ?? true,
    );
  }
}
