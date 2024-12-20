// lib/src/widgets/custom_search_bar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/voice_service.dart';
import '../services/barcode_service.dart';
import '../providers/search_provider.dart';
import '../providers/products_provider.dart';
import '../models/product_model.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final VoiceService _voiceService = VoiceService();
  final BarcodeService _barcodeService = BarcodeService();

  bool _isVoiceListening = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Function to handle text search submission
  void _onSearchSubmitted(String query, List<ProductModel> products) {
    if (query.trim().isEmpty) return;

    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider.searchByText(products, query.trim()).then((_) {
      Navigator.pushNamed(
        context,
        '/search_results',
        // Removed arguments
      );
    });
  }

  // Function to handle voice search
  Future<void> _handleVoiceSearch(List<ProductModel> products) async {
    setState(() {
      _isVoiceListening = true;
    });

    String? query = await _voiceService.listen();

    setState(() {
      _isVoiceListening = false;
    });

    if (query != null && query.trim().isNotEmpty) {
      _searchController.text = query.trim();

      final searchProvider = Provider.of<SearchProvider>(context, listen: false);
      searchProvider.searchByText(products, query.trim()).then((_) {
        Navigator.pushNamed(
          context,
          '/search_results',
          // Removed arguments
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No speech detected. Please try again.')),
      );
    }
  }

  // Function to handle barcode scanning
  Future<void> _handleBarcodeScan(List<ProductModel> products) async {
  // Scan QR or barcode
  String barcode = await _barcodeService.scanBarcode();

  if (barcode != '-1') { // '-1' indicates cancellation
    // Insert the scanned QR code text into the search bar
    _searchController.text = barcode.trim();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('QR Code: $barcode')),
    );
    // Optionally trigger a search (if needed)
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider.searchByText(products, barcode.trim()).then((_) {
      Navigator.pushNamed(
        context,
        '/search_results',
        // Removed arguments
      );
    });
  } else {
    // Handle cancellation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Barcode scan cancelled.')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final List<ProductModel> products = productsProvider.products;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.black, // Match the background color
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: const TextStyle(color: Colors.white54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[800],
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Voice Search Button
              IconButton(
                icon: _isVoiceListening
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.0,
                        ),
                      )
                    : const Icon(Icons.mic, color: Colors.white),
                onPressed: _isVoiceListening
                    ? null
                    : () => _handleVoiceSearch(products),
                tooltip: 'Voice Search',
              ),
              // Barcode Scan Button
              IconButton(
                icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                onPressed: () => _handleBarcodeScan(products),
                tooltip: 'Scan Barcode',
              ),
              // Clear Search Button
              IconButton(
                icon: const Icon(Icons.clear, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                  });
                },
                tooltip: 'Clear Search',
              ),
            ],
          ),
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: (value) => _onSearchSubmitted(value, products),
      ),
    );
  }
}
