import 'package:flutter/material.dart';
import 'package:omsnepal/screens/new-customer/arguments.dart';
import 'package:omsnepal/screens/new-customer/new-customer.dart';
import 'package:omsnepal/services/api/createCustomer.dart';
import 'package:provider/provider.dart';

class NewCustomerContainer extends StatelessWidget {
  const NewCustomerContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      final args=
        ModalRoute.of(context)!.settings.arguments as NewCustomerArgument;
    return MultiProvider(providers: [
      ChangeNotifierProvider<CreateCustomerAPI>(
        create: (_) => CreateCustomerAPI(),
      )
    ], child: NewCustomerScreen(isFromCheckout:  args.fromCheckout,));
  }
}
