import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivapro/features/auth/data/auth_user.dart';
import 'package:vivapro/features/backup/presentation/widgets/backup_settings_section.dart';

class ProfilePage extends StatelessWidget {
  final AuthUser user;

  const ProfilePage(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Profile",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(EvaIcons.moreHorizontalOutline),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, bottom: 35),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            // Profile Header
            _buildProfileHeader(context),
            const SizedBox(height: 32),
        
            // Relationship Health Card
            // _buildHealthCard(context),
            // const SizedBox(height: 32),
        
            // Personal Info Container
            _buildCategoryContainer(
              context,
              title: "PERSONAL INFO",
              children: [
                _buildSettingTile(
                  context,
                  icon: EvaIcons.phoneOutline,
                  title: "Phone Number",
                  subtitle: "+1 (555) 000-1234",
                  onTap: () {},
                ),
                _buildSettingTile(
                  context,
                  icon: EvaIcons.emailOutline,
                  title: "Email Address",
                  subtitle: user.email ?? 'alex.j@connectionapp.com',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
        
            // Call Preferences Container
            _buildCategoryContainer(
              context,
              title: "CALL PREFERENCES",
              children: [
                _buildSwitchTile(
                  context,
                  icon: EvaIcons.bellOutline,
                  title: "Call Reminders",
                  subtitle: "Notify me when it's time to reach out",
                  value: true,
                  onChanged: (v) {},
                ),
                _buildSwitchTile(
                  context,
                  icon: EvaIcons.refreshOutline,
                  title: "Auto-Call Suggestion",
                  subtitle: "Smart triggers for busy days",
                  value: false,
                  onChanged: (v) {},
                ),
              ],
            ),
            const SizedBox(height: 20),
        
            // Privacy & Security Container
            _buildCategoryContainer(
              context,
              title: "PRIVACY & SECURITY",
              children: [
                _buildSettingTile(
                  context,
                  icon: EvaIcons.navigationOutline,
                  title: "Location Sharing",
                  onTap: () {},
                ),
                _buildSettingTile(
                  context,
                  icon: EvaIcons.slashOutline,
                  title: "Blocked Contacts",
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
        
            // Cloud Backup Section
            const BackupSettingsSection(),
            const SizedBox(height: 20),
        
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(EvaIcons.logOutOutline, color: theme.colorScheme.error),
              label: Text(
                'Sign Out',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.error,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error.withValues(alpha: 0.1),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryContainer(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, title),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.withValues(alpha: .2),
              radius: 50,
              backgroundImage: AssetImage('assets/avatars/braid-girl.jpg'),
            ),
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: theme.scaffoldBackgroundColor, width: 3),
              ),
              child: const Icon(EvaIcons.edit, color: Colors.white, size: 16),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          user.displayName ?? 'User Name',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Member since July 2023",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildHealthCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Relationship Health",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "75%",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.75,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Great job! You've reached out to 4 people this week. Keep the momentum going!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Icon(
        icon,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            )
          : null,
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      secondary: Icon(
        icon,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: theme.colorScheme.primary,
      inactiveThumbColor: theme.colorScheme.onSurface.withValues(alpha: 0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20), side: BorderSide.none),
    );
  }
}