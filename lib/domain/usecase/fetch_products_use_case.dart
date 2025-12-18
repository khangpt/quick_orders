import 'package:quick_orders/data/services.dart';
import 'package:quick_orders/domain/model/product.dart';

class FetchProductsUseCase {
  late final _services = Services();

  Future<List<Product>> call() async {
    return _services.fetchProducts();
  }
}
