import 'package:flutter/material.dart';
import 'package:omsnepal/screens/checkout/arguments.dart';
import 'package:omsnepal/services/orders/orderState.dart';
import 'package:omsnepal/services/theme.dart';
import 'package:omsnepal/widgets/widgets.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as CheckoutArgument?;
    final OrderState _orderState = Provider.of<OrderState>(context);
    final bool _isDark = Theme.of(context).brightness == Brightness.dark;
    final Color _textColor = _isDark ? Colors.white : Colors.grey.shade800;
    final Color _bgColor =
        _isDark ? Theme.of(context).primaryColor : Colors.white;
    final bool _forShipping = args == null;
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: SecondaryAppBar(
        textColor: _textColor,
        bgColor: _bgColor,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          PageTitle(
            title: 'Checkout',
            icon: Icons.check_circle_outline,
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              child: ListView.builder(
                  itemCount: _orderState.orders.length,
                  itemBuilder: (context, index) {
                    final item = _orderState.orders[index];
                    return ListTile(
                      title: Text(
                        item.product.title ?? '',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: _isDark
                                ? Colors.grey.shade200
                                : LIGHT_TEXT_COLOR_NORMAL),
                      ),
                      subtitle: Text(
                        item.product.price != null
                            ? 'Rs ${item.product.price ?? '-'}'
                            : '',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: _isDark
                                ? Colors.grey.shade300
                                : Colors.grey.shade600),
                      ),
                      trailing: Text(
                        'x ${item.quantity}',
                      ),
                      dense: true,
                    );
                  }),
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total'),
                      Text('Rs ${_orderState.getTotalCartPriceAsFixedString()}')
                    ]),
                SizedBox(height: 10),
                if (!_forShipping)
                  Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Customer'),
                            Text('${args.customer!.fullName}')
                          ]),
                      SizedBox(height: 10),
                    ],
                  ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.done),
                      label: Text(
                          _forShipping ? 'Add to Shipping' : 'Place order')),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
