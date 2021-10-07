import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:omsnepal/screens/cart/actionButton.dart';
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
          : ExpandableFab(
              distance: 112.0,
              fabText: 'Rs ${_orderState.getTotalCartPriceAsFixedString()}',
              children: [
                FloatingActionButton.extended(
                  // icon: Icon(Icons.add, color: Colors.white),
                  backgroundColor: Theme.of(context).accentColor,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/new-customer',
                        arguments: NewCustomerArgument(fromCheckout: true));
                  },
                  label: Text("New Customer",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                FloatingActionButton.extended(
                    // icon: Icon(Icons.account_circle, color: Colors.white),
                    backgroundColor: Theme.of(context).accentColor,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/existing-customer');
                    },
                    label: Text("Existing Customer",
                        style: TextStyle(fontWeight: FontWeight.bold))),
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

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    this.initialOpen,
    required this.distance,
    required this.children,
    required this.fabText,
  }) : super(key: key);

  final bool? initialOpen;
  final double distance;
  final String fabText;
  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool _isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(_isDark),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(context, widget.fabText),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab(bool _isDark) {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: _isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab(BuildContext context, String text) {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton.extended(
            label: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
            isExtended: true,
            backgroundColor: Theme.of(context).accentColor,
            // backgroundColor: Theme.of(context).accentColor,
            onPressed: _toggle,
            icon: Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
