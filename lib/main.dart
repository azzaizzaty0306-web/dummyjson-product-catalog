import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/product_repository.dart';
import 'data/services/product_api_service.dart';
import 'presentation/controllers/product_controller.dart';
import 'presentation/screens/product_list_screen.dart';

void main() {
  final apiService = ProductApiService();

  final repository = ProductRepository(apiService: apiService);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final ProductRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ProductRepository>.value(value: repository),
        ChangeNotifierProvider(
          create: (_) =>
              ProductController(repository: repository)..loadProducts(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Product Catalog',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
          cardTheme: CardThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        home: const ProductListScreen(),
      ),
    );
  }
}
