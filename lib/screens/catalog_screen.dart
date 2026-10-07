import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'product_tab.dart';
import 'promo_tab.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            indicatorColor: AppColors.primary,
            dividerColor: AppColors.border,
            indicatorWeight: 2.5,
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(fontSize: 14),
            tabs: [
              Tab(text: 'Produk'),
              Tab(text: 'Ketentuan Promo'),
            ],
          ),
          const Expanded(
            child: TabBarView(
              children: [
                ProductTab(),
                PromoTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
