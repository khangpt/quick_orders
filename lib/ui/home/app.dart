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
  late final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc.init();
  }

  @override
  void dispose() {
    _bloc.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Quick Orders'),
        actions: [
          IconButton(
            onPressed: () async {
              final filter = await showModalBottomSheet<String>(
                context: context,
                builder: (context) {
                  return BottomSheet(
                    constraints: BoxConstraints(maxHeight: 350),
                    onClosing: () {},
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          spacing: 12,
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(''),
                              child: Text('All'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop('Pain Relief'),
                              child: Text('Pain Relief'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop('Antibiotic'),
                              child: Text('Antibiotic'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop('Supplement'),
                              child: Text('Supplement'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop('Allergy'),
                              child: Text('Allergy'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
              _bloc.filter(filter);
            },
            icon: Icon(Icons.filter_alt),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(hintText: 'Search by name...'),
              onChanged: (value) => _bloc.search(value),
            ),
          ),
          BlocBuilder<HomeBloc, HomeState>(
            bloc: _bloc,
            buildWhen: (previous, current) => previous.searchings != current.searchings,
            builder: (context, state) {
              if (state.searchings.isEmpty) {
                return SliverToBoxAdapter(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 200),
                      Icon(Icons.shopping_cart_outlined, size: 120, color: Colors.grey.shade300),
                    ],
                  ),
                );
              }

              return SliverList.builder(
                itemCount: state.searchings.length,
                itemBuilder: (context, index) {
                  final p = state.searchings[index];

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
