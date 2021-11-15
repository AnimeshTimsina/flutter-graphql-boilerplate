import 'package:flutter/material.dart';
import 'package:omsnepal/models/constants.dart';
import 'package:omsnepal/screens/existing-customer/arguments.dart';
import 'package:omsnepal/screens/home/styles.dart';
import 'package:omsnepal/screens/new-customer/arguments.dart';
import 'package:omsnepal/services/auth.dart';
import 'package:omsnepal/services/theme.dart';
import 'package:omsnepal/widgets/widgets.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
    required this.authState,
    required this.themeState,
  }) : super(key: key);

  final AuthState authState;
  final ThemeState themeState;

  @override
  Widget build(BuildContext context) {
    bool _isDark = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(authState.getFullName()),
            accountEmail: Text(authState.getEmail()),
            decoration: _isDark
                ? null
                : BoxDecoration(color: Theme.of(context).indicatorColor),
            // currentAccountPicture: authState.userInfo?.displayPicture == null
            //     ? Container(
            //         child: Icon(
            //           Icons.account_circle_rounded,
            //           size: 80,
            //         ),
            //       )
            //     : CachedNetworkImage(
            //         imageUrl: authState.userInfo!.displayPicture!,
            //         imageBuilder: (context, imageProvider) => Container(
            //           height: 200,
            //           width: 200,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.all(Radius.circular(50)),
            //             image: DecorationImage(
            //               image: imageProvider,
            //               fit: BoxFit.cover,
            //             ),
            //           ),
            //         ),
            //         placeholder: (context, url) => Icon(
            //           Icons.account_circle_rounded,
            //           size: 80,
            //         ),
            //       ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              children: [
                ListTile(
                  dense: true,
                  leading: Icon(Icons.brightness_2,
                      size: 20.0, color: Theme.of(context).indicatorColor),
                  title: Text('Dark Mode', style: TextStyle(fontSize: 15.0)),
                  trailing: Switch.adaptive(
                    activeColor: Theme.of(context).indicatorColor,
                    value: themeState.themeMode == ThemeMode.dark,
                    onChanged: (bool value) {
                      themeState.toggleTheme();
                    },
                  ),
                ),
                ListTile(
                  dense: true,
                  leading: Icon(Icons.local_shipping,
                      size: 20.0, color: Theme.of(context).indicatorColor),
                  title: Text("Shipments", style: TextStyle(fontSize: 15.0)),
                  onTap: () {
                    Navigator.pushNamed(context, '/new-customer',
                        arguments: NewCustomerArgument(fromCheckout: false));
                  },
                ),
                ListTile(
                  dense: true,
                  leading: Icon(Icons.person_add,
                      size: 20.0, color: Theme.of(context).indicatorColor),
                  title: Text("Customers", style: TextStyle(fontSize: 15.0)),
                  onTap: () {
                    Navigator.pushNamed(context, '/existing-customer',
                        arguments: ExistingCustomerArgument(fromOrder: false));
                  },
                ),
                ListTile(
                  dense: true,
                  leading: Icon(Icons.all_inbox,
                      size: 20.0, color: Theme.of(context).indicatorColor),
                  title: Text("Orders", style: TextStyle(fontSize: 15.0)),
                  onTap: () {
                    Navigator.pushNamed(context, '/new-customer',
                        arguments: NewCustomerArgument(fromCheckout: false));
                  },
                ),
                ListTile(
                  dense: true,
                  leading: Icon(Icons.people,
                      size: 20.0, color: Theme.of(context).indicatorColor),
                  title: Text("Users", style: TextStyle(fontSize: 15.0)),
                  onTap: () {
                    Navigator.pushNamed(context, '/new-customer',
                        arguments: NewCustomerArgument(fromCheckout: false));
                  },
                ),
                ListTile(
                  dense: true,
                  leading: Icon(Icons.vpn_key,
                      size: 20.0, color: Theme.of(context).indicatorColor),
                  title:
                      Text("Change Password", style: TextStyle(fontSize: 15.0)),
                  onTap: () {
                    Navigator.pushNamed(context, '/change-password');
                  },
                ),
                ListTile(
                  dense: true,
                  leading: Icon(Icons.logout,
                      size: 20.0, color: Theme.of(context).indicatorColor),
                  title: Text("Log out", style: TextStyle(fontSize: 15.0)),
                  onTap: () async {
                    Navigator.pop(context);
                    await authState.logout(context);
                    if (authState.loadingStateLogOut == LoadingState.error) {
                      ScaffoldMessenger.of(context).showSnackBar(snackbar(
                          text: "Something went wrong!", color: Colors.red));
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              color: Theme.of(context).cardColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    authState.getUserTypeInString(),
                    style: drawerBoxInfoStyle(context),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
