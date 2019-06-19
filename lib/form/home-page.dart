import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dynamic_form/form/form.dart';
import 'package:dynamic_form/util/form-element/short-text.dart';
import 'package:dynamic_form/model/form-model.dart';

class HomePage extends StatefulWidget {
  final DynamicForm formData;
  HomePage(this.formData);
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [Provider<Key>.value(value: _formKey)],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Survey',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: PageView(
          children: widget.formData.fields
              .map((field) => Container(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          DynamicField(
                            fields: field,
                          ),
                          FlatButton(
                            onPressed: () {},
                            child: Text("Next"),
                          )
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
