import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog/data/models/product.dart';

void main() {
  test('Product.fromJson parses product data correctly', () {
    final json = {
      'id': 1,
      'title': 'Test Product',
      'description': 'Test Description',
      'price': 99.99,
      'rating': 4.5,
      'thumbnail': 'https://example.com/image.jpg',
      'images': ['https://example.com/1.jpg', 'https://example.com/2.jpg'],
    };

    final product = Product.fromJson(json);

    expect(product.id, 1);
    expect(product.title, 'Test Product');
    expect(product.description, 'Test Description');
    expect(product.price, 99.99);
    expect(product.rating, 4.5);
    expect(product.thumbnail, 'https://example.com/image.jpg');
    expect(product.images.length, 2);
  });
}
