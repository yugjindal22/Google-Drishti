import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/emergency_model.dart';
import '../../providers/auth_provider.dart';

class IncidentReplayScreen extends ConsumerStatefulWidget {
  const IncidentReplayScreen({super.key});

  @override
  ConsumerState<IncidentReplayScreen> createState() =>
      _IncidentReplayScreenState();
}

class _IncidentReplayScreenState extends ConsumerState<IncidentReplayScreen> {
  List<Incident> _incidents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIncidents();
  }

  Future<void> _loadIncidents() async {
    try {
      final apiService = ref.read(apiServiceProvider);
      // Mock location for demo
      final incidents = await apiService.getNearbyIncidents(
        const LatLng(37.7749, -122.4194),
      );

      setState(() {
        _incidents = incidents;
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
        title: const Text('Recent Incidents'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadIncidents,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _incidents.length,
              itemBuilder: (context, index) {
                final incident = _incidents[index];
                return _buildIncidentCard(incident);
              },
            ),
    );
  }

  Widget _buildIncidentCard(Incident incident) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_getIncidentIcon(incident.type), color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    incident.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  _formatTime(incident.timestamp),
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(incident.description),
            const SizedBox(height: 12),
            if (incident.videoUrl != null)
              ElevatedButton.icon(
                onPressed: () => _showVideoDialog(incident),
                icon: const Icon(Icons.play_arrow),
                label: const Text('View Video Replay'),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getIncidentIcon(EmergencyType type) {
    switch (type) {
      case EmergencyType.medical:
        return Icons.medical_services;
      case EmergencyType.violence:
        return Icons.security;
      case EmergencyType.fire:
        return Icons.local_fire_department;
      default:
        return Icons.warning;
    }
  }

  void _showVideoDialog(Incident incident) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(incident.title),
        content: const Text(
            'Video replay feature will be implemented with actual video URLs'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
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
}
