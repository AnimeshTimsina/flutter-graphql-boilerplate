import 'package:flutter/material.dart';
import 'package:omsnepal/graphql/models/customer.dart';
import 'package:omsnepal/models/constants.dart';
import 'package:omsnepal/screens/checkout/arguments.dart';
import 'package:omsnepal/services/api/customers.dart';
import 'package:omsnepal/services/auth.dart';
import 'package:omsnepal/services/theme.dart';
import 'package:omsnepal/widgets/refetchMessage.dart';
import 'package:omsnepal/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ExistingCustomer extends StatefulWidget {
  ExistingCustomer({Key? key}) : super(key: key);

  @override
  _ExistingCustomerState createState() => _ExistingCustomerState();
}

class _ExistingCustomerState extends State<ExistingCustomer> {
  final searchController = TextEditingController();
  String _searchText = '';

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
    final CustomersAPI _api = Provider.of<CustomersAPI>(context);
    final authState = Provider.of<AuthState>(context);
    final bool _isDark = Theme.of(context).brightness == Brightness.dark;
    final Color _bgColor =
        _isDark ? Theme.of(context).primaryColor : Colors.white;
    final Color _textColor = _isDark ? Colors.white : Colors.grey.shade800;
    List<Customer> _searchResults = _api.getFilteredCustomers(_searchText);

    return Scaffold(
        backgroundColor: _bgColor,
        resizeToAvoidBottomInset: false,
        appBar: SecondaryAppBar(
          textColor: _textColor,
          bgColor: _bgColor,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _api.fetchData(accessToken: authState.token);
          },
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  alignment: Alignment.topLeft,
                  child: PageTitle(
                    title: 'Select a customer',
                    icon: Icons.person,
                  )),
              SizedBox(height: 10),
              if (_api.loadingState == LoadingState.loaded)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchBox(
                      placeholder: 'Search for a customer....',
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.grey.withOpacity(0.9)
                              : null,
                      controller: searchController),
                ),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  alignment: _api.loadingState != LoadingState.loaded
                      ? Alignment.topLeft
                      : Alignment.center,
                  child: _api.loadingState == LoadingState.error
                      ? RefetchMessage(callback: () {
                          _api.fetchData(accessToken: authState.token);
                        })
                      : _api.loadingState == LoadingState.loading
                          ? Container(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator.adaptive())
                          : _api.data == null || _searchResults.isEmpty
                              ? Message(
                                  message:
                                      'No any data available. Contact Admin',
                                  icon: Icons.mood_bad)
                              : ListView.builder(
                                  itemCount: _searchResults.length,
                                  addSemanticIndexes: true,
                                  itemBuilder: (context, index) {
                                    final item = _searchResults[index];

                                    return ListTile(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            '/checkout',
                                            arguments: CheckoutArgument(
                                                customer:
                                                    _searchResults[index]));
                                      },
                                      title: Text(
                                        item.fullName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: _isDark
                                                ? Colors.grey.shade200
                                                : LIGHT_TEXT_COLOR_NORMAL),
                                      ),
                                      subtitle: item.phone == null
                                          ? null
                                          : Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    child: Icon(
                                                      Icons.phone,
                                                      size: 13,
                                                    ),
                                                  ),
                                                  Text(
                                                    item.phone ?? '',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2!
                                                        .copyWith(
                                                            color: _isDark
                                                                ? Colors.grey
                                                                    .shade300
                                                                : Colors.grey
                                                                    .shade600),
                                                  )
                                                ]),
                                      leading: Icon(Icons.person),
                                      trailing: item.vat != null
                                          ? Text('(${item.vat})')
                                          : null,
                                      // dense: true,
                                      horizontalTitleGap: 5,
                                    );
                                  },
                                ),
                ),
              )
            ],
          ),
        ));
  }
}
