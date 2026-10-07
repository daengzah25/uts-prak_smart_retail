class SummaryLine {
  final String label;
  final int amount;

  const SummaryLine(this.label, this.amount);
}

class OrderSummary {
  final String productName;
  final String courier;
  final String pickupSchedule;
  final bool dropship;
  final bool giftWrap;
  final List<SummaryLine> lines;

  const OrderSummary({
    required this.productName,
    required this.courier,
    required this.pickupSchedule,
    required this.dropship,
    required this.giftWrap,
    required this.lines,
  });

  int get total => lines.fold(0, (sum, line) => sum + line.amount);
}
