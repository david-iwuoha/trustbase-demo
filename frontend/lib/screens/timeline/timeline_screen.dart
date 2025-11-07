import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/theme.dart';
import '../yarn/yarn_chat.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;
  
  // Mock access log data
  final List<Map<String, dynamic>> _accessLogs = [
    {
      'id': 'log_1',
      'organization': 'First Bank Nigeria',
      'orgLogo': Icons.account_balance,
      'dataType': 'Transaction History',
      'purpose': 'Account verification for loan application',
      'timestamp': '2024-01-20 14:30',
      'status': 'approved',
    },
    {
      'id': 'log_2',
      'organization': 'MTN Nigeria',
      'orgLogo': Icons.phone,
      'dataType': 'Usage Data',
      'purpose': 'Service optimization and billing',
      'timestamp': '2024-01-20 09:15',
      'status': 'approved',
    },
    {
      'id': 'log_3',
      'organization': 'Paystack',
      'orgLogo': Icons.payment,
      'dataType': 'Payment Information',
      'purpose': 'Transaction processing',
      'timestamp': '2024-01-19 16:45',
      'status': 'approved',
    },
    {
      'id': 'log_4',
      'organization': 'Jumia',
      'orgLogo': Icons.shopping_cart,
      'dataType': 'Purchase History',
      'purpose': 'Personalized recommendations',
      'timestamp': '2024-01-19 11:20',
      'status': 'denied',
    },
    {
      'id': 'log_5',
      'organization': 'First Bank Nigeria',
      'orgLogo': Icons.account_balance,
      'dataType': 'Personal Information',
      'purpose': 'KYC compliance check',
      'timestamp': '2024-01-18 13:10',
      'status': 'approved',
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

  void _handleExplain(Map<String, dynamic> logEntry) {
    // Navigate to YarnGPT with specific query
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YarnChatScreen(
          initialQuery: 'Explain why ${logEntry['organization']} accessed my ${logEntry['dataType']} for ${logEntry['purpose']}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TrustBaseColors.background,
      appBar: AppBar(
        title: const Text('Access Timeline'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Simulate refresh
          await Future.delayed(const Duration(milliseconds: 1000));
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _accessLogs.length,
          itemBuilder: (context, index) {
            return _buildStaggeredChild(
              _buildTimelineEntry(_accessLogs[index]),
              index,
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimelineEntry(Map<String, dynamic> entry) {
    final isApproved = entry['status'] == 'approved';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: TrustBaseTheme.glassDecoration,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Organization Logo
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: TrustBaseColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        entry['orgLogo'],
                        color: TrustBaseColors.primaryBlue,
                        size: 20,
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Organization and Status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry['organization'],
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: isApproved 
                                    ? TrustBaseColors.successGreen 
                                    : TrustBaseColors.error,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isApproved ? 'Access Granted' : 'Access Denied',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: isApproved 
                                    ? TrustBaseColors.successGreen 
                                    : TrustBaseColors.error,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Timestamp
                    Text(
                      _formatTimestamp(entry['timestamp']),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Data Type and Purpose
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: TrustBaseColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: TrustBaseColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.data_usage,
                            size: 16,
                            color: TrustBaseColors.accentTeal,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Data Type:',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              entry['dataType'],
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: TrustBaseColors.accentTeal,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Purpose:',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              entry['purpose'],
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Explain Button
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: TrustBaseColors.border),
              ),
            ),
            child: TextButton.icon(
              onPressed: () => _handleExplain(entry),
              icon: const Icon(
                Icons.psychology,
                size: 18,
              ),
              label: const Text('Explain with YarnGPT'),
              style: TextButton.styleFrom(
                foregroundColor: TrustBaseColors.accentTeal,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    // Simple timestamp formatting for demo
    final parts = timestamp.split(' ');
    if (parts.length == 2) {
      final dateParts = parts[0].split('-');
      if (dateParts.length == 3) {
        return '${dateParts[2]}/${dateParts[1]} ${parts[1]}';
      }
    }
    return timestamp;
  }
}