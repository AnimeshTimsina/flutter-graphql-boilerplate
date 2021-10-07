import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:omsnepal/graphql/models/product.dart';
import 'package:omsnepal/services/orders/orderState.dart';
import 'package:omsnepal/utils/customRectTween.dart';
import 'package:omsnepal/utils/popupBuilder.dart';
import 'package:provider/provider.dart';

import 'item-popup.dart';

class ItemCardGrid extends StatelessWidget {
  final Product product;

  const ItemCardGrid({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderState = Provider.of<OrderState>(context);
    String? imageURL = product.photo;
    String title = product.title ?? '';
    String subtitle = 'Rs. ${product.price ?? '-'}';
    // bool _hasImage = imageURL != null;
    bool _isDark = Brightness.dark == Theme.of(context).brightness;
    final Color _bgColor = Theme.of(context).canvasColor;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(PopupDialogRoute(
          builder: (ctx) {
            return ItemPopup(
              product: product,
              initialQuantity: orderState.getItemQuantity(product: product),
              orderState: orderState,
              description: orderState.getItemDescription(product: product),
            );
          },
        ));
      },
      child: Hero(
        tag: '$itemPopupTag-${product.id}',
        createRectTween: (b, e) {
          if (b != null && e != null) return CustomRectTween(begin: b, end: e);
          return MaterialRectArcTween();
        },
        child: Container(
            height: 180,
            width: 100,
            child: Card(
              color: _bgColor,
              elevation: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: new EdgeInsets.symmetric(vertical: 5.0),
                    child: new CachedNetworkImage(
                      imageUrl: imageURL ?? '',
                      imageBuilder: (context, imageProvider) => Container(
                        height: 70,
                        width: 70,
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
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // CustomChip(
                        //   isActive: false,
                        //   text: 'Homecare',
                        //   isSmall: true,
                        // ),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
