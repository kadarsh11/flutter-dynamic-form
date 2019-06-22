import 'dart:convert';

import 'package:dynamic_form/form/form.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dynamic_form/model/form-model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());
String FORM_URL =
    "https://firebasestorage.googleapis.com/v0/b/collect-plus-6ccd0.appspot.com/o/mobile_tasks%2Fform_task.json?alt=media&token=d048a623-415e-41dd-ad28-8f77e6c546be";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFF00AF19),
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
    super.initState();
    getDatLocally();
  }

  getDatLocally() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var isFormSubmitted = sharedPreferences.get('isFormSubmitted') ?? false;
    String data = sharedPreferences.get('formData');
    if (data == null) {
      fetchFormData();
      print("API data");
    } else {
      formData = DynamicForm.fromJson(jsonDecode(data));
      setState(() => isLoading = false);
      print("Local data");
    }
  }

  fetchFormData() async {
    http.get(FORM_URL).then((response) => response.body).then((data) async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString("formData", data);
      formData = DynamicForm.fromJson(jsonDecode(data));
      setState(() => isLoading = false);
      print(formData.title);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : DynamicFormScaffold(
              formData: formData,
              itemPerPage: 2,
              onSubmitted: (data) {
                print(data);
              },
            ),
    );
  }
}
