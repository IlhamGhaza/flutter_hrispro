import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constant/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _attendanceReminders = true;
  bool _leaveApprovals = true;
  bool _overtimeApprovals = true;
  bool _companyAnnouncements = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _pushNotifications = prefs.getBool('notif_push') ?? true;
        _emailNotifications = prefs.getBool('notif_email') ?? false;
        _attendanceReminders = prefs.getBool('notif_attendance') ?? true;
        _leaveApprovals = prefs.getBool('notif_leave') ?? true;
        _overtimeApprovals = prefs.getBool('notif_overtime') ?? true;
        _companyAnnouncements = prefs.getBool('notif_company') ?? true;
      });
    }
  }

  Future<void> _saveSetting(String key, bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, val);
    if (mounted) {
      setState(() {
        switch (key) {
          case 'notif_push':
            _pushNotifications = val;
            break;
          case 'notif_email':
            _emailNotifications = val;
            break;
          case 'notif_attendance':
            _attendanceReminders = val;
            break;
          case 'notif_leave':
            _leaveApprovals = val;
            break;
          case 'notif_overtime':
            _overtimeApprovals = val;
            break;
          case 'notif_company':
            _companyAnnouncements = val;
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification Settings',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader('General Notifications'),
          _buildSwitchTile(
            title: 'Push Notifications',
            subtitle: 'Receive push notifications on this device',
            value: _pushNotifications,
            onChanged: (val) => _saveSetting('notif_push', val),
            icon: Icons.notifications_active_outlined,
          ),
          _buildSwitchTile(
            title: 'Email Notifications',
            subtitle: 'Receive updates via email',
            value: _emailNotifications,
            onChanged: (val) => _saveSetting('notif_email', val),
            icon: Icons.email_outlined,
          ),
          const Divider(height: 32),
          _buildSectionHeader('Attendance & Requests'),
          _buildSwitchTile(
            title: 'Check-in Reminders',
            subtitle: 'Get reminded to check in/out',
            value: _attendanceReminders,
            onChanged: (val) => _saveSetting('notif_attendance', val),
            icon: Icons.access_time_rounded,
          ),
          _buildSwitchTile(
            title: 'Leave Approvals',
            subtitle: 'Updates when your leave is approved or rejected',
            value: _leaveApprovals,
            onChanged: (val) => _saveSetting('notif_leave', val),
            icon: Icons.beach_access_outlined,
          ),
          _buildSwitchTile(
            title: 'Overtime Approvals',
            subtitle: 'Updates on your overtime requests',
            value: _overtimeApprovals,
            onChanged: (val) => _saveSetting('notif_overtime', val),
            icon: Icons.work_history_outlined,
          ),
          const Divider(height: 32),
          _buildSectionHeader('Company'),
          _buildSwitchTile(
            title: 'Announcements',
            subtitle: 'Important company-wide announcements',
            value: _companyAnnouncements,
            onChanged: (val) => _saveSetting('notif_company', val),
            icon: Icons.campaign_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 4.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        secondary: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        activeTrackColor: AppColors.primary,
        inactiveThumbColor: Colors.grey.shade400,
        inactiveTrackColor: Colors.grey.shade200,
      ),
    );
  }
}
