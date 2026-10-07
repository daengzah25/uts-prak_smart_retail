import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../data/transaction_data.dart';
import '../models/sale_transaction.dart';
import '../utils/app_colors.dart';
import '../utils/format.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Widget _summaryCard(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(bool completed) {
    final color = completed ? AppColors.success : AppColors.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        completed ? 'Selesai' : 'Diproses',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  DataRow _buildRow(SaleTransaction trx) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            trx.id,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        DataCell(Text(trx.date)),
        DataCell(Text(trx.product)),
        DataCell(Text('${trx.qty}')),
        DataCell(
          Text(
            formatRupiah(trx.total),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        DataCell(_statusBadge(trx.completed)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalSales =
        transactionHistory.fold<int>(0, (sum, trx) => sum + trx.total);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Row(
              children: [
                _summaryCard(
                  LucideIcons.receipt,
                  'Total Transaksi',
                  '${transactionHistory.length}',
                ),
                const SizedBox(width: 12),
                _summaryCard(
                  LucideIcons.wallet,
                  'Total Penjualan',
                  formatRupiah(totalSales),
                ),
              ],
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    headingRowColor:
                        WidgetStateProperty.all(AppColors.surface),
                    headingRowHeight: 48,
                    dataRowMinHeight: 56,
                    dataRowMaxHeight: 56,
                    horizontalMargin: 20,
                    columnSpacing: 28,
                    headingTextStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                    dataTextStyle: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textDark,
                    ),
                    border: const TableBorder(
                      top: BorderSide(color: AppColors.border),
                      bottom: BorderSide(color: AppColors.border),
                      horizontalInside: BorderSide(color: AppColors.border),
                    ),
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Tanggal')),
                      DataColumn(label: Text('Produk')),
                      DataColumn(label: Text('Jml'), numeric: true),
                      DataColumn(label: Text('Total'), numeric: true),
                      DataColumn(label: Text('Status')),
                    ],
                    rows: transactionHistory.map(_buildRow).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
