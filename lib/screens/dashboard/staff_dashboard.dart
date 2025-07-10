import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';

class StaffDashboard extends ConsumerWidget {
  const StaffDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.shield),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                ref.read(authProvider.notifier).signOut();
                context.go('/');
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Overview
              Card(
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.security,
                            color: Colors.red[600],
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Security Control Panel',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Monitor event safety, respond to incidents, and coordinate with teams.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Quick Stats
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                        'Active Alerts', '3', Colors.red, Icons.warning),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                        'Response Teams', '12', Colors.blue, Icons.group),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                        'Crowd Density', '75%', Colors.orange, Icons.people),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                        'Zone Status', 'Monitoring', Colors.green, Icons.radar),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Staff Actions
              const Text(
                'Staff Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildActionCard(
                    context,
                    'Control Room',
                    'Monitor all zones and incidents',
                    Icons.monitor,
                    Colors.blue,
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Control Room feature coming soon')),
                    ),
                  ),
                  _buildActionCard(
                    context,
                    'Dispatch',
                    'Coordinate response teams',
                    Icons.send,
                    Colors.green,
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Dispatch feature coming soon')),
                    ),
                  ),
                  _buildActionCard(
                    context,
                    'Analytics',
                    'View detailed reports',
                    Icons.analytics,
                    Colors.purple,
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Analytics feature coming soon')),
                    ),
                  ),
                  _buildActionCard(
                    context,
                    'Broadcast',
                    'Send alerts to attendees',
                    Icons.campaign,
                    Colors.orange,
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Broadcast feature coming soon')),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Public Features Access
              const Text(
                'Public Features (Preview)',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              _buildFeatureListTile(
                context,
                'Safety Map',
                'View attendee safety map interface',
                Icons.map,
                Colors.green,
                () => context.go('/safety-map'),
              ),
              _buildFeatureListTile(
                context,
                'Emergency SOS',
                'Test emergency reporting system',
                Icons.emergency,
                Colors.red,
                () => context.go('/emergency'),
              ),
              _buildFeatureListTile(
                context,
                'AI Assistant',
                'Test Gemini chat assistant',
                Icons.smart_toy,
                Colors.purple,
                () => context.go('/chat'),
              ),

              const SizedBox(height: 24),

              // Emergency Protocols
              Card(
                color: Colors.amber[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.emergency_share,
                        color: Colors.amber[800],
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Emergency Protocols',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Level 1: Monitor • Level 2: Alert • Level 3: Evacuate',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
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

  Widget _buildStatCard(
      String title, String value, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureListTile(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
