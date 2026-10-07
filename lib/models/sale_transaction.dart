class SaleTransaction {
  final String id;
  final String date;
  final String product;
  final int qty;
  final int total;
  final bool completed;

  const SaleTransaction({
    required this.id,
    required this.date,
    required this.product,
    required this.qty,
    required this.total,
    required this.completed,
  });
}
