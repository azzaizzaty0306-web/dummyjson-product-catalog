import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../data/models/product.dart';
import '../../data/repositories/product_repository.dart';

enum ProductSortOption { none, priceLowToHigh, priceHighToLow, ratingHighToLow }

class ProductController extends ChangeNotifier {

  ProductSortOption _sortOption = ProductSortOption.none;

  ProductSortOption get sortOption => _sortOption;

  final ProductRepository repository;

  ProductController({required this.repository});

  final List<Product> _products = [];
  final Set<int> _favoriteProductIds = {};

  bool isFavorite(int productId) {
    return _favoriteProductIds.contains(productId);
  }

  void toggleFavorite(int productId) {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }

    notifyListeners();
  }

  List<Product> get products {
    final source = _showFavoritesOnly
        ? _products
              .where((product) => _favoriteProductIds.contains(product.id))
              .toList()
        : List<Product>.from(_products);

    switch (_sortOption) {
      case ProductSortOption.priceLowToHigh:
        source.sort((a, b) => a.price.compareTo(b.price));
        break;

      case ProductSortOption.priceHighToLow:
        source.sort((a, b) => b.price.compareTo(a.price));
        break;

      case ProductSortOption.ratingHighToLow:
        source.sort((a, b) => b.rating.compareTo(a.rating));
        break;

      case ProductSortOption.none:
        break;
    }

    return List.unmodifiable(source);
  }

  void setSortOption(ProductSortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  List<Product> get favoriteProducts {
    return products
        .where((product) => _favoriteProductIds.contains(product.id))
        .toList();
  }

  bool _showFavoritesOnly = false;

  bool get showFavoritesOnly => _showFavoritesOnly;

  void toggleFavoritesFilter() {
    _showFavoritesOnly = !_showFavoritesOnly;
    notifyListeners();
  }

  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;

  String? errorMessage;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  Timer? _debounce;

  static const int pageSize = 20;

  Future<void> loadProducts() async {
    isLoading = true;
    errorMessage = null;
    hasMore = true;

    notifyListeners();

    try {
      final result = await repository.getProducts(limit: pageSize, skip: 0);

      _products
        ..clear()
        ..addAll(result);

      hasMore = result.length == pageSize;
    } catch (_) {
      errorMessage = 'Unable to load products. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore || isLoading || !hasMore || _searchQuery.isNotEmpty) {
      return;
    }

    isLoadingMore = true;
    notifyListeners();

    try {
      final result = await repository.getProducts(
        limit: pageSize,
        skip: _products.length,
      );

      _products.addAll(result);

      hasMore = result.length == pageSize;
    } catch (_) {
      // Keep existing products visible if pagination fails.
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    if (_searchQuery.isNotEmpty) {
      await _search(_searchQuery);
      return;
    }

    await loadProducts();
  }

  void onSearchChanged(String value) {
    _searchQuery = value.trim();

    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 450), () {
      if (_searchQuery.isEmpty) {
        loadProducts();
      } else {
        _search(_searchQuery);
      }
    });
  }

  Future<void> _search(String query) async {
    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {
      final result = await repository.searchProducts(query);

      _products
        ..clear()
        ..addAll(result);
    } catch (_) {
      errorMessage = 'Search failed. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
