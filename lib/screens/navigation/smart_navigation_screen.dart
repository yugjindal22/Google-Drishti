import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../../providers/auth_provider.dart';

class SmartNavigationScreen extends ConsumerStatefulWidget {
  const SmartNavigationScreen({super.key});

  @override
  ConsumerState<SmartNavigationScreen> createState() =>
      _SmartNavigationScreenState();
}

class _SmartNavigationScreenState extends ConsumerState<SmartNavigationScreen> {
  GoogleMapController? _mapController;
  final Location _location = Location();
  LatLng? _currentLocation;
  LatLng? _destination;
  final Set<Polyline> _polylines = {};
  List<String> _instructions = [];

  final List<Map<String, dynamic>> _destinations = [
    {'name': 'Main Stage', 'location': const LatLng(37.7749, -122.4194)},
    {'name': 'Food Court', 'location': const LatLng(37.7744, -122.4189)},
    {'name': 'Medical Tent', 'location': const LatLng(37.7754, -122.4185)},
    {'name': 'Emergency Exit A', 'location': const LatLng(37.7744, -122.4190)},
    {'name': 'Restrooms', 'location': const LatLng(37.7740, -122.4188)},
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locationData = await _location.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          _currentLocation =
              LatLng(locationData.latitude!, locationData.longitude!);
        });
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _getRoute(LatLng destination) async {
    if (_currentLocation == null) return;

    setState(() {
      _destination = destination;
    });

    try {
      final apiService = ref.read(apiServiceProvider);
      final routeData = await apiService.getSmartRoute(
        origin: _currentLocation!,
        destination: destination,
      );

      final route = routeData['route'] as List<dynamic>;
      final instructions = routeData['instructions'] as List<dynamic>;

      setState(() {
        _polylines.clear();
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: route
                .map((point) => LatLng(point['lat'], point['lng']))
                .toList(),
            color: Colors.blue,
            width: 5,
          ),
        );
        _instructions = instructions.cast<String>();
      });

      // Fit camera to show route
      if (_mapController != null) {
        final bounds = _calculateBounds([_currentLocation!, destination]);
        _mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 100),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting route: $e')),
      );
    }
  }

  LatLngBounds _calculateBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      minLat = minLat < point.latitude ? minLat : point.latitude;
      maxLat = maxLat > point.latitude ? maxLat : point.latitude;
      minLng = minLng < point.longitude ? minLng : point.longitude;
      maxLng = maxLng > point.longitude ? maxLng : point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Navigation'),
      ),
      body: Column(
        children: [
          // Destination Selector
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Destination',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _destinations.length,
                    itemBuilder: (context, index) {
                      final dest = _destinations[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(dest['name']),
                          selected: _destination == dest['location'],
                          onSelected: (selected) {
                            if (selected) {
                              _getRoute(dest['location']);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Map
          Expanded(
            flex: 2,
            child: GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              initialCameraPosition: CameraPosition(
                target: _currentLocation ?? const LatLng(37.7749, -122.4194),
                zoom: 16,
              ),
              polylines: _polylines,
              markers: {
                if (_currentLocation != null)
                  Marker(
                    markerId: const MarkerId('current'),
                    position: _currentLocation!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue),
                    infoWindow: const InfoWindow(title: 'Your Location'),
                  ),
                if (_destination != null)
                  Marker(
                    markerId: const MarkerId('destination'),
                    position: _destination!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed),
                    infoWindow: const InfoWindow(title: 'Destination'),
                  ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),

          // Instructions
          if (_instructions.isNotEmpty)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Navigation Instructions',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _instructions.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text('${index + 1}'),
                              ),
                              title: Text(_instructions[index]),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
