import 'package:flutter/material.dart';
import 'package:omsnepal/screens/existing-customer/arguments.dart';
import 'package:omsnepal/screens/existing-customer/existing-customer.dart';
import 'package:omsnepal/services/api/customers.dart';
import 'package:omsnepal/services/auth.dart';
import 'package:provider/provider.dart';

class ExistingCustomerContainer extends StatelessWidget {
  const ExistingCustomerContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    final args =
        ModalRoute.of(context)!.settings.arguments as ExistingCustomerArgument;
    return MultiProvider(providers: [
      ChangeNotifierProvider<CustomersAPI>(
        create: (_) => CustomersAPI(accessToken: authState.token),
      )
    ], child: ExistingCustomer(isFromOrder: args.fromOrder));
  }
}
