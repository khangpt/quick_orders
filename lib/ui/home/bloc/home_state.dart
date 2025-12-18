import 'package:equatable/equatable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:quick_orders/domain/model/product.dart';

part 'home_state.g.dart';

@CopyWith()
class HomeState extends Equatable {
  const HomeState({this.products = const [], this.carts = const []});

  final List<Product> products;

  final List<Product> carts;

  @override
  List<Object?> get props => [products, carts];

  int get totalInCart => carts.fold(0, (previousValue, element) => previousValue + element.count);
  double get totalPriceInCart => carts.fold(
    0.0,
    (previousValue, element) => previousValue + (element.price ?? 0) * element.count,
  );
}
