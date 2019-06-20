import 'package:dynamic_form/model/form-model.dart';
import 'package:flutter/material.dart';

class ShortText extends StatelessWidget {
  final Function(bool) callback;
  final Function(String) data;
  final formKey;
  final Fields fields;

  ShortText({@required this.fields, this.callback, this.data, this.formKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: formKey,
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
      ),
    );
  }
}
