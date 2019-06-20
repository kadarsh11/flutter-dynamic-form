import 'package:dynamic_form/model/form-model.dart';
import 'package:flutter/material.dart';

class Number extends StatelessWidget {
  final Fields fields;
  final formKey;
  Number({@required this.fields, @required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
        keyboardType: TextInputType.number,
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
