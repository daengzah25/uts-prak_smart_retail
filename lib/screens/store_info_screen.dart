import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../utils/app_colors.dart';

class StoreInfoScreen extends StatelessWidget {
  const StoreInfoScreen({super.key});

  static const String _licenseCode = 'SRP-2026-ID-0481-XK92';

  Future<void> _copyLicense(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: _licenseCode));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Kode lisensi disalin')),
      );
  }

  Widget _buildProfile() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              LucideIcons.store,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  'SmartRetail Store',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                SelectableText(
                  'Perlengkapan kantor dan elektronik',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.textMuted),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 3),
                SelectableText(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLicense(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(LucideIcons.badgeCheck, size: 18, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Kode Lisensi Resmi',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(
                child: SelectableText(
                  _licenseCode,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _copyLicense(context),
                tooltip: 'Salin kode',
                icon: const Icon(
                  LucideIcons.copy,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Tekan dan tahan teks untuk menyalin sebagian',
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfile(),
          const SizedBox(height: 16),
          _buildLicense(context),
          const SizedBox(height: 12),
          _infoRow(
            LucideIcons.mapPin,
            'Alamat',
            'Jl. Merdeka No. 45, Subang, Jawa Barat 41211',
          ),
          const Divider(),
          _infoRow(
            LucideIcons.clock,
            'Jam Operasional',
            'Senin - Sabtu, 08.00 - 20.00 WIB',
          ),
          const Divider(),
          _infoRow(
            LucideIcons.phone,
            'Telepon',
            '(0260) 555-0123',
          ),
          const Divider(),
          _infoRow(
            LucideIcons.mail,
            'Email',
            'halo@smartretail.com',
          ),
        ],
      ),
    );
  }
}
