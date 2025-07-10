import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../../models/safety_zone_model.dart';
import '../../services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final safetyZonesProvider = FutureProvider<List<SafetyZone>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getSafetyZones();
});

final eventMarkersProvider = FutureProvider<List<EventMarker>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getEventMarkers();
});

class LiveSafetyMapScreen extends ConsumerStatefulWidget {
  const LiveSafetyMapScreen({super.key});

  @override
  ConsumerState<LiveSafetyMapScreen> createState() =>
      _LiveSafetyMapScreenState();
}

class _LiveSafetyMapScreenState extends ConsumerState<LiveSafetyMapScreen> {
  GoogleMapController? _mapController;
  LocationData? _currentLocation;
  final Location _location = Location();
  final Set<Polygon> _polygons = {};
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return;
      }

      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return;
      }

      final locationData = await _location.getLocation();
      setState(() {
        _currentLocation = locationData;
      });
    } catch (e) {
      // Handle error
      print('Error getting location: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _updateMapElements();
  }

  void _updateMapElements() {
    final safetyZones = ref.read(safetyZonesProvider);
    final eventMarkers = ref.read(eventMarkersProvider);

    safetyZones.whenData((zones) {
      setState(() {
        _polygons.clear();
        for (final zone in zones) {
          _polygons.add(_createZonePolygon(zone));
        }
      });
    });

    eventMarkers.whenData((markers) {
      setState(() {
        _markers.clear();
        for (final marker in markers) {
          _markers.add(_createEventMarker(marker));
        }

        // Add current location marker
        if (_currentLocation != null) {
          _markers.add(
            Marker(
              markerId: const MarkerId('current_location'),
              position: LatLng(
                _currentLocation!.latitude!,
                _currentLocation!.longitude!,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              infoWindow: const InfoWindow(title: 'Your Location'),
            ),
          );
        }
      });
    });
  }

  Polygon _createZonePolygon(SafetyZone zone) {
    Color zoneColor;
    switch (zone.status) {
      case ZoneStatus.safe:
        zoneColor = Colors.green.withOpacity(0.3);
        break;
      case ZoneStatus.congested:
        zoneColor = Colors.yellow.withOpacity(0.3);
        break;
      case ZoneStatus.highRisk:
        zoneColor = Colors.red.withOpacity(0.3);
        break;
      case ZoneStatus.incident:
        zoneColor = Colors.blue.withOpacity(0.3);
        break;
    }

    return Polygon(
      polygonId: PolygonId(zone.id),
      points: zone.boundaries,
      fillColor: zoneColor,
      strokeColor: zoneColor.withOpacity(0.8),
      strokeWidth: 2,
      onTap: () => _showZoneInfo(zone),
    );
  }

  Marker _createEventMarker(EventMarker marker) {
    BitmapDescriptor icon;
    switch (marker.type) {
      case MarkerType.exit:
        icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
        break;
      case MarkerType.medical:
        icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
        break;
      case MarkerType.food:
        icon =
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
        break;
      case MarkerType.stage:
        icon =
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
        break;
      case MarkerType.restroom:
        icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
        break;
      case MarkerType.security:
        icon =
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
        break;
    }

    return Marker(
      markerId: MarkerId(marker.id),
      position: marker.position,
      icon: icon,
      infoWindow: InfoWindow(
        title: marker.name,
        snippet: marker.description,
      ),
    );
  }

  void _showZoneInfo(SafetyZone zone) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getZoneIcon(zone.status),
                  color: _getZoneColor(zone.status),
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    zone.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Status', _getZoneStatusText(zone.status)),
            _buildInfoRow('Crowd Density', '${zone.crowdDensity}%'),
            _buildInfoRow('Risk Level', '${(zone.riskLevel * 100).toInt()}%'),
            _buildInfoRow('Last Updated', _formatTime(zone.lastUpdated)),
            if (zone.description != null) ...[
              const SizedBox(height: 8),
              Text(
                zone.description!,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }

  IconData _getZoneIcon(ZoneStatus status) {
    switch (status) {
      case ZoneStatus.safe:
        return Icons.check_circle;
      case ZoneStatus.congested:
        return Icons.warning;
      case ZoneStatus.highRisk:
        return Icons.dangerous;
      case ZoneStatus.incident:
        return Icons.report_problem;
    }
  }

  Color _getZoneColor(ZoneStatus status) {
    switch (status) {
      case ZoneStatus.safe:
        return Colors.green;
      case ZoneStatus.congested:
        return Colors.orange;
      case ZoneStatus.highRisk:
        return Colors.red;
      case ZoneStatus.incident:
        return Colors.blue;
    }
  }

  String _getZoneStatusText(ZoneStatus status) {
    switch (status) {
      case ZoneStatus.safe:
        return 'Safe';
      case ZoneStatus.congested:
        return 'Congested';
      case ZoneStatus.highRisk:
        return 'High Risk';
      case ZoneStatus.incident:
        return 'Incident Active';
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Safety Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(safetyZonesProvider);
              ref.invalidate(eventMarkersProvider);
              _updateMapElements();
            },
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              if (_currentLocation != null && _mapController != null) {
                _mapController!.animateCamera(
                  CameraUpdate.newLatLng(
                    LatLng(
                      _currentLocation!.latitude!,
                      _currentLocation!.longitude!,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentLocation != null
                  ? LatLng(
                      _currentLocation!.latitude!, _currentLocation!.longitude!)
                  : const LatLng(
                      37.7749, -122.4194), // Default to San Francisco
              zoom: 16,
            ),
            polygons: _polygons,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            compassEnabled: true,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: true,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
          ),

          // Legend
          Positioned(
            top: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Zone Status',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildLegendItem('Safe', Colors.green),
                    _buildLegendItem('Congested', Colors.orange),
                    _buildLegendItem('High Risk', Colors.red),
                    _buildLegendItem('Incident', Colors.blue),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
