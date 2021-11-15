import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:omsnepal/screens/existing-customer/arguments.dart';
import 'package:omsnepal/screens/home/item-popup.dart';
import 'package:omsnepal/screens/new-customer/arguments.dart';
import 'package:omsnepal/services/orders/model.dart';
import 'package:omsnepal/services/orders/orderState.dart';
import 'package:omsnepal/services/theme.dart';
import 'package:omsnepal/widgets/widgets.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final OrderState _orderState = Provider.of<OrderState>(context);
    final bool _isDark = Theme.of(context).brightness == Brightness.dark;
    final Color _textColor = _isDark ? Colors.white : Colors.grey.shade800;
    final Color _bgColor =
        _isDark ? Theme.of(context).primaryColor : Colors.white;

    return Scaffold(
      backgroundColor: _bgColor,
      floatingActionButton: _orderState.isCartEmpty()
          ? null
          : SpeedDial(
              child: Icon(Icons.send),
              activeChild: Icon(Icons.close),
              backgroundColor: Theme.of(context).indicatorColor,
              visible: true,
              curve: Curves.bounceIn,
              children: [
                SpeedDialChild(
                  child: Icon(Icons.person_add),
                  backgroundColor: Theme.of(context).primaryColor,
                  label: 'New customer order',
                  labelStyle: TextStyle(fontWeight: FontWeight.w500),
                  onTap: () {
                    Navigator.of(context).pushNamed('/new-customer',
                        arguments: NewCustomerArgument(fromCheckout: true));
                  },
                ),
                SpeedDialChild(
                  child: Icon(Icons.person),
                  backgroundColor: Theme.of(context).primaryColor,
                  label: 'Old customer order',
                  labelStyle: TextStyle(fontWeight: FontWeight.w500),
                  onTap: () {
                    Navigator.of(context).pushNamed('/existing-customer',
                        arguments: ExistingCustomerArgument(fromOrder: true));
                  },
                ),
                SpeedDialChild(
                  child: Icon(Icons.local_shipping),
                  backgroundColor: Theme.of(context).primaryColor,
                  label: 'Add to Shipment',
                  labelStyle: TextStyle(fontWeight: FontWeight.w500),
                  onTap: () {
                    Navigator.of(context).pushNamed('/checkout');
                  },
                ),
              ],
            ),
      appBar: SecondaryAppBar(
        textColor: _textColor,
        bgColor: _bgColor,
        actionClick: () => _orderState.clearOrder(),
        actionIcon: Icons.clear_all,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageTitle(
              title: 'Order Cart',
              icon: Icons.shopping_bag,
            ),
            SizedBox(height: 20),
            Expanded(
                child: Container(
              width: double.infinity,
              child: _orderState.isCartEmpty()
                  ? Message(
                      message: 'No any product available in cart !',
                      icon: Icons.mood_bad)
                  : Container(
                      width: double.infinity,
                      child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              ..._orderState.orders.map((e) => Container(
                                    // height: 170,
                                    child: _buildItemCard(
                                        context: context,
                                        order: e,
                                        orderState: _orderState),
                                  ))
                            ],
                          ))),
            )),
          ],
        ),
      ),
    );
  }
}

Widget _buildItemCard(
    {required OrderModel order,
    required BuildContext context,
    required OrderState orderState}) {
  bool _isDark = Theme.of(context).brightness == Brightness.dark;
  Color _textColor = _isDark ? Colors.grey.shade300 : Colors.grey.shade700;
  Color _bgColor = _isDark ? Color(0xff2e2e2e) : Colors.grey.shade200;
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5.0),
    child: Slidable(
      actionPane: SlidableDrawerActionPane(),
      actions: [
        IconSlideAction(
          color: Colors.red.shade500,
          icon: Icons.delete,
          onTap: () {
            orderState.removeFromOrder(product: order.product);
          },
        )
      ],
      child: GestureDetector(
        onTap: () => showDialog(
            context: context,
            builder: (_) => ItemPopup(
                  product: order.product,
                  initialQuantity:
                      orderState.getItemQuantity(product: order.product),
                  orderState: orderState,
                  description:
                      orderState.getItemDescription(product: order.product),
                )),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5.0,
          margin: EdgeInsets.zero,
          color: _bgColor,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: new CachedNetworkImage(
                    imageUrl: order.product.photo ?? '',
                    imageBuilder: (context, imageProvider) => Container(
                      height: 92,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Icon(
                      Icons.pending,
                      size: 80,
                    ),
                    errorWidget: (context, _, __) => Icon(
                      Icons.pending,
                      size: 80,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.product.title ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: _isDark
                                      ? Colors.grey.shade200
                                      : LIGHT_TEXT_COLOR_NORMAL),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Rs ${order.product.price ?? '-'}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(
                                  color: _isDark
                                      ? Colors.grey.shade300
                                      : Colors.grey.shade600),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'x ${order.quantity}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: _textColor),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
