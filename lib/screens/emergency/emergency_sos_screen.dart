import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../../models/emergency_model.dart';
import '../../providers/auth_provider.dart';

class EmergencySOSScreen extends ConsumerStatefulWidget {
  const EmergencySOSScreen({super.key});

  @override
  ConsumerState<EmergencySOSScreen> createState() => _EmergencySOSScreenState();
}

class _EmergencySOSScreenState extends ConsumerState<EmergencySOSScreen> {
  EmergencyType _selectedType = EmergencyType.medical;
  final TextEditingController _descriptionController = TextEditingController();
  final Location _location = Location();
  bool _isLoading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _reportEmergency() async {
    setState(() => _isLoading = true);

    try {
      // Get current location
      final locationData = await _location.getLocation();
      if (locationData.latitude == null || locationData.longitude == null) {
        throw Exception('Unable to get current location');
      }

      // Get current user
      final user = await ref.read(authServiceProvider).getCurrentUserData();
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Create emergency report
      final emergency = Emergency(
        id: '', // Will be assigned by backend
        type: _selectedType,
        location: LatLng(locationData.latitude!, locationData.longitude!),
        description: _descriptionController.text.trim(),
        reporterId: user.id,
        reportedAt: DateTime.now(),
        status: IncidentStatus.reported,
      );

      // Send to backend
      final apiService = ref.read(apiServiceProvider);
      final reportedEmergency = await apiService.reportEmergency(emergency);

      setState(() {
        _isLoading = false;
      });

      // Show success dialog
      _showSuccessDialog(reportedEmergency);
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog(e.toString());
    }
  }

  void _showSuccessDialog(Emergency emergency) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 64,
        ),
        title: const Text('Help is on the way!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emergency.eta != null
                  ? 'Estimated arrival time: ${emergency.eta} minutes'
                  : 'Emergency response team has been notified',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      'Emergency ID: ${emergency.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Status: ${_getStatusText(emergency.status)}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to dashboard
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.error,
          color: Colors.red,
          size: 64,
        ),
        title: const Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _getStatusText(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.reported:
        return 'Reported';
      case IncidentStatus.dispatched:
        return 'Team Dispatched';
      case IncidentStatus.responding:
        return 'Team Responding';
      case IncidentStatus.resolved:
        return 'Resolved';
    }
  }

  Color _getEmergencyTypeColor(EmergencyType type) {
    switch (type) {
      case EmergencyType.medical:
        return Colors.red;
      case EmergencyType.violence:
        return Colors.purple;
      case EmergencyType.lostPerson:
        return Colors.orange;
      case EmergencyType.fire:
        return Colors.deepOrange;
      case EmergencyType.other:
        return Colors.grey;
    }
  }

  IconData _getEmergencyTypeIcon(EmergencyType type) {
    switch (type) {
      case EmergencyType.medical:
        return Icons.medical_services;
      case EmergencyType.violence:
        return Icons.security;
      case EmergencyType.lostPerson:
        return Icons.person_search;
      case EmergencyType.fire:
        return Icons.local_fire_department;
      case EmergencyType.other:
        return Icons.warning;
    }
  }

  String _getEmergencyTypeText(EmergencyType type) {
    switch (type) {
      case EmergencyType.medical:
        return 'Medical Emergency';
      case EmergencyType.violence:
        return 'Security/Violence';
      case EmergencyType.lostPerson:
        return 'Lost Person';
      case EmergencyType.fire:
        return 'Fire Emergency';
      case EmergencyType.other:
        return 'Other Emergency';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency SOS'),
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Warning Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  border: Border.all(color: Colors.red[200]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red[600], size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency Services',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[800],
                            ),
                          ),
                          Text(
                            'Use only for real emergencies. False reports may result in penalties.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Emergency Type Selection
              const Text(
                'Select Emergency Type',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              ...EmergencyType.values.map((type) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: RadioListTile<EmergencyType>(
                      value: type,
                      groupValue: _selectedType,
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value!;
                        });
                      },
                      title: Row(
                        children: [
                          Icon(
                            _getEmergencyTypeIcon(type),
                            color: _getEmergencyTypeColor(type),
                          ),
                          const SizedBox(width: 12),
                          Text(_getEmergencyTypeText(type)),
                        ],
                      ),
                      tileColor: _selectedType == type
                          ? _getEmergencyTypeColor(type).withOpacity(0.1)
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: _selectedType == type
                              ? _getEmergencyTypeColor(type)
                              : Colors.grey[300]!,
                        ),
                      ),
                    ),
                  )),

              const SizedBox(height: 24),

              // Description
              const Text(
                'Describe the Situation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Provide details about the emergency...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Emergency Button
              Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red[600]!, Colors.red[800]!],
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _reportEmergency,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.emergency,
                              size: 32,
                              color: Colors.white,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'SEND SOS',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // Emergency Contacts
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Emergency Contacts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildContactRow('Police', '100', Icons.local_police),
                      _buildContactRow(
                          'Medical', '108', Icons.medical_services),
                      _buildContactRow(
                          'Fire', '101', Icons.local_fire_department),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactRow(String service, String number, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.red),
          const SizedBox(width: 12),
          Text(
            service,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Text(
            number,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
