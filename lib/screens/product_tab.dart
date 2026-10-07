import 'order_form_screen.dart';
import '../data/transaction_data.dart';
import '../models/sale_transaction.dart';
import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/product.dart';
import '../utils/app_colors.dart';
import '../utils/format.dart';

class ProductTab extends StatelessWidget {
  const ProductTab({super.key});

  Widget _buildImage(Product product) {
    final soldOut = product.stock == 0;
    final hasBadge = soldOut || product.discount > 0;

    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(
              product.icon,
              size: 28,
              color: soldOut ? AppColors.textMuted : AppColors.primary,
            ),
          ),
          if (hasBadge)
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: soldOut ? AppColors.textMuted : AppColors.accent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  soldOut ? 'Habis' : '-${product.discount}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _onOrder(BuildContext context, Product product) async {
    final result = await Navigator.push<SaleTransaction>(
      context,
      MaterialPageRoute(
        builder: (context) => OrderFormScreen(product: product),
      ),
    );

    if (result == null || !context.mounted) return;

    transactionHistory.insert(0, result);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Transaksi ${result.id} berhasil diproses'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: dummyProducts.length,
      itemBuilder: (context, index) {
        final product = dummyProducts[index];
        final soldOut = product.stock == 0;

        return Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              leading: _buildImage(product),
              title: Text(
                product.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${product.category}  •  ${soldOut ? 'Stok habis' : 'Stok ${product.stock}'}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          formatRupiah(product.finalPrice),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        if (product.discount > 0) ...[
                          const SizedBox(width: 6),
                          Text(
                            formatRupiah(product.price),
                            style: const TextStyle(
                              fontSize: 11,
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
              trailing: ElevatedButton(
                onPressed: soldOut ? null : () => _onOrder(context, product),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(72, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Pesan'),
              ),
            ),
            const Divider(indent: 20, endIndent: 20),
          ],
        );
      },
    );
  }
}
