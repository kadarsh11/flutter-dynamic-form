import 'dart:convert';
import 'dart:async';

import 'package:dynamic_form/form/welcome-screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dynamic_form/model/form-model.dart';

const String FORM_URL =
    "https://firebasestorage.googleapis.com/v0/b/collect-plus-6ccd0.appspot.com/o/mobile_tasks%2Fform_task.json?alt=media&token=d048a623-415e-41dd-ad28-8f77e6c546be";

Future<DynamicForm> fetchSurvey() async {
  final response = await http.get(FORM_URL);

  if (response.statusCode == 200) {
    return DynamicForm.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load survey');
  }
}

void main() => runApp(MyApp(formData: fetchSurvey()));

class MyApp extends StatelessWidget {
  final Future<DynamicForm> formData;
  MyApp({Key key, this.formData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: Scaffold(
        body: Center(
          child: FutureBuilder<DynamicForm>(
            future: formData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return WelcomeScreen(formData: snapshot.data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
