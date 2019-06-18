import 'dart:convert';

import 'package:dynamic_form/form/form.dart';
import 'package:dynamic_form/util/form-element/short-text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dynamic_form/model/form-model.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());
String FORM_URL =
    "https://firebasestorage.googleapis.com/v0/b/collect-plus-6ccd0.appspot.com/o/mobile_tasks%2Fform_task.json?alt=media&token=d048a623-415e-41dd-ad28-8f77e6c546be";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DynamicForm formData;
  bool isLoading = true;
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    fetchFormData();
    super.initState();
  }

  fetchFormData() {
    http.get(FORM_URL).then((response) => response.body).then((data) {
      formData = DynamicForm.fromJson(jsonDecode(data));
      setState(() => isLoading = false);
      print(formData.title);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [Provider<Key>.value(value: _formKey)],
      child: Scaffold(
        body: isLoading
            ? CircularProgressIndicator()
            : PageView(
                children: formData.fields
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
