import '../models/product.dart';
import '../services/product_api_service.dart';

class ProductRepository {
  final ProductApiService apiService;

  ProductRepository({required this.apiService});

  Future<List<Product>> getProducts({int limit = 20, int skip = 0}) {
    return apiService.getProducts(limit: limit, skip: skip);
  }

  Future<Product> getProduct(int id) {
    return apiService.getProduct(id);
  }

  Future<List<Product>> searchProducts(String query) {
    return apiService.searchProducts(query);
  }
}
