import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../providers/notification_provider.dart';
import '../models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Security', 'Issuer', 'Expiry'];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    List<NotificationModel> list = provider.notifications;

    if (_selectedFilter != 'All') {
      list = list.where((n) => n.type.toUpperCase() == _selectedFilter.toUpperCase()).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications Center'),
        actions: [
          if (provider.unreadCount > 0)
            TextButton.icon(
              onPressed: () {
                provider.markAllAsRead();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All notifications marked as read.')),
                );
              },
              icon: const Icon(Icons.done_all_rounded, size: 18),
              label: const Text('Mark All Read'),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter Chips
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    final isSelected = _selectedFilter == filter;
                    return ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedFilter = filter),
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 13,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Notifications List
              Expanded(
                child: list.isEmpty
                    ? const EmptyStateView(
                        icon: Icons.notifications_off_outlined,
                        title: 'No Notifications',
                        description: 'You are all caught up! No recent security alerts or issuer notifications.',
                      )
                    : ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final item = list[index];
                          IconData iconData = Icons.notifications_rounded;
                          Color iconColor = AppColors.primary;

                          if (item.type == 'SECURITY') {
                            iconData = Icons.shield_rounded;
                            iconColor = AppColors.secondary;
                          } else if (item.type == 'ISSUER') {
                            iconData = Icons.verified_user_rounded;
                            iconColor = AppColors.tertiary;
                          } else if (item.type == 'EXPIRY') {
                            iconData = Icons.warning_rounded;
                            iconColor = AppColors.error;
                          }

                          return Dismissible(
                            key: Key(item.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.delete_rounded, color: Colors.white),
                            ),
                            onDismissed: (_) {
                              // Dismiss notification
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: item.isRead ? AppColors.border : AppColors.primary.withOpacity(0.3),
                                  width: item.isRead ? 1 : 1.5,
                                ),
                              ),
                              child: Material(
                                color: item.isRead ? AppColors.surface : AppColors.primary.withOpacity(0.04),
                                borderRadius: BorderRadius.circular(16),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(14),
                                  leading: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: iconColor.withOpacity(0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(iconData, color: iconColor, size: 22),
                                  ),
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.title,
                                          style: TextStyle(
                                            fontWeight: item.isRead ? FontWeight.w600 : FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      if (!item.isRead)
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        item.message,
                                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        _formatTimeAgo(item.timestamp),
                                        style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontFamily: 'monospace'),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    if (!item.isRead) {
                                      provider.markAsRead(item.id);
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}
