import 'package:dynamic_form/model/form-model.dart';
import 'package:flutter/material.dart';

class Email extends StatelessWidget {
  final Fields fields;
  final _formKey = GlobalKey<FormState>();
  Email({@required this.fields});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(), hintText: fields.title),
        validator: (value) {
          if (value.isEmpty) {
            return 'Enter some text';
          }
          return null;
        },
      ),
    );
  }
}
