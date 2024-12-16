// lib/src/screens/admin/reports_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../models/order_model.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});
  
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String _errorMessage = '';
  DateTime _selectedDate = DateTime.now();

  // Fetch all orders initially
  Future<void> _fetchAllOrders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      final orders = await adminProvider.getAllOrders();
      setState(() {
        _orders = orders;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch orders: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fetch orders based on selected date
  Future<void> _fetchOrdersByDate() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      final orders = await adminProvider.getOrdersByDate(_selectedDate);
      setState(() {
        _orders = orders;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch orders by date: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  void initState() {
    super.initState();
    _fetchAllOrders();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Order Histories'),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date Selection Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Selected Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.dark(),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null && picked != _selectedDate) {
                      setState(() {
                        _selectedDate = picked;
                      });
                      await _fetchOrdersByDate();
                    }
                  },
                  child: const Text('Select Date'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : _errorMessage.isNotEmpty
                    ? Center(
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      )
                    : _orders.isEmpty
                        ? const Center(
                            child: Text(
                              'No orders found.',
                              style: TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: _orders.length,
                              itemBuilder: (context, index) {
                                final order = _orders[index];
                                return Card(
                                  color: Colors.grey[900],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  child: ExpansionTile(
                                    title: Text(
                                      'Order ID: ${order.id}',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      'User ID: ${order.userId}\nTotal: \$${order.total.toStringAsFixed(2)}',
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                    children: order.items.map((item) {
                                      return ListTile(
                                        title: Text(
                                          'Product ID: ${item.productId}',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        trailing: Text(
                                          'Quantity: ${item.quantity}',
                                          style: const TextStyle(color: Colors.white70),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
                            ),
                          ),
          ],
        ),
      ),
    );
  }
}
