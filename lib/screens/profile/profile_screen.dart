
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/auth_service.dart';
import '../../utils/color_palettes.dart';
import '../../utils/text_styles.dart';
import '../../widgets/app_constants.dart';
import '../auth/login_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color _cardColor = Color(0xFFF5F3FF);

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.isEmpty || parts.first.isEmpty) {
      return 'U';
    }

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';

    const months = [
      'Januari', 'Februari', 'Maret', 'April',
      'Mei', 'Juni', 'Juli', 'Agustus',
      'September', 'Oktober', 'November', 'Desember',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _handleLogout(
  BuildContext context,
  AuthService authService,
) async {
  final shouldLogout = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text(
          'Apakah kamu yakin ingin keluar dari akun BukuBicara?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Keluar'),
          ),
        ],
      );
    },
  );

  if (shouldLogout != true) return;

  try {
    await authService.logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  } catch (e) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gagal logout. Silakan coba lagi.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingNormal),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.oxfordBlue,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.spaceCadet,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  value.isEmpty ? '-' : value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.oxfordBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(
  BuildContext context,
  User user,
  ) {
    final displayName = user.displayName?.trim().isNotEmpty == true
        ? user.displayName!.trim()
        : 'Pengguna BukuBicara';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingNormal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),

          CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.oxfordBlue,
            child: Text(
              _getInitials(displayName),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            displayName,
            textAlign: TextAlign.center,
            style: AppTextStyles.h2.copyWith(
              color: AppColors.oxfordBlue,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            user.email ?? '-',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.spaceCadet,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit Profil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.oxfordBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Informasi Akun',
              style: AppTextStyles.h2.copyWith(
                color: AppColors.oxfordBlue,
              ),
            ),
          ),

          const SizedBox(height: 16),

          _buildInfoCard(
            icon: Icons.person_outline,
            label: 'Nama Lengkap',
            value: displayName,
          ),

          const SizedBox(height: 12),

          _buildInfoCard(
            icon: Icons.email_outlined,
            label: 'Email',
            value: user.email ?? '-',
          ),

          const SizedBox(height: 12),

          _buildInfoCard(
            icon: Icons.fingerprint,
            label: 'User ID',
            value: user.uid,
          ),

          const SizedBox(height: 12),

          _buildInfoCard(
            icon: Icons.calendar_today_outlined,
            label: 'Bergabung Sejak',
            value: _formatDate(user.metadata.creationTime),
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _handleLogout(
                context,
                AuthService(),
              ),
              icon: const Icon(Icons.logout),
              label: const Text('Keluar dari Akun'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red.shade700,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: false,
      ),
      body: StreamBuilder<User?>(
        stream: authService.userChanges,
        initialData: authService.currentUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Gagal memuat informasi profil.'),
            );
          }

          final user = snapshot.data;

          if (user == null) {
            return const Center(
              child: Text('Pengguna belum login.'),
            );
          }

          return _buildProfileContent(context, user);
        },
      ),
    );
  }
}
