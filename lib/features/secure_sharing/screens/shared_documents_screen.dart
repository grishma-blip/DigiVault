import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../models/share_model.dart';
import '../providers/share_provider.dart';
import 'recipient_shared_view_screen.dart';

class SharedDocumentsScreen extends StatefulWidget {
  const SharedDocumentsScreen({super.key});

  @override
  State<SharedDocumentsScreen> createState() => _SharedDocumentsScreenState();
}

class _SharedDocumentsScreenState extends State<SharedDocumentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _confirmRevoke(BuildContext context, ShareModel share) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revoke Share Access?'),
        content: Text('Revoking access will immediately invalidate the link for ${share.recipientLabel}. Recipients will no longer be able to view this document.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              await context.read<ShareProvider>().revokeShare(share.id);
              navigator.pop();
              messenger.showSnackBar(
                const SnackBar(content: Text('Share access revoked successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Revoke Now', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShareProvider>();
    final active = provider.activeShares;
    final expiredOrRevoked = provider.revokedOrExpiredShares;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Active Shares & Revocation'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: [
            Tab(text: 'Active Shares (${active.length})'),
            Tab(text: 'Revoked / Expired (${expiredOrRevoked.length})'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            // Active Shares Tab
            active.isEmpty
                ? const EmptyStateView(
                    icon: Icons.link_off_rounded,
                    title: 'No Active Shares',
                    description: 'You have not shared any documents yet. Create a secure share link from any document details page.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: active.length,
                    itemBuilder: (context, index) {
                      final share = active[index];
                      return _buildShareCard(context, share, isActive: true);
                    },
                  ),

            // Revoked/Expired Tab
            expiredOrRevoked.isEmpty
                ? const EmptyStateView(
                    icon: Icons.history_rounded,
                    title: 'No Expired Shares',
                    description: 'Revoked or expired document share links will appear here.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: expiredOrRevoked.length,
                    itemBuilder: (context, index) {
                      final share = expiredOrRevoked[index];
                      return _buildShareCard(context, share, isActive: false);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareCard(BuildContext context, ShareModel share, {required bool isActive}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  share.documentTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.tertiaryContainer : AppColors.errorContainer,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  isActive ? 'ACTIVE' : 'REVOKED',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isActive ? AppColors.tertiary : AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          Text(
            'Recipient: ${share.recipientLabel}',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Token: ${share.shareToken}',
                style: const TextStyle(fontSize: 11, fontFamily: 'monospace', color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              Text(
                'Accesses: ${share.accessCount}/${share.maxAccessLimit}',
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              if (isActive) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecipientSharedViewScreen(shareToken: share.shareToken),
                        ),
                      );
                    },
                    icon: const Icon(Icons.open_in_new_rounded, size: 16),
                    label: const Text('Open Link', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _confirmRevoke(context, share),
                    icon: const Icon(Icons.block_rounded, size: 16, color: Colors.white),
                    label: const Text('Revoke Access', style: TextStyle(color: Colors.white, fontSize: 12)),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
