import 'package:flutter/material.dart';
import 'package:omsnepal/graphql/models/customer.dart';
import 'package:omsnepal/models/constants.dart';
import 'package:omsnepal/screens/checkout/arguments.dart';
import 'package:omsnepal/screens/new-customer/form.dart';
import 'package:omsnepal/services/api/createCustomer.dart';
import 'package:omsnepal/services/auth.dart';
import 'package:omsnepal/widgets/widgets.dart';
import 'package:provider/provider.dart';

class NewCustomerScreen extends StatefulWidget {
  final bool isFromCheckout;
  const NewCustomerScreen({Key? key, required this.isFromCheckout})
      : super(key: key);

  @override
  _NewCustomerScreenState createState() => _NewCustomerScreenState();
}

class _NewCustomerScreenState extends State<NewCustomerScreen> {
  final CustomerFormData form = CustomerFormData();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bool _isDark = Theme.of(context).brightness == Brightness.dark;
    final Color _textColor = _isDark ? Colors.white : Colors.grey.shade800;
    final Color _bgColor =
        _isDark ? Theme.of(context).primaryColor : Colors.white;
    const TextStyle _formTextStyle = TextStyle(fontSize: 15);
    final CreateCustomerAPI _api = Provider.of<CreateCustomerAPI>(context);
    final AuthState authState = Provider.of<AuthState>(context);

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: SecondaryAppBar(
        textColor: _textColor,
        bgColor: _bgColor,
        actionClick: () => _formKey.currentState?.reset(),
        actionIcon: Icons.clear_all,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageTitle(
                title: 'New Customer',
                icon: Icons.person_add,
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: 'Enter full name',
                        labelText: 'Full Name *',
                        labelStyle: _formTextStyle,
                      ),
                      onSaved: (String? value) {
                        setState(() {
                          form.setFullName(value ?? '');
                        });
                      },
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      style: _formTextStyle,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter full name';
                        }
                        return null;
                      },
                      autocorrect: false,
                      maxLength: 50,
                    ),
                    TextFormField(
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.phone),
                          hintText: 'Enter phone number',
                          labelText: 'Phone Number *',
                          labelStyle: _formTextStyle),
                      style: _formTextStyle,
                      onSaved: (String? value) {
                        setState(() {
                          form.setPhone(value ?? '');
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        return null;
                      },
                      autocorrect: false,
                      maxLength: 10,
                    ),
                    TextFormField(
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.credit_card),
                          hintText: 'Enter VAT number',
                          labelText: 'VAT Number',
                          labelStyle: _formTextStyle),
                      style: _formTextStyle,
                      onSaved: (String? value) {
                        setState(() {
                          form.setVat(value != null ? int.parse(value) : null);
                        });
                      },
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please enter VAT number';
                      //   }
                      //   return null;
                      // },
                      autocorrect: false,
                      maxLength: 50,
                    ),
                    TextFormField(
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      decoration: const InputDecoration(
                          icon: Icon(Icons.home),
                          hintText: 'Enter address',
                          labelText: 'Address',
                          labelStyle: _formTextStyle),
                      style: _formTextStyle,
                      onSaved: (String? value) {
                        setState(() {
                          form.setAddress(value ?? '');
                        });
                      },
                      autocorrect: false,
                      maxLength: 100,
                    ),
                    TextFormField(
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.description),
                          hintText: 'Enter description',
                          labelText: 'Description',
                          labelStyle: _formTextStyle),
                      style: _formTextStyle,
                      onSaved: (String? value) {
                        setState(() {
                          form.setDescription(value ?? '');
                        });
                      },
                      autocorrect: false,
                      maxLength: 500,
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton.icon(
                        icon: _api.createLoadingState == LoadingState.loading
                            ? CircularProgressIndicator.adaptive()
                            : widget.isFromCheckout
                                ? Icon(Icons.send)
                                : Icon(Icons.done),
                        label: Text(
                            '${widget.isFromCheckout ? 'Create and checkout' : 'Submit'}'),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).indicatorColor)),
                        onPressed: () async {
                          if (_api.createLoadingState == LoadingState.loading)
                            return null;
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            Customer? newCustomer =
                                await _api.createNewCustomer(
                                    accessToken: authState.token!,
                                    data: CreateCustomerInput(
                                        fullName: form.fullName ?? '',
                                        address: form.address,
                                        description: form.description,
                                        phone: form.phone,
                                        vat: form.vat),
                                    context: context);
                            if (newCustomer != null) {
                              Navigator.of(context).pushNamed('/checkout',
                                  arguments:
                                      CheckoutArgument(customer: newCustomer));
                            }
                            // Redirect to checkout page with this customer instance
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),

      // floatingActionButton: FloatingActionButton.extended(
      //     onPressed: () {},
      //     label:
      //         Text('${args.fromCheckout ? 'Create and checkout' : 'Create'}')),
    );
  }
}
