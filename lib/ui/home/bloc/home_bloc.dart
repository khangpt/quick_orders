import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_orders/domain/model/product.dart';
import 'package:quick_orders/domain/usecase/fetch_products_use_case.dart';
import 'package:quick_orders/ui/home/bloc/home_state.dart';

class HomeBloc extends Cubit<HomeState> {
  HomeBloc() : super(HomeState());

  late final _fetchProductsUseCase = FetchProductsUseCase();

  void init() async {
    final response = await _fetchProductsUseCase();
    emit(state.copyWith(products: response));
  }

  void addToCart(Product p) {
    print('+++ add to cart:');
    print('+++ product: $p:');
    print('+++ carts: ${state.carts}');
    if (state.carts.any((element) => element.id == p.id)) {
      var item = state.carts.firstWhereOrNull((element) => element.id == p.id);
      item = item!.copyWith(count: item.count + 1);
      final newCarts = state.carts.toList()..removeWhere((element) => element.id == item!.id);
      emit(state.copyWith(carts: [item, ...newCarts]));
    } else {
      emit(state.copyWith(carts: [...state.carts, p.copyWith(count: 1)]));
    }
  }

  void removeFromCart(Product p) {
    if (state.carts.any((element) => element.id == p.id)) {
      var item = state.carts.firstWhereOrNull((element) => element.id == p.id);
      item = item!.copyWith(count: item.count - 1);
      if (item.count == 0) {
        final newCarts = state.carts.toList()..removeWhere((element) => element.id == item!.id);
        emit(state.copyWith(carts: newCarts));
      } else {
        final newCarts = state.carts.toList()..removeWhere((element) => element.id == item!.id);
        emit(state.copyWith(carts: [item, ...newCarts]));
      }
    }
  }
}
