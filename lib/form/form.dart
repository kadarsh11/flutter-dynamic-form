import 'package:dynamic_form/util/form-element/date.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_form/model/form-model.dart';
import 'package:dynamic_form/util/form-element/form-element.dart';

class DynamicFormScaffold extends StatefulWidget {
  final DynamicForm formData;
  final double height;
  final double width;
  DynamicFormScaffold({this.formData, this.height, this.width});
  @override
  _DynamicFormScaffoldState createState() => _DynamicFormScaffoldState();
}

class _DynamicFormScaffoldState extends State<DynamicFormScaffold> {
  int i = 0;
  PageController controller = PageController();
  List<Widget> formElements = [];
  List formKeys = [];
  Widget formElement;
  List formType = [];

  validate() {
    print(i);

    if (formType[i] == "text") {
      if (formKeys[i].currentState.validate()) {
        controller.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        Future.delayed(Duration(milliseconds: 330)).then((t) {
          setState(() {});
        });
        i++;
      }
    } else if (formType[i] == "dropdown") {
      controller.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      Future.delayed(Duration(milliseconds: 330)).then((t) {
        setState(() {});
      });
      i++;
    }
  }

  @override
  void initState() {
    super.initState();
    buildForm();
  }

  buildForm() {
    widget.formData.fields.forEach((fields) {
      var formKey = GlobalKey<FormState>();
      formKeys.add(formKey);
    });
    print(widget.formData.fields);
    widget.formData.fields.asMap().forEach((index, fields) {
      String type = fields.type;
      print("My type is $type");
      if (type == "short_text") {
        formType.add("text");
        formElement = ShortText(
          fields: fields,
          formKey: formKeys[index],
          callback: (val) {
            // widget.pageVaildated(true);
          },
        );
      } else if (type == "dropdown") {
        formType.add("dropdown");
        formElement = Dropdown(
          fields: fields,
        );
        setState(() {});
      } else if (type == "number") {
        formType.add("text");
        formElement = Number(
          formKey: formKeys[index],
          fields: fields,
        );
      } else if (type == "email ") {
        formType.add("text");
        formElement = Email(
          formKey: formKeys[index],
          fields: fields,
        );
      } else if (type == "phone_number") {
        formType.add("text");
        formElement = PhoneNumber(
          fields: fields,
        );
      } else if (type == "date") {
        formElement = Date();
      } else {
        formElement = Container();
      }
      formElements.add(formElement ?? Container());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
              child: PageView(
                  controller: controller,
                  physics: NeverScrollableScrollPhysics(),
                  children: formElements.map((element) {
                    return Container(
                      child: Center(
                        child: element,
                      ),
                    );
                  }).toList())),
        ),
        Container(
          child: Row(
            children: <Widget>[
              if (i != 0)
                Expanded(
                  child: MaterialButton(
                    color: Colors.teal,
                    child: Text("Back"),
                    onPressed: () {
                      i--;
                      controller.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInBack);
                      Future.delayed(Duration(milliseconds: 330)).then((t) {
                        setState(() {});
                      });
                    },
                  ),
                ),
              if (i != widget.formData.fields.length - 1)
                Expanded(
                  child: MaterialButton(
                    color: Colors.green,
                    child: Text("Next"),
                    onPressed: () {
                      validate();
                    },
                  ),
                ),
              if (i == widget.formData.fields.length - 1)
                Expanded(
                  child: MaterialButton(
                    color: Colors.green,
                    child: Text("Submit"),
                    onPressed: () {
                      // validate();
                    },
                  ),
                )
            ],
          ),
        )
      ],
    );
  }
}
