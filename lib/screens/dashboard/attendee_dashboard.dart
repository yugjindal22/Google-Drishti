import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';

class AttendeeDashboard extends ConsumerWidget {
  const AttendeeDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drishti AI'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.person_outline),
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
              // Welcome Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.waving_hand,
                            color: Colors.amber[600],
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Welcome to the Event!',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Stay safe and enjoy the event. Use the features below to navigate, get help, and stay informed.',
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

              // Quick Actions Grid
              const Text(
                'Quick Actions',
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
                  _buildQuickActionCard(
                    context,
                    'Safety Map',
                    'View live safety zones and crowd density',
                    Icons.map,
                    Colors.green,
                    () => context.go('/safety-map'),
                  ),
                  _buildQuickActionCard(
                    context,
                    'Navigation',
                    'Get smart routes to your destination',
                    Icons.navigation,
                    Colors.blue,
                    () => context.go('/navigation'),
                  ),
                  _buildQuickActionCard(
                    context,
                    'Emergency SOS',
                    'Get immediate help in emergencies',
                    Icons.emergency,
                    Colors.red,
                    () => context.go('/emergency'),
                  ),
                  _buildQuickActionCard(
                    context,
                    'AI Assistant',
                    'Chat with Gemini for help and info',
                    Icons.smart_toy,
                    Colors.purple,
                    () => context.go('/chat'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Additional Features
              const Text(
                'More Features',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              _buildFeatureListTile(
                context,
                'Live Broadcasts',
                'Stay updated with event announcements',
                Icons.broadcast_on_home,
                Colors.orange,
                () => context.go('/alerts'),
              ),
              _buildFeatureListTile(
                context,
                'Incident Reports',
                'View recent incidents in your area',
                Icons.report,
                Colors.amber,
                () => context.go('/incidents'),
              ),
              _buildFeatureListTile(
                context,
                'Lost & Found',
                'Report or find missing persons',
                Icons.person_search,
                Colors.teal,
                () => context.go('/lost-found'),
              ),
              _buildFeatureListTile(
                context,
                'Crowd Sentiment',
                'Check real-time crowd mood',
                Icons.mood,
                Colors.pink,
                () => context.go('/sentiment'),
              ),

              const SizedBox(height: 24),

              // Emergency Contact Card
              Card(
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.phone_in_talk,
                        color: Colors.red[600],
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Emergency Contacts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Police: 100 • Medical: 108 • Fire: 101',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red[700],
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

  Widget _buildQuickActionCard(
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
