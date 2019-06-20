import 'package:dynamic_form/model/form-model.dart';
import 'package:flutter/material.dart';

class Email extends StatelessWidget {
  final Fields fields;
  final formKey;
  Email({@required this.fields, @required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            border: OutlineInputBorder(), hintText: fields.title),
        validator: (val) => val.trim().isEmpty
            ? 'Email can\'t be empty.'
            : RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                    .hasMatch(val)
                ? null
                : 'Enter a Valid Email',
      ),
    );
  }
}
