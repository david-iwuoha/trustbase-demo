import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';
import '../../utils/theme.dart';
import '../../services/auth_service.dart';
import 'profile_popup.dart';
import '../yarn/yarn_chat.dart';
import '../timeline/timeline_screen.dart';
import '../consent/consent_detail.dart';
import '../settings/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;
  bool _showProfilePopup = false;
  
  // Mock data
  final List<Map<String, dynamic>> _organizations = [
    {
      'id': 'org_1',
      'name': 'First Bank Nigeria',
      'logo': Icons.account_balance,
      'trustScore': 8.5,
      'consentActive': true,
      'dataTypes': ['Personal Info', 'Financial Data', 'Transaction History'],
    },
    {
      'id': 'org_2',
      'name': 'MTN Nigeria',
      'logo': Icons.phone,
      'trustScore': 7.8,
      'consentActive': true,
      'dataTypes': ['Contact Info', 'Usage Data', 'Location Data'],
    },
    {
      'id': 'org_3',
      'name': 'Jumia',
      'logo': Icons.shopping_cart,
      'trustScore': 7.2,
      'consentActive': false,
      'dataTypes': ['Purchase History', 'Preferences', 'Delivery Address'],
    },
    {
      'id': 'org_4',
      'name': 'Paystack',
      'logo': Icons.payment,
      'trustScore': 9.1,
      'consentActive': true,
      'dataTypes': ['Payment Info', 'Transaction Data'],
    },
  ];

  @override
  void initState() {
    super.initState();
    
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _staggerController.forward();
    
    // Show profile popup after delay
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() => _showProfilePopup = true);
      }
    });
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  Widget _buildStaggeredChild(Widget child, int index) {
    return AnimatedBuilder(
      animation: _staggerController,
      builder: (context, _) {
        final delay = index * 0.1;
        final animationValue = Curves.easeOut.transform(
          (_staggerController.value - delay).clamp(0.0, 1.0),
        );
        
        return Transform.translate(
          offset: Offset(0, 50 * (1 - animationValue)),
          child: Opacity(
            opacity: animationValue,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;
    
    return Scaffold(
      backgroundColor: TrustBaseColors.background,
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: Column(
              children: [
                // App Bar
                _buildStaggeredChild(
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _showDrawer(context);
                          },
                          icon: const Icon(Icons.menu),
                        ),
                        
                        const Spacer(),
                        
                        // Language Selector
                        IconButton(
                          onPressed: () {
                            _showLanguageSelector(context);
                          },
                          icon: const Icon(Icons.language),
                        ),
                        
                        const SizedBox(width: 8),
                        
                        // User Avatar
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsScreen(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: TrustBaseColors.primaryBlue,
                            child: Text(
                              user?['firstName']?.substring(0, 1) ?? 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  0,
                ),
                
                // Summary Cards
                _buildStaggeredChild(
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(child: _buildSummaryCard('Active Consents', '3', TrustBaseColors.successGreen)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildSummaryCard('Revoked', '1', TrustBaseColors.warning)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildSummaryCard('Recent Access', '12', TrustBaseColors.accentTeal)),
                      ],
                    ),
                  ),
                  1,
                ),
                
                const SizedBox(height: 24),
                
                // Organizations List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _organizations.length,
                    itemBuilder: (context, index) {
                      return _buildStaggeredChild(
                        _buildOrganizationCard(_organizations[index]),
                        index + 2,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // YarnGPT FAB
          Positioned(
            bottom: 24,
            right: 24,
            child: _buildStaggeredChild(
              FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const YarnChatScreen(),
                    ),
                  );
                },
                backgroundColor: TrustBaseColors.accentTeal,
                icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                label: const Text(
                  'Ask YarnGPT',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              10,
            ),
          ),
          
          // Profile Popup
          if (_showProfilePopup)
            ProfilePopup(
              onDismiss: () => setState(() => _showProfilePopup = false),
              userName: user?['firstName'] ?? 'User',
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: TrustBaseTheme.glassDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildOrganizationCard(Map<String, dynamic> org) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: TrustBaseTheme.glassDecoration,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConsentDetailScreen(organization: org),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            // Logo
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: TrustBaseColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                org['logo'],
                color: TrustBaseColors.primaryBlue,
                size: 24,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Organization Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    org['name'],
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: TrustBaseColors.warning,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Trust Score: ${org['trustScore']}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Consent Toggle
            Switch(
              value: org['consentActive'],
              onChanged: (value) {
                setState(() {
                  org['consentActive'] = value;
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      value 
                        ? 'Consent granted to ${org['name']}'
                        : 'Consent revoked from ${org['name']}',
                    ),
                  ),
                );
              },
              activeColor: TrustBaseColors.successGreen,
            ),
          ],
        ),
      ),
    );
  }

  void _showDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TrustBaseColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            
            ListTile(
              leading: const Icon(Icons.timeline),
              title: const Text('Access Timeline'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TimelineScreen(),
                  ),
                );
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                _handleLogout();
              },
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Nigerian English'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Igbo'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Yoruba'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Hausa'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<AuthService>(context, listen: false).logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}