import 'package:flutter/material.dart';
import 'package:dynamic_form/model/form-model.dart';
import 'package:dynamic_form/form/home-page.dart';

class WelcomeScreen extends StatelessWidget {
  final DynamicForm formData;
  const WelcomeScreen({
    Key key,
    this.formData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
            child: Text(
              formData.welcomeScreens[0].title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          preferredSize: Size(0.0, 4.0),
        ),
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              // image: new DecorationImage(
              //   image: new AssetImage("assets/survey.png"),
              //   fit: BoxFit.cover,
              // ),
              // color: Colors.black,
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 0.0),
                  child: Text(
                    formData.welcomeScreens[0].properties.description,
                    style: TextStyle(
                      color: Colors.cyan,
                      fontSize: 24.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return HomePage(formData);
                          },
                        ),
                      );
                    },
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 85, vertical: 10),
                    color: Colors.cyan,
                    textColor: Colors.white,
                    child: Text(
                      formData.welcomeScreens[0].properties.buttonText,
                      style: TextStyle(
                        // color: Colors.white,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
