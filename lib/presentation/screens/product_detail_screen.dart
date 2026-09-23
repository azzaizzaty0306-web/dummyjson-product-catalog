import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/product.dart';
import '../../data/repositories/product_repository.dart';
import '../controllers/product_controller.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? product;
  String? errorMessage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _loadProduct();
  }

  Future<void> _loadProduct() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final repository = context.read<ProductRepository>();

      final result = await repository.getProduct(widget.productId);

      if (!mounted) return;

      setState(() {
        product = result;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Unable to load product details.';
      });
    } finally {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(errorMessage!),
              const SizedBox(height: 12),
              FilledButton(onPressed: _loadProduct, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    final item = product!;
    final controller = context.watch<ProductController>();
    final isFavorite = controller.isFavorite(item.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            onPressed: () {
              controller.toggleFavorite(item.id);
            },
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 280,
            child: item.images.isEmpty
                ? const Center(
                    child: Icon(Icons.image_not_supported_outlined, size: 64),
                  )
                : PageView.builder(
                    itemCount: item.images.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        item.images[index],
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) {
                            return child;
                          }

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.broken_image_outlined, size: 64),
                          );
                        },
                      );
                    },
                  ),
          ),
          const SizedBox(height: 24),
          Text(item.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(
            '\$${item.price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.star),
              const SizedBox(width: 6),
              Text(item.rating.toStringAsFixed(1)),
            ],
          ),
          const SizedBox(height: 24),
          Text('Description', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(item.description),
        ],
      ),
    );
  }
}
