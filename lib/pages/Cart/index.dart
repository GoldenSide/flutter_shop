import 'package:flutter/material.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('购物车'),
      ),
      body: const _CartBody(),
    );
  }
}

class _CartBody extends StatelessWidget {
  const _CartBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: Text('商品 ${index + 1}'),
                  subtitle: const Text('规格：默认，数量：1'),
                  trailing: const Text('¥99'),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8.0,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('共 5 件商品', style: TextStyle(fontSize: 16.0)),
              ElevatedButton(
                onPressed: () {},
                child: const Text('去结算'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
