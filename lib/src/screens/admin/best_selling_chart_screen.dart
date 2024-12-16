// lib/src/screens/admin/best_selling_chart_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../models/order_model.dart';
import 'package:fl_chart/fl_chart.dart';

class BestSellingChartScreen extends StatefulWidget {
  const BestSellingChartScreen({super.key});
  
  @override
  State<BestSellingChartScreen> createState() => _BestSellingChartScreenState();
}

class _BestSellingChartScreenState extends State<BestSellingChartScreen> {
  late Future<List<Map<String, dynamic>>> _bestSellingFuture;

  @override
  void initState() {
    super.initState();
    _bestSellingFuture = Provider.of<AdminProvider>(context, listen: false).getBestSellingProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Best Selling Products'),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _bestSellingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No data available.',
                style: TextStyle(fontSize: 18, color: Colors.white54),
              ),
            );
          } else {
            final bestSelling = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: bestSelling.map((e) => (e['quantity'] as int).toDouble()).reduce((a, b) => a > b ? a : b) + 10,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String productName = bestSelling[groupIndex]['name'] ?? 'Unknown';
                        int quantity = bestSelling[groupIndex]['quantity'] ?? 0;
                        return BarTooltipItem(
                          '$productName\n',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '$quantity sold',
                              style: const TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          String productName = bestSelling[value.toInt()]['name'] ?? 'Unknown';
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              productName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 10,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: bestSelling.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> item = entry.value;
                    double quantity = (item['quantity'] as int).toDouble();
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: quantity,
                          color: Colors.blueAccent,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

// Helper class for chart data
class ProductSales {
  final String productName;
  final int quantitySold;

  ProductSales({required this.productName, required this.quantitySold});
}
