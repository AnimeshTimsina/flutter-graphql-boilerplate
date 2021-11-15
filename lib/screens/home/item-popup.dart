import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:omsnepal/graphql/models/product.dart';
import 'package:omsnepal/services/orders/orderState.dart';
import 'package:omsnepal/utils/customRectTween.dart';
import 'package:flutter/services.dart';
import 'package:omsnepal/widgets/widgets.dart';

String itemPopupTag = 'item-popup-tag';

class ItemPopup extends StatefulWidget {
  final Product product;
  final int initialQuantity;
  final String? description;
  final OrderState orderState;
  const ItemPopup(
      {Key? key,
      required this.product,
      required this.initialQuantity,
      required this.orderState,
      this.description})
      : super(key: key);

  @override
  _ItemPopupState createState() =>
      _ItemPopupState(quantity: initialQuantity, description: description);
}

class _ItemPopupState extends State<ItemPopup> {
  int quantity;
  String? description;
  _ItemPopupState({required this.quantity, this.description});

  late final _quantityController =
      TextEditingController(text: quantity.toString());

  late final _descriptionController = TextEditingController(text: description);

  @override
  void initState() {
    super.initState();
    _quantityController.addListener(_setQuantity);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  _add() {
    setState(() {
      quantity = quantity + 1;
    });
    _quantityController.text = quantity.toString();
  }

  _subtract() {
    setState(() {
      quantity = quantity - 1;
    });
    _quantityController.text = quantity.toString();
  }

  _setQuantity() {
    setState(() {
      quantity = int.parse(_quantityController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool _isDark = Brightness.dark == Theme.of(context).brightness;
    double _imageHeight = 100;
    double _imageWidth = _imageHeight;
    String _subtitle = 'Rs. ${widget.product.price ?? '-'}';
    bool _hasDescription =
        widget.product.description != null && widget.product.description != '';
    OrderState orderState = widget.orderState;

    bool _disableOrderButton = quantity == 0;
    bool _disableMinusButton = _disableOrderButton;

    _addToOrder() {
      if (!_disableOrderButton) {
        print(_descriptionController.text);
        orderState.setOrder(
            product: widget.product,
            quantity: quantity,
            description: _descriptionController.text);
      }
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(snackbar(
          text: 'Successfully added $quantity ${widget.product.title}'));
    }

    return Center(
        child: Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 10),
                      blurRadius: 10),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                        tag: '$itemPopupTag-${widget.product.id}',
                        createRectTween: (b, e) {
                          if (b != null && e != null)
                            return CustomRectTween(begin: b, end: e);
                          return MaterialRectArcTween();
                        },
                        child: _buildImage(_imageHeight, _imageWidth)),
                    _buildMainInfo(_imageHeight, context, _subtitle, _isDark),
                  ],
                ),
                if (_hasDescription)
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Text(
                      widget.product.description ?? '',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: _isDark
                              ? Colors.grey.shade300
                              : Colors.grey.shade600),
                    ),
                  ),
                SizedBox(height: 20.0),
                _buildQuantityChanger(_disableMinusButton, context),
                SizedBox(height: 20),
                _buildDescriptionBox(context),
                SizedBox(height: 20),
                _buildActionButtons(context, _disableOrderButton, _addToOrder),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Row _buildActionButtons(
      BuildContext context, bool _disableOrderButton, _addToOrder()) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).indicatorColor)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close')),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(_disableOrderButton
                      ? Theme.of(context).disabledColor
                      : Theme.of(context).indicatorColor)),
              onPressed: _disableOrderButton ? null : _addToOrder,
              child: Text('Add to order')),
        ),
      ],
    );
  }

  Container _buildDescriptionBox(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.grey.withOpacity(0.9)
            : Colors.grey.withOpacity(0.4),
      ),
      width: double.infinity,
      child: TextFormField(
          controller: _descriptionController,
          maxLines: 3,
          style: TextStyle(color: Colors.white.withOpacity(0.9)),
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Add a description...',
              hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.9), fontSize: 14))),
    );
  }

  Row _buildQuantityChanger(bool _disableMinusButton, BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: IconButton(
              icon: Icon(
                Icons.remove_circle,
                color: _disableMinusButton
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).indicatorColor,
              ),
              onPressed: _disableMinusButton ? null : _subtract,
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: 50,
            child: TextFormField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              controller: _quantityController,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: IconButton(
              onPressed: _add,
              icon: Icon(Icons.add_circle,
                  color: Theme.of(context).indicatorColor),
            ),
          )
        ]);
  }

  Expanded _buildMainInfo(double _imageHeight, BuildContext context,
      String _subtitle, bool _isDark) {
    return Expanded(
      child: Container(
        height: _imageHeight,
        margin: EdgeInsets.only(left: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.product.title ?? '',
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(height: 5),
            Text(
              _subtitle,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: _isDark ? Colors.grey.shade300 : Colors.grey.shade600),
            )
          ],
        ),
      ),
    );
  }

  CachedNetworkImage _buildImage(double _imageHeight, double _imageWidth) {
    return new CachedNetworkImage(
      imageUrl: widget.product.photo ?? '',
      imageBuilder: (context, imageProvider) => Container(
        height: _imageHeight,
        width: _imageWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
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
    );
  }
}
