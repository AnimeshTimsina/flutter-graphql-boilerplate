import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:omsnepal/graphql/models/product.dart';
import 'package:omsnepal/screens/home/item-popup.dart';
import 'package:omsnepal/services/orders/orderState.dart';
import 'package:omsnepal/services/theme.dart';
import 'package:omsnepal/utils/customRectTween.dart';
import 'package:provider/provider.dart';

class ItemCardList extends StatelessWidget {
  final Product product;

  const ItemCardList({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderState = Provider.of<OrderState>(context);
    String? imageURL = product.photo;
    String title = product.title ?? '';
    String subtitle = 'Rs. ${product.price ?? '-'}';
    bool _hasImage = imageURL != null;
    bool _isDark = Brightness.dark == Theme.of(context).brightness;
    final Color _bgColor = Theme.of(context).brightness == Brightness.dark
        ? Theme.of(context).cardColor
        : Colors.grey.shade200;
    return Container(
        height: 120,
        margin: const EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        child: GestureDetector(
          onTap: () => showDialog(
              context: context,
              builder: (_) => ItemPopup(
                    product: product,
                    initialQuantity:
                        orderState.getItemQuantity(product: product),
                    orderState: orderState,
                    description:
                        orderState.getItemDescription(product: product),
                  )),
          child: Hero(
            tag: '$itemPopupTag-${product.id}',
            createRectTween: (b, e) {
              if (b != null && e != null)
                return CustomRectTween(begin: b, end: e);
              return MaterialRectArcTween();
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 2.0,
              margin: EdgeInsets.only(left: 0.0),
              color: _bgColor,
              child: Container(
                height: 124,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: new EdgeInsets.symmetric(vertical: 16.0),
                      alignment: FractionalOffset.centerLeft,
                      child: new CachedNetworkImage(
                        imageUrl: imageURL ?? '',
                        imageBuilder: (context, imageProvider) => Container(
                          height: 92,
                          width: 92,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
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
                    Container(
                      margin: EdgeInsets.only(left: 15.0),
                      constraints: BoxConstraints(
                          maxWidth: _hasImage
                              ? MediaQuery.of(context).size.width * 0.45
                              : MediaQuery.of(context).size.width * 0.6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // CustomChip(
                          //   isActive: false,
                          //   text: 'Homecare',
                          //   isSmall: true,
                          // ),
                          Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: _isDark
                                        ? Colors.grey.shade200
                                        : LIGHT_TEXT_COLOR_NORMAL),
                          ),
                          SizedBox(height: 5),
                          Text(
                            subtitle,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    color: _isDark
                                        ? Colors.grey.shade300
                                        : Colors.grey.shade600),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
