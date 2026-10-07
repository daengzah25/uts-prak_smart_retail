import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../utils/app_colors.dart';

class _PromoItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> terms;
  bool isExpanded;

  _PromoItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.terms,
    this.isExpanded = false,
  });
}

class PromoTab extends StatefulWidget {
  const PromoTab({super.key});

  @override
  State<PromoTab> createState() => _PromoTabState();
}

class _PromoTabState extends State<PromoTab> {
  final List<_PromoItem> _promos = [
    _PromoItem(
      icon: LucideIcons.ticket,
      title: 'Voucher Diskon 10%',
      subtitle: 'Untuk pembelian elektronik',
      isExpanded: true,
      terms: [
        'Berlaku untuk kategori Elektronik.',
        'Minimal belanja Rp 1.000.000.',
        'Maksimal potongan Rp 500.000 per transaksi.',
        'Tidak dapat digabung dengan voucher lain.',
      ],
    ),
    _PromoItem(
      icon: LucideIcons.tag,
      title: 'Diskon Member',
      subtitle: 'Khusus pelanggan terdaftar',
      terms: [
        'Pelanggan wajib terdaftar sebagai member.',
        'Besar diskon diatur kasir pada form pemesanan.',
        'Diskon maksimal 25% dari harga barang.',
      ],
    ),
    _PromoItem(
      icon: LucideIcons.truck,
      title: 'Gratis Ongkir Reguler',
      subtitle: 'Pengiriman dalam kota',
      terms: [
        'Berlaku untuk kurir Reguler saja.',
        'Minimal belanja Rp 500.000.',
        'Hanya untuk alamat dalam satu kota dengan toko.',
      ],
    ),
    _PromoItem(
      icon: LucideIcons.gift,
      title: 'Bungkus Kado Gratis',
      subtitle: 'Untuk pembelian alat tulis',
      terms: [
        'Berlaku untuk kategori Alat Tulis.',
        'Aktifkan opsi bungkus kado pada form pemesanan.',
        'Persediaan kertas kado terbatas.',
      ],
    ),
  ];

  Widget _buildHeader(_PromoItem promo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: promo.isExpanded
                  ? AppColors.primary
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: promo.isExpanded
                    ? AppColors.primary
                    : AppColors.border,
              ),
            ),
            child: Icon(
              promo.icon,
              size: 20,
              color: promo.isExpanded ? Colors.white : AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  promo.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  promo.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
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

  Widget _buildBody(_PromoItem promo) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(68, 0, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: promo.terms.map((term) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    term,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        dividerColor: AppColors.border,
        animationDuration: const Duration(milliseconds: 300),
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _promos[index].isExpanded = isExpanded;
          });
        },
        children: _promos.map((promo) {
          return ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: promo.isExpanded,
            backgroundColor: AppColors.background,
            headerBuilder: (context, isExpanded) => _buildHeader(promo),
            body: _buildBody(promo),
          );
        }).toList(),
      ),
    );
  }
}
