import 'package:flutter/material.dart';
import 'package:vivapro/core/navigation/swipe_back_navigation.dart';

/// Demo page showcasing the swipe-back navigation feature.
class SwipeBackDemoPage extends StatelessWidget {
  const SwipeBackDemoPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Swipe-Back Navigation Demo'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(theme),
          const SizedBox(height: 24),
          _buildDemoCard(
            context,
            theme,
            title: 'Default Configuration',
            description: 'Standard swipe-back with default settings',
            onTap: () => _pushDemoPage(context, 'Default', const SwipeBackConfig()),
          ),
          const SizedBox(height: 16),
          _buildDemoCard(
            context,
            theme,
            title: 'High Threshold (50%)',
            description: 'Requires more swipe distance to commit',
            onTap: () => _pushDemoPage(
              context,
              'High Threshold',
              const SwipeBackConfig(popThreshold: 0.5),
            ),
          ),
          const SizedBox(height: 16),
          _buildDemoCard(
            context,
            theme,
            title: 'Low Threshold (20%)',
            description: 'Easier to trigger back navigation',
            onTap: () => _pushDemoPage(
              context,
              'Low Threshold',
              const SwipeBackConfig(popThreshold: 0.2),
            ),
          ),
          const SizedBox(height: 16),
          _buildDemoCard(
            context,
            theme,
            title: 'Wide Edge (40px)',
            description: 'Larger area to start the swipe',
            onTap: () => _pushDemoPage(
              context,
              'Wide Edge',
              const SwipeBackConfig(edgeWidth: 40),
            ),
          ),
          const SizedBox(height: 16),
          _buildDemoCard(
            context,
            theme,
            title: 'No Shadow',
            description: 'Cleaner look without edge shadow',
            onTap: () => _pushDemoPage(
              context,
              'No Shadow',
              const SwipeBackConfig(showShadow: false),
            ),
          ),
          const SizedBox(height: 16),
          _buildDemoCard(
            context,
            theme,
            title: 'Disabled',
            description: 'Swipe-back gesture is disabled',
            onTap: () => _pushDemoPage(
              context,
              'Disabled',
              const SwipeBackConfig(enabled: false),
            ),
          ),
          const SizedBox(height: 24),
          _buildInstructions(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '👆 Bidirectional Swipe-Back',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Android predictive back style - swipe from left OR right edge',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoCard(
    BuildContext context,
    ThemeData theme, {
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.swipe,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructions(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'How to Use',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInstructionItem('Swipe from LEFT or RIGHT edge to peek'),
          _buildInstructionItem('Continue swiping past threshold to go back'),
          _buildInstructionItem('Fast swipes complete regardless of distance'),
          _buildInstructionItem('Release early to cancel and stay on page'),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  void _pushDemoPage(BuildContext context, String title, SwipeBackConfig config) {
    Navigator.of(context).pushSwipeBack(
      builder: (context) => _DemoDetailPage(title: title, config: config),
      config: config,
    );
  }
}

/// Detail page for demonstrating the swipe-back behavior.
class _DemoDetailPage extends StatelessWidget {
  final String title;
  final SwipeBackConfig config;

  const _DemoDetailPage({
    required this.title,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.swipe,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Swipe from either edge',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Try swiping from the left or right edge to peek at the previous page',
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                _buildConfigInfo(theme),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushSwipeBack(
                      builder: (context) => _DemoDetailPage(
                        title: '$title (Nested)',
                        config: config,
                      ),
                      config: config,
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Push Another Page'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfigInfo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configuration',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildConfigRow('Pop Threshold', '${(config.popThreshold * 100).toInt()}%'),
          _buildConfigRow('Edge Width', '${config.edgeWidth.toInt()}px'),
          _buildConfigRow('Velocity Threshold', '${config.velocityThreshold.toInt()}px/s'),
          _buildConfigRow('Show Shadow', config.showShadow ? 'Yes' : 'No'),
          _buildConfigRow('Enabled', config.enabled ? 'Yes' : 'No'),
        ],
      ),
    );
  }

  Widget _buildConfigRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
