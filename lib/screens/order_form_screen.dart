import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../models/order_summary.dart';
import '../models/product.dart';
import '../utils/app_colors.dart';
import '../utils/format.dart';
import 'order_summary_sheet.dart';
import 'order_confirm_dialog.dart';
import '../data/transaction_data.dart';
import '../models/sale_transaction.dart';

class OrderFormScreen extends StatefulWidget {
  final Product product;

  const OrderFormScreen({super.key, required this.product});

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  static const List<(String, String, int, IconData)> _couriers = [
    ('Reguler', '2-4 hari kerja', 15000, LucideIcons.truck),
    ('Kargo', '5-7 hari kerja', 50000, LucideIcons.package),
    ('Instan', 'Tiba hari ini', 30000, LucideIcons.zap),
  ];

  static const List<(String, int)> _extras = [
    ('Asuransi Pengiriman', 15000),
    ('Bubble Wrap Ekstra', 5000),
    ('Packing Kayu', 25000),
  ];

  static const double _minDiscount = 0;
  static const double _maxDiscount = 25;
  static const int _giftWrapCost = 10000;

  String _courier = 'Reguler';
  final Set<String> _selectedExtras = {};
  DateTime? _pickupDate;
  TimeOfDay? _pickupTime;
  double _memberDiscount = 0;
  bool _dropship = false;
  bool _giftWrap = false;

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    final day = d.day.toString().padLeft(2, '0');
    return '$day ${months[d.month - 1]} ${d.year}';
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h.$m';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _pickupDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() => _pickupDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _pickupTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _pickupTime = picked);
    }
  }

  OrderSummary _buildSummary() {
    final product = widget.product;
    final courierItem = _couriers.firstWhere((c) => c.$1 == _courier);
    final percent = _memberDiscount.round();
    final memberDiscountAmount = (product.finalPrice * percent) ~/ 100;

    final lines = <SummaryLine>[
      SummaryLine(product.name, product.finalPrice),
      if (memberDiscountAmount > 0)
        SummaryLine('Diskon member $percent%', -memberDiscountAmount),
      SummaryLine('Pengiriman ${courierItem.$1}', courierItem.$3),
      for (final extra in _extras)
        if (_selectedExtras.contains(extra.$1))
          SummaryLine(extra.$1, extra.$2),
      if (_giftWrap) const SummaryLine('Bungkus kado khusus', _giftWrapCost),
    ];

    final date = _pickupDate == null ? '-' : _formatDate(_pickupDate!);
    final time = _pickupTime == null ? '-' : _formatTime(_pickupTime!);

    return OrderSummary(
      productName: product.name,
      courier: courierItem.$1,
      pickupSchedule: '$date, $time',
      dropship: _dropship,
      giftWrap: _giftWrap,
      lines: lines,
    );
  }

  Future<void> _processTransaction() async {
    if (_pickupDate == null || _pickupTime == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Pilih tanggal dan jam pengambilan dulu'),
          ),
        );
      return;
    }

    final summary = _buildSummary();
    final confirmed = await showOrderSummarySheet(context, summary);
    if (!mounted || confirmed != true) return;

    final approved = await showOrderConfirmDialog(context, summary.total);
    if (!mounted || approved != true) return;

    final nextNumber = transactionHistory.length + 1;
    final result = SaleTransaction(
      id: 'TRX-${nextNumber.toString().padLeft(3, '0')}',
      date: _formatDate(DateTime.now()),
      product: widget.product.name,
      qty: 1,
      total: summary.total,
      completed: false,
    );
    Navigator.pop(context, result);
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildProductCard() {
    final product = widget.product;
    return Container(
      padding: const EdgeInsets.all(16),
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
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(product.icon, size: 26, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${product.category}  •  Stok ${product.stock}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      formatRupiah(product.finalPrice),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    if (product.discount > 0) ...[
                      const SizedBox(width: 8),
                      Text(
                        formatRupiah(product.price),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _tileDecoration(bool selected) {
    return BoxDecoration(
      color: selected
          ? AppColors.primary.withValues(alpha: 0.06)
          : AppColors.background,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: selected ? AppColors.primary : AppColors.border,
        width: selected ? 1.5 : 1,
      ),
    );
  }

  Widget _courierTile((String, String, int, IconData) item) {
    final selected = _courier == item.$1;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: _tileDecoration(selected),
        child: RadioListTile<String>(
          value: item.$1,
          activeColor: AppColors.primary,
          controlAffinity: ListTileControlAffinity.trailing,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          secondary: Icon(
            item.$4,
            size: 22,
            color: selected ? AppColors.primary : AppColors.textMuted,
          ),
          title: Text(
            item.$1,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '${item.$2}  •  ${formatRupiah(item.$3)}',
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ),
      ),
    );
  }

  Widget _extraTile((String, int) item) {
    final selected = _selectedExtras.contains(item.$1);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: _tileDecoration(selected),
        child: CheckboxListTile(
          value: selected,
          activeColor: AppColors.primary,
          controlAffinity: ListTileControlAffinity.trailing,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          checkboxShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          onChanged: (checked) {
            setState(() {
              if (checked == true) {
                _selectedExtras.add(item.$1);
              } else {
                _selectedExtras.remove(item.$1);
              }
            });
          },
          title: Text(
            item.$1,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '+ ${formatRupiah(item.$2)}',
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ),
      ),
    );
  }

  Widget _pickerField({
    required IconData icon,
    required String label,
    required String placeholder,
    required String? value,
    required VoidCallback onTap,
  }) {
    final hasValue = value != null;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: _tileDecoration(hasValue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: hasValue ? AppColors.primary : AppColors.textMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value ?? placeholder,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                  color: hasValue ? AppColors.textDark : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiscountSlider() {
    final active = _memberDiscount > 0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: _tileDecoration(active),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Row(
                children: [
                  Icon(LucideIcons.tag, size: 18, color: AppColors.textMuted),
                  SizedBox(width: 8),
                  Text(
                    'Diskon Member',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                '${_memberDiscount.round()}%',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: active ? AppColors.accent : AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.border,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withValues(alpha: 0.12),
              activeTickMarkColor: Colors.white,
              inactiveTickMarkColor: AppColors.textMuted,
              valueIndicatorColor: AppColors.primary,
              trackHeight: 4,
            ),
            child: Slider(
              value: _memberDiscount,
              min: _minDiscount,
              max: _maxDiscount,
              divisions: 5,
              label: '${_memberDiscount.round()}%',
              onChanged: (value) {
                setState(() => _memberDiscount = value);
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '0%',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                Text(
                  '25%',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: _tileDecoration(value),
        child: SwitchListTile(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: AppColors.primary,
          inactiveTrackColor: AppColors.border,
          inactiveThumbColor: Colors.white,
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          secondary: Icon(
            icon,
            size: 22,
            color: value ? AppColors.primary : AppColors.textMuted,
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final total = _buildSummary().total;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Total pembayaran',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatRupiah(total),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 190,
                child: ElevatedButton(
                  onPressed: _processTransaction,
                  child: const Text('Proses Transaksi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Form Pemesanan'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductCard(),
            _sectionTitle('Metode Pengiriman'),
            RadioGroup<String>(
              groupValue: _courier,
              onChanged: (value) {
                if (value != null) setState(() => _courier = value);
              },
              child: Column(
                children: _couriers.map(_courierTile).toList(),
              ),
            ),
            _sectionTitle('Layanan Ekstra'),
            Column(
              children: _extras.map(_extraTile).toList(),
            ),
            _sectionTitle('Jadwal Pengambilan'),
            Row(
              children: [
                _pickerField(
                  icon: LucideIcons.calendar,
                  label: 'Tanggal',
                  placeholder: 'Pilih tanggal',
                  value:
                      _pickupDate == null ? null : _formatDate(_pickupDate!),
                  onTap: _pickDate,
                ),
                const SizedBox(width: 12),
                _pickerField(
                  icon: LucideIcons.clock,
                  label: 'Jam',
                  placeholder: 'Pilih jam',
                  value:
                      _pickupTime == null ? null : _formatTime(_pickupTime!),
                  onTap: _pickTime,
                ),
              ],
            ),
            _sectionTitle('Penyesuaian Tambahan'),
            _buildDiscountSlider(),
            _switchTile(
              icon: LucideIcons.userRound,
              title: 'Kirim sebagai Dropship',
              subtitle: 'Sembunyikan identitas pengirim',
              value: _dropship,
              onChanged: (v) => setState(() => _dropship = v),
            ),
            _switchTile(
              icon: LucideIcons.gift,
              title: 'Bungkus Kado Khusus',
              subtitle: '+ ${formatRupiah(_giftWrapCost)}',
              value: _giftWrap,
              onChanged: (v) => setState(() => _giftWrap = v),
            ),
          ],
        ),
      ),
    );
  }
}
