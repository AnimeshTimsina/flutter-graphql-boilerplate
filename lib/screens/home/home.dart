import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omsnepal/graphql/models/product.dart';
import 'package:omsnepal/graphql/models/product_category.dart';
import 'package:omsnepal/models/constants.dart';
import 'package:omsnepal/screens/home/drawer.dart';
import 'package:omsnepal/services/api/customers.dart';
import 'package:omsnepal/services/api/products.dart';
import 'package:omsnepal/services/auth.dart';
import 'package:omsnepal/services/orders/orderState.dart';
import 'package:omsnepal/services/theme.dart';
import 'package:omsnepal/widgets/refetchMessage.dart';
import 'package:omsnepal/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'item-grid.dart';
import 'item-list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);

    return MultiProvider(providers: [
      ChangeNotifierProvider<ProductsAPI>(
          create: (_) => ProductsAPI(accessToken: authState.token)),
    ], child: MainScreen());
  }
}

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String activeID = 'all';
  final searchController = TextEditingController();
  String _searchText = '';
  bool _isGrid = true;

  void _setSearchText() {
    setState(() {
      _searchText = searchController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(_setSearchText);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    final themeState = Provider.of<ThemeState>(context);
    final productState = Provider.of<ProductsAPI>(context);
    final orderState = Provider.of<OrderState>(context);
    final Color _bgColor = Theme.of(context).brightness == Brightness.dark
        ? Theme.of(context).primaryColor
        : Colors.grey.shade300;
    final Color _textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.grey.shade800;
    final _products = productState.getProductsByCategory(
        id: activeID == 'all' ? null : activeID, searchText: _searchText);
    return Scaffold(
      appBar:
          _buildAppBar(_textColor, _bgColor, orderState.numberOfItemTypes()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isGrid = !_isGrid;
          });
        },
        child: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
        backgroundColor: Theme.of(context).accentColor,
      ),
      drawer: CustomDrawer(authState: authState, themeState: themeState),
      body: RefreshIndicator(
        onRefresh: () async {
          productState.fetchData(accessToken: authState.token);
        },
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _buildTopSection(_bgColor, authState, context, _textColor),
                  SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      alignment:
                          productState.loadingState != LoadingState.loaded
                              ? Alignment.topLeft
                              : Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: productState.loadingState == LoadingState.error
                          ? RefetchMessage(callback: () {
                              productState.fetchData(
                                  accessToken: authState.token);
                            })
                          : productState.loadingState == LoadingState.loading
                              ? Container(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator.adaptive())
                              : productState.data == null ||
                                      productState.data!.isEmpty
                                  ? Message(
                                      message:
                                          'No any data available. Contact Admin',
                                      icon: Icons.mood_bad)
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        // _buildHeaderText(context, _textColor, 'Categories'),
                                        // SizedBox(height: 10),
                                        _buildCategoryPanel(productState.data!),
                                        SizedBox(height: 20),
                                        SearchBox(
                                          backgroundColor:
                                              Theme.of(context).brightness ==
                                                      Brightness.light
                                                  ? Colors.grey.withOpacity(0.9)
                                                  : null,
                                          controller: searchController,
                                          placeholder:
                                              'Search for a product ....',
                                        ),
                                        SizedBox(height: 20),
                                        _buildItemView(_products)
                                      ],
                                    ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Expanded _buildItemView(List<Product> _products) {
    return Expanded(
      child: _products.isEmpty
          ? Message(message: 'No products found', icon: Icons.mood_bad)
          : _isGrid
              ? Container(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Wrap(
                      spacing: 1,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      runAlignment: WrapAlignment.start,
                      children: [
                        ..._products.map((e) => Container(
                              child: ItemCardGrid(product: e),
                            ))
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _products.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return ItemCardList(
                      product: _products[index],
                    );
                  },
                ),
    );
  }

  SingleChildScrollView _buildCategoryPanel(List<ProductCategory> categories) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          CustomChip(
            isActive: activeID == 'all',
            onTap: () => setState(() {
              activeID = 'all';
            }),
            text: 'All',
          ),
          ...categories.map((e) => CustomChip(
                isActive: activeID == e.id!,
                onTap: () => setState(() {
                  activeID = e.id!;
                }),
                text: e.title!,
              ))
        ],
      ),
    );
  }

  Container _buildTopSection(Color _bgColor, AuthState authState,
      BuildContext context, Color _textColor) {
    NepaliUtils(Language.nepali);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      height: 90,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(35.0),
            bottomRight: Radius.circular(35.0)),
        color: _bgColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Hi ${authState.getFirstName()}',
                  style: Theme.of(context).textTheme.headline4!),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.emoji_emotions,
                  color: Theme.of(context).accentColor,
                ),
              )
            ],
          ),
          SizedBox(height: 7),
          Text(NepaliDateFormat.yMMMMd().format(NepaliDateTime.now()),
              style: Theme.of(context).textTheme.headline5!)
        ],
      ),
    );
  }

  AppBar _buildAppBar(Color _textColor, Color _bgColor, int _numOfOrders) {
    return AppBar(
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Badge(
              value: Text(
                '$_numOfOrders',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
              show: _numOfOrders != 0,
              // value: order.orders.length.toString(),
              top: 10,
              right: 30,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/cart');
                },
                icon: Icon(
                  Icons.shopping_bag,
                  color: _textColor,
                  size: 30,
                ),
              )),
        )
      ],
      leading: Builder(
          builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: _textColor),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              })),
      backgroundColor: _bgColor,
    );
  }
}
