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
    emit(state.copyWith(products: response, searchings: response));
  }

  void addToCart(Product p) {
    if (state.carts.any((element) => element.id == p.id)) {
      var item = state.carts.firstWhereOrNull((element) => element.id == p.id);
      item = item!.copyWith(count: (item.count + 1).clamp(0, 99));
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

  void search(String key) {
    if (key.isEmpty) {
      emit(state.copyWith(searchings: state.products));
      return;
    }

    final result = state.products.where((element) {
      return element.name?.toUpperCase().contains(key.toUpperCase()) ??
          false || key.toUpperCase().contains(element.name?.toUpperCase() ?? '');
    }).toList();

    emit(state.copyWith(searchings: result));
  }

  void filter(String? filter) {
    if (filter?.isEmpty ?? true) {
      emit(state.copyWith(searchings: state.products));
      return;
    }

    final result = state.products.where((element) {
      return element.category?.toUpperCase() == filter?.toUpperCase();
    }).toList();

    emit(state.copyWith(searchings: result));
  }
}
