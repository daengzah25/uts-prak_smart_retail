import 'package:flutter/material.dart';

class Product {
  final String name;
  final String category;
  final int price;
  final int discount;
  final int stock;
  final IconData icon;

  const Product({
    required this.name,
    required this.category,
    required this.price,
    required this.discount,
    required this.stock,
    required this.icon,
  });

  int get finalPrice => price - ((price * discount) ~/ 100);
}
