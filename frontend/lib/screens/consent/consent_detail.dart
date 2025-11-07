import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/theme.dart';

class ConsentDetailScreen extends StatefulWidget {
  final Map<String, dynamic> organization;

  const ConsentDetailScreen({
    super.key,
    required this.organization,
  });

  @override
  State<ConsentDetailScreen> createState() => _ConsentDetailScreenState();
}

class _ConsentDetailScreenState extends State<ConsentDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  
  bool _consentActive = true;
  
  // Mock consent history
  final List<Map<String, dynamic>> _consentHistory = [
    {
      'action': 'Consent Granted',
      'date': '2024-01-15',
      'time': '10:30 AM',
      'dataTypes': ['Personal Info', 'Financial Data'],
    },
    {
      'action': 'Data Access',
      'date': '2024-01-10',
      'time': '2:15 PM',
      'dataTypes': ['Transaction History'],
    },
    {
      'action': 'Consent Updated',
      'date': '2024-01-05',
      'time': '9:45 AM',
      'dataTypes': ['Personal Info'],
    },
  ];

  @override
  void initState() {
    super.initState();
    
    _consentActive = widget.organization['consentActive'] ?? true;
    
    _slideController = AnimationController(
      duration: TrustBaseTheme.standardAnimation,
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: TrustBaseTheme.decelerateCurve,
    ));
    
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _handleRevokeConsent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revoke Consent'),
        content: Text(
          'Are you sure you want to revoke consent for ${widget.organization['name']}? '
          'This will stop them from accessing your data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _consentActive = false;
              });
              
              // Add to timeline (mock)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Consent revoked for ${widget.organization['name']}'),
                  backgroundColor: TrustBaseColors.warning,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TrustBaseColors.error,
            ),
            child: const Text('Revoke'),
          ),
        ],
      ),
    );
  }

  void _handleGrantConsent() {
    setState(() {
      _consentActive = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Consent granted to ${widget.organization['name']}'),
        backgroundColor: TrustBaseColors.successGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TrustBaseColors.background,
      appBar: AppBar(
        title: Text(widget.organization['name']),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Organization Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: TrustBaseTheme.glassDecoration,
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: TrustBaseColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        widget.organization['logo'],
                        color: TrustBaseColors.primaryBlue,
                        size: 32,
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.organization['name'],
                            style: Theme.of(context).textTheme.displaySmall,
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
                                'Trust Score: ${widget.organization['trustScore']}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Consent Status
              Container(
                padding: const EdgeInsets.all(20),
                decoration: TrustBaseTheme.glassDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Consent Status',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _consentActive 
                              ? TrustBaseColors.successGreen 
                              : TrustBaseColors.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _consentActive ? 'Active' : 'Revoked',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: _consentActive 
                              ? TrustBaseColors.successGreen 
                              : TrustBaseColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    if (_consentActive)
                      ElevatedButton(
                        onPressed: _handleRevokeConsent,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TrustBaseColors.error,
                        ),
                        child: const Text('Revoke Consent'),
                      )
                    else
                      ElevatedButton(
                        onPressed: _handleGrantConsent,
                        child: const Text('Grant Consent'),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Data Types Shared
              Container(
                padding: const EdgeInsets.all(20),
                decoration: TrustBaseTheme.glassDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data Types Shared',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    
                    ...widget.organization['dataTypes'].map<Widget>((dataType) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: _consentActive 
                                ? TrustBaseColors.successGreen 
                                : TrustBaseColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              dataType,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Consent History
              Container(
                padding: const EdgeInsets.all(20),
                decoration: TrustBaseTheme.glassDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Consent History',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    
                    ..._consentHistory.map((entry) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: TrustBaseColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: TrustBaseColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry['action'],
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${entry['date']} ${entry['time']}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            if (entry['dataTypes'] != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Data: ${entry['dataTypes'].join(', ')}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}