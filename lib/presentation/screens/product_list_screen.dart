import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/product_controller.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 300) {
      context.read<ProductController>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProductController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
        actions: [
          IconButton(
            tooltip: controller.showFavoritesOnly
                ? 'Show all products'
                : 'Show favorites only',
            onPressed: controller.toggleFavoritesFilter,
            icon: Icon(
              controller.showFavoritesOnly
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),
          ),

          PopupMenuButton<ProductSortOption>(
            tooltip: 'Sort products',
            initialValue: controller.sortOption,
            onSelected: controller.setSortOption,
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: ProductSortOption.none,
                  child: Text('Default'),
                ),
                PopupMenuItem(
                  value: ProductSortOption.priceLowToHigh,
                  child: Text('Price: Low to High'),
                ),
                PopupMenuItem(
                  value: ProductSortOption.priceHighToLow,
                  child: Text('Price: High to Low'),
                ),
                PopupMenuItem(
                  value: ProductSortOption.ratingHighToLow,
                  child: Text('Rating: High to Low'),
                ),
              ];
            },
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                controller.onSearchChanged(value);
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        tooltip: 'Clear search',
                        onPressed: () {
                          _searchController.clear();
                          controller.onSearchChanged('');
                          setState(() {});
                        },
                        icon: const Icon(Icons.close),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Expanded(child: _buildContent(controller)),
        ],
      ),
    );
  }

  Widget _buildContent(ProductController controller) {
    if (controller.isLoading && controller.products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage != null && controller.products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 12),
              Text(controller.errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  if (controller.searchQuery.isNotEmpty) {
                    controller.onSearchChanged(controller.searchQuery);
                  } else {
                    controller.loadProducts();
                  }
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (controller.products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 48),
            SizedBox(height: 12),
            Text('No products found'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount:
            controller.products.length + (controller.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= controller.products.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final product = controller.products[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ProductCard(
              product: product,
              isFavorite: controller.isFavorite(product.id),
              onFavoriteTap: () {
                controller.toggleFavorite(product.id);
              },
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(productId: product.id),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
