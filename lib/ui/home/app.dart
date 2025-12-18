import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quick_orders/ui/home/bloc/home_bloc.dart';
import 'package:quick_orders/ui/home/bloc/home_state.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final _bloc = HomeBloc();

  @override
  void initState() {
    super.initState();
    _bloc.init();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Quick Orders'),
      ),
      body: CustomScrollView(
        slivers: [
          BlocBuilder<HomeBloc, HomeState>(
            bloc: _bloc,
            buildWhen: (previous, current) => previous.products != current.products,
            builder: (context, state) {
              return SliverList.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final p = state.products[index];

                  return Padding(
                    padding: EdgeInsets.all(12),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.shade300, blurRadius: 2, spreadRadius: 1),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text(p.name ?? '---'), Text(p.category ?? '---')],
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    if (p.isPrescription)
                                      Icon(Icons.edit_document, size: 20, color: Colors.orange),
                                    Text(NumberFormat.currency(locale: 'vi').format(p.price)),
                                  ],
                                ),

                                ///
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => _bloc.removeFromCart(p),
                                      icon: Text('-', style: TextStyle(fontSize: 20)),
                                    ),
                                    IconButton(
                                      onPressed: () => _bloc.addToCart(p),
                                      iconSize: 10,
                                      icon: Text('+', style: TextStyle(fontSize: 20)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
        bloc: _bloc,
        buildWhen: (previous, current) => previous.carts != current.carts,
        builder: (context, state) {
          return ColoredBox(
            color: Colors.white,
            child: SizedBox(
              height: 110,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total in cart: ${state.totalInCart}'),
                    Text(
                      'Total price in cart: ${NumberFormat.currency(locale: 'vi').format(state.totalPriceInCart)}',
                    ),
                    SizedBox(height: 4),
                    Expanded(
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final item = state.carts[index];

                          return Column(
                            children: [
                              Text('${item.name}'),
                              Text('${item.count}', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(width: 12),
                        itemCount: state.carts.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
