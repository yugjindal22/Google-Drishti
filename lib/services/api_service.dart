import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/safety_zone_model.dart';
import '../models/emergency_model.dart';
import '../models/broadcast_model.dart';

class ApiService {
  static const String baseUrl =
      'https://api.drishti.ai'; // Replace with actual API URL

  // Safety Map APIs
  Future<List<SafetyZone>> getSafetyZones() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/zones'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((zone) => SafetyZone.fromMap(zone)).toList();
      }
      throw Exception('Failed to load safety zones');
    } catch (e) {
      // Return mock data for development
      return _getMockSafetyZones();
    }
  }

  Future<List<EventMarker>> getEventMarkers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/markers'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((marker) => EventMarker.fromMap(marker)).toList();
      }
      throw Exception('Failed to load event markers');
    } catch (e) {
      // Return mock data for development
      return _getMockEventMarkers();
    }
  }

  // Emergency APIs
  Future<Emergency> reportEmergency(Emergency emergency) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/incident'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(emergency.toMap()),
      );

      if (response.statusCode == 201) {
        return Emergency.fromMap(json.decode(response.body));
      }
      throw Exception('Failed to report emergency');
    } catch (e) {
      // Mock response for development
      return emergency.copyWith(
        id: 'emergency_${DateTime.now().millisecondsSinceEpoch}',
        status: IncidentStatus.reported,
        eta: 5,
      );
    }
  }

  // Navigation APIs
  Future<Map<String, dynamic>> getSmartRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/navigation/route'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'origin': {'lat': origin.latitude, 'lng': origin.longitude},
          'destination': {
            'lat': destination.latitude,
            'lng': destination.longitude
          },
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to get smart route');
    } catch (e) {
      // Mock response for development
      return {
        'route': [
          {'lat': origin.latitude, 'lng': origin.longitude},
          {'lat': destination.latitude, 'lng': destination.longitude},
        ],
        'duration': '15 mins',
        'safety_score': 0.85,
        'instructions': [
          'Head north towards main stage',
          'Continue straight for 200m',
          'Turn right at food court',
          'Destination will be on your left',
        ],
      };
    }
  }

  // Chat APIs
  Future<String> sendChatMessage(String message, LatLng? location) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'message': message,
          'location': location != null
              ? {'lat': location.latitude, 'lng': location.longitude}
              : null,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response'];
      }
      throw Exception('Failed to send chat message');
    } catch (e) {
      // Mock response for development
      return _getMockChatResponse(message);
    }
  }

  // Broadcasts APIs
  Future<List<LiveBroadcast>> getLiveBroadcasts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/broadcasts'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data
            .map((broadcast) => LiveBroadcast.fromMap(broadcast))
            .toList();
      }
      throw Exception('Failed to load broadcasts');
    } catch (e) {
      // Return mock data for development
      return _getMockBroadcasts();
    }
  }

  // Sentiment APIs
  Future<CrowdSentiment> getZoneSentiment(String zoneId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/sentiment/zone/$zoneId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return CrowdSentiment.fromMap(json.decode(response.body));
      }
      throw Exception('Failed to load sentiment data');
    } catch (e) {
      // Return mock data for development
      return _getMockSentiment(zoneId);
    }
  }

  // Incidents APIs
  Future<List<Incident>> getNearbyIncidents(LatLng location) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/incidents/nearby?lat=${location.latitude}&lng=${location.longitude}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((incident) => Incident.fromMap(incident)).toList();
      }
      throw Exception('Failed to load incidents');
    } catch (e) {
      // Return mock data for development
      return _getMockIncidents();
    }
  }

  // Lost & Found APIs
  Future<Map<String, dynamic>> reportLostPerson(String imagePath) async {
    try {
      // In a real implementation, you would upload the image
      final response = await http.post(
        Uri.parse('$baseUrl/lost-person-detect'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'image_path': imagePath}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to process lost person request');
    } catch (e) {
      // Mock response for development
      return {
        'status': 'processing',
        'message':
            'Image uploaded successfully. We will notify you if a match is found.',
        'request_id': 'lost_${DateTime.now().millisecondsSinceEpoch}',
      };
    }
  }

  // Mock data methods for development
  List<SafetyZone> _getMockSafetyZones() {
    return [
      SafetyZone(
        id: 'zone_1',
        name: 'Main Stage Area',
        boundaries: [
          const LatLng(37.7749, -122.4194),
          const LatLng(37.7759, -122.4194),
          const LatLng(37.7759, -122.4184),
          const LatLng(37.7749, -122.4184),
        ],
        status: ZoneStatus.congested,
        lastUpdated: DateTime.now(),
        crowdDensity: 75,
        riskLevel: 0.6,
        description: 'High crowd density near main stage',
      ),
      SafetyZone(
        id: 'zone_2',
        name: 'Food Court',
        boundaries: [
          const LatLng(37.7739, -122.4194),
          const LatLng(37.7749, -122.4194),
          const LatLng(37.7749, -122.4184),
          const LatLng(37.7739, -122.4184),
        ],
        status: ZoneStatus.safe,
        lastUpdated: DateTime.now(),
        crowdDensity: 30,
        riskLevel: 0.2,
        description: 'Safe area with good access to exits',
      ),
    ];
  }

  List<EventMarker> _getMockEventMarkers() {
    return [
      EventMarker(
        id: 'exit_1',
        name: 'Emergency Exit A',
        position: const LatLng(37.7744, -122.4190),
        type: MarkerType.exit,
        description: 'Main emergency exit',
      ),
      EventMarker(
        id: 'medical_1',
        name: 'Medical Tent',
        position: const LatLng(37.7754, -122.4185),
        type: MarkerType.medical,
        description: 'First aid station',
      ),
      EventMarker(
        id: 'food_1',
        name: 'Food Court',
        position: const LatLng(37.7744, -122.4189),
        type: MarkerType.food,
        description: 'Food and beverages',
      ),
    ];
  }

  String _getMockChatResponse(String message) {
    if (message.toLowerCase().contains('medical')) {
      return 'The nearest medical tent is located 150m north of your current position. It\'s marked with a red cross on your map.';
    } else if (message.toLowerCase().contains('exit')) {
      return 'The safest exit from your location is Emergency Exit A, located 200m to the west. Follow the green route on your map.';
    } else if (message.toLowerCase().contains('food')) {
      return 'The food court is 100m south of your location. Current wait time is approximately 10 minutes.';
    } else {
      return 'I\'m here to help with navigation, safety information, and emergency assistance. You can ask about nearby facilities, exits, or report any concerns.';
    }
  }

  List<LiveBroadcast> _getMockBroadcasts() {
    return [
      LiveBroadcast(
        id: 'broadcast_1',
        title: 'Weather Update',
        message:
            'Light rain expected in 30 minutes. Please seek covered areas.',
        type: BroadcastType.warning,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      LiveBroadcast(
        id: 'broadcast_2',
        title: 'Performance Update',
        message: 'Main stage performance will begin in 15 minutes.',
        type: BroadcastType.info,
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
    ];
  }

  CrowdSentiment _getMockSentiment(String zoneId) {
    return CrowdSentiment(
      zoneId: zoneId,
      sentiment: SentimentType.alert,
      confidence: 0.78,
      timestamp: DateTime.now(),
      emotions: {
        'joy': 0.3,
        'excitement': 0.5,
        'anxiety': 0.2,
      },
    );
  }

  List<Incident> _getMockIncidents() {
    return [
      Incident(
        id: 'incident_1',
        title: 'Minor Medical Incident',
        description: 'Person assisted with first aid',
        location: const LatLng(37.7750, -122.4190),
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        type: EmergencyType.medical,
        videoUrl: 'https://example.com/video1.mp4',
      ),
      Incident(
        id: 'incident_2',
        title: 'Crowd Management',
        description: 'Crowd control measures implemented',
        location: const LatLng(37.7748, -122.4188),
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: EmergencyType.other,
        videoUrl: 'https://example.com/video2.mp4',
      ),
    ];
  }
}

extension on Emergency {
  Emergency copyWith({
    String? id,
    EmergencyType? type,
    LatLng? location,
    String? description,
    String? reporterId,
    DateTime? reportedAt,
    IncidentStatus? status,
    String? assignedResponder,
    int? eta,
  }) {
    return Emergency(
      id: id ?? this.id,
      type: type ?? this.type,
      location: location ?? this.location,
      description: description ?? this.description,
      reporterId: reporterId ?? this.reporterId,
      reportedAt: reportedAt ?? this.reportedAt,
      status: status ?? this.status,
      assignedResponder: assignedResponder ?? this.assignedResponder,
      eta: eta ?? this.eta,
    );
  }
}
