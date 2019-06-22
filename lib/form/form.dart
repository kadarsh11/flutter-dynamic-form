import 'dart:math';

import 'package:dynamic_form/model/form-model.dart';
import 'package:dynamic_form/util/function/function.dart';
import 'package:dynamic_form/util/page-indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

const SCALE_FRACTION = 0.7;
const FULL_SCALE = 1.0;

class DynamicFormScaffold extends StatefulWidget {
  final DynamicForm formData;
  final int itemPerPage;
  final Function(Map<String, dynamic>) onSubmitted;
  DynamicFormScaffold(
      {this.formData, this.itemPerPage, @required this.onSubmitted});
  @override
  _DynamicFormScaffoldState createState() => _DynamicFormScaffoldState();
}

class _DynamicFormScaffoldState extends State<DynamicFormScaffold> {
  double viewPortFraction = 0.8;
  int currentPage = 0;
  int totalPage = 0;
  String formId;
  final PageController controller = PageController(viewportFraction: 0.8);

  List<Widget> formElements = [];

  int itemPerPage;
  List<List<Widget>> pageWidget = [];

  Map<String, dynamic> inputData = Map();

  @override
  void initState() {
    super.initState();
    formId = widget.formData.id;
    itemPerPage = widget.itemPerPage ?? 3;
    buildForm();
  }

  buildForm() {
    Widget formElement;
    inputData[formId] = Map();
    widget.formData.fields.asMap().forEach((index, fields) {
      switch (fields.type) {
        case "short_text":
          formElement = buildShortText(fields, index);
          formElements.add(formElement);
          break;
        case "dropdown":
          formElement = buildDropdown(fields, index);
          formElements.add(formElement);
          break;
        case "number":
          formElement = buildNumber(fields, index);
          formElements.add(formElement);
          break;
        case "email":
          formElement = buildEmail(fields, index);
          formElements.add(formElement);
          break;
        case "phone_number":
          formElement = buildPhoneNumber(fields, index);
          formElements.add(formElement);
          break;
        case "rating":
          inputData[formId][fields.id] = "2.5";
          formElement = buildRating(fields, index);
          formElements.add(formElement);
          break;
        case "date":
          inputData[formId][fields.id] = DateTime.now();
          formElement = buildDatePicker(fields, index);
          formElements.add(formElement);
          break;
        case "yes_no":
          formElement = buildYesNo(fields, index);
          formElements.add(formElement);
          break;
        default:
          print(fields.type);
          break;
      }
    });
    pageWidget = chunkWidgets(array: formElements, size: itemPerPage);
  }

  validate() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    bool allValidated = true;
    List chunkFieldData =
        chunkList(array: widget.formData.fields, size: itemPerPage);

    print("Before the validation $inputData");

    chunkFieldData[currentPage].forEach((Fields fields) {
      if (fields.validations.required) {
        if (inputData[formId][fields.id] == null) {
          print("False reason ${fields.id}");
          allValidated = false;
        }
      } else if (inputData[formId][fields.id] == null) {
        inputData[formId][fields.id] = "";
      }
    });

    if (allValidated) {
      print("See the value");
      currentPage++;
      controller.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.bounceInOut);
      Future.delayed(Duration(milliseconds: 330)).then((t) {
        setState(() {});
      });
    } else {
      Scaffold.of(context)
          .showSnackBar(showSnackBar("Please fill all the fields."));
    }
    print("After the validation $inputData");
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF2f3640),
      body: Stack(children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Container(
                  child: PageView.builder(
                      controller: controller,
                      physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (i) {
                        print(i);
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        currentPage = i;
                        setState(() {});
                      },
                      itemCount: pageWidget.length,
                      itemBuilder: (context, index) {
                        final double blur = index == currentPage ? 30 : 0;
                        final double offset = index == currentPage ? 20 : 0;
                        final double top = index == currentPage ? 150 : 200;
                        return AnimatedContainer(
                          alignment: Alignment.center,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeOutQuint,
                          margin:
                              EdgeInsets.only(right: 30, top: top, bottom: top),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black87,
                                    blurRadius: blur,
                                    offset: Offset(offset, offset))
                              ]),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: pageWidget[index]
                                .map((_) => Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: _,
                                    ))
                                .toList(),
                          ),
                        );
                      })),
            ),
          ],
        ),
        Positioned(
          top: 45.0,
          left: 0.0,
          child: Container(
            height: 10.0,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: PageIndicator(
                height: 8.0,
                gutter: 5.0,
                pageCount: pageWidget.length,
                currentIndex: currentPage,
              ),
            ),
          ),
        ),
        if (currentPage != 0)
          Positioned(
            top: height / 2,
            left: 5.0,
            child: GestureDetector(
              onTap: () {
                currentPage--;
                controller.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.bounceOut);
                Future.delayed(Duration(milliseconds: 330)).then((t) {
                  setState(() {});
                });
              },
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.blue),
                width: 40.0,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        if (currentPage != pageWidget.length - 1)
          Positioned(
            top: height / 2,
            right: 5.0,
            child: GestureDetector(
              onTap: () {
                validate();
                // setState(() {});
              },
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.blue),
                width: 40.0,
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        if (currentPage == pageWidget.length - 1)
          Positioned(
            top: height / 2,
            right: 5.0,
            child: GestureDetector(
              onTap: () {
                print("All the form data is $inputData");
                widget.onSubmitted(inputData);
              },
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.green),
                width: 40.0,
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),
          )
      ]),
    );
  }

  Future<Null> _selectDate(
      {BuildContext context, int index, Fields fields}) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null)
      setState(() {
        inputData[formId][fields.id] = picked;
      });
  }

  Widget buildRating(Fields fields, int index) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[
          Text(
            "${fields.title}",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: 'Poppins-Medium',
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.black),
          ),
          SizedBox(
            height: 10.0,
          ),
          FlutterRatingBar(
            initialRating: 2.5,
            allowHalfRating: true,
            ignoreGestures: false,
            tapOnlyMode: false,
            itemCount: 5,
            itemSize: 30.0,
            borderColor: Colors.blue,
            fillColor: Colors.blue,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            onRatingUpdate: (rating) {
              setState(() {
                inputData[formId][fields.id] = rating.toString();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildDatePicker(Fields fields, int index) {
    print("fjdnfj");
    return ListTile(
      title: Text("Enter date of visit",
          style: TextStyle(
              fontFamily: 'Poppins-Medium',
              fontWeight: FontWeight.bold,
              fontSize: 13.0,
              color: Colors.black)),
      trailing: FlatButton(
        child: Text(
          "Pick Date",
          style: TextStyle(color: Colors.blue),
        ),
        onPressed: () {
          _selectDate(context: context, fields: fields, index: index);
          setState(() {});
        },
      ),
    );
  }

  Widget buildShortText(Fields fields, int index) {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      child: TextField(
        controller: TextEditingController()
          ..text = inputData[formId][fields.id] ?? "",
        onChanged: (text) {
          inputData[formId][fields.id] = text;
        },
        keyboardType: TextInputType.text,
        style: TextStyle(
            fontFamily: 'Poppins-Medium',
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
            color: Colors.black),
        decoration: InputDecoration(
            labelText: 'NAME',
            labelStyle: TextStyle(
                fontFamily: 'Poppins-Medium',
                fontWeight: FontWeight.bold,
                color: Colors.grey),
            hintText: '${fields.title}',
            hintStyle: TextStyle(
                fontFamily: 'Poppins-Medium',
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.black54),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue))),
      ),
    );
  }

  Widget buildPhoneNumber(Fields fields, int index) {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      child: TextField(
        controller: TextEditingController()
          ..text = inputData[formId][fields.id] ?? "",
        maxLength: 10,
        onChanged: (text) {
          inputData[formId][fields.id] = text;
        },
        keyboardType: TextInputType.phone,
        style: TextStyle(
            fontFamily: 'Poppins-Medium',
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
            color: Colors.black),
        decoration: InputDecoration(
            labelText: 'PHONE NUMBER',
            labelStyle: TextStyle(
                fontFamily: 'Poppins-Medium',
                fontWeight: FontWeight.bold,
                color: Colors.grey),
            hintText: '${fields.title}',
            hintStyle: TextStyle(
                fontFamily: 'Poppins-Medium',
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.black54),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue))),
      ),
    );
  }

  Widget buildNumber(Fields fields, int index) {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      child: TextField(
        controller: TextEditingController()
          ..text = inputData[formId][fields.id] ?? "",
        onChanged: (text) {
          inputData[formId][fields.id] = text;
        },
        keyboardType: TextInputType.number,
        style: TextStyle(
            fontFamily: 'Poppins-Medium',
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
            color: Colors.black),
        decoration: InputDecoration(
            labelText: 'AGE',
            labelStyle: TextStyle(
                fontFamily: 'Poppins-Medium',
                fontWeight: FontWeight.bold,
                color: Colors.grey),
            hintText: '${fields.title}',
            hintStyle: TextStyle(
                fontFamily: 'Poppins-Medium',
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.black54),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue))),
      ),
    );
  }

  Widget buildEmail(Fields fields, int index) {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      child: TextField(
        controller: TextEditingController()
          ..text = inputData[formId][fields.id] ?? "",
        onChanged: (text) {
          inputData[formId][fields.id] = text;
        },
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
            fontFamily: 'Poppins-Medium',
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
            color: Colors.black),
        decoration: InputDecoration(
            labelText: 'EMAIL',
            labelStyle: TextStyle(
                fontFamily: 'Poppins-Medium',
                fontWeight: FontWeight.bold,
                color: Colors.grey),
            hintText: '${fields.title}',
            hintStyle: TextStyle(
                fontFamily: 'Poppins-Medium',
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.black54),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue))),
      ),
    );
  }

  Widget buildDropdown(Fields fields, int index) {
    List<DropdownMenuItem<String>> items = [];
    fields.properties['choices'].forEach((_) {
      DropdownMenuItem<String> t = DropdownMenuItem<String>(
        value: _['label'].toString(),
        child: Text(
          _['label'].toString(),
        ),
      );
      items.add(t);
    });

    return Container(
        child: DropdownButton<String>(
      items: items,
      value: inputData[formId][fields.id] ?? "Male",
      onChanged: (value) {
        print("${inputData[formId][fields.id]}");
        setState(() {
          print("Heelo");
          inputData[formId][fields.id] = value;
        });
        build(context);
      },
    ));
  }

  Widget buildYesNo(Fields fields, int index) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          Text(
            "${fields.title}",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Poppins-Medium',
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.black),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: 50.0,
            child: Row(
              children: <Widget>[
                FlatButton(
                  color: Colors.green,
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    inputData[formId][fields.id] = "yes";
                  },
                ),
                Expanded(
                  child: Container(),
                ),
                FlatButton(
                  color: Colors.red,
                  child: Text(
                    "No",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    inputData[formId][fields.id] = "no";
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  showSnackBar(msg) {
    final snackBar = SnackBar(
      backgroundColor: Colors.blue,
      content: Text('$msg',
          style: TextStyle(
              fontFamily: 'Poppins-Medium',
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
              color: Colors.white)),
      action: SnackBarAction(
        label: 'Ok',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
    return snackBar;
  }

  submitData() {
    final snackBar = SnackBar(
      backgroundColor: Colors.green,
      content: Text('Are you want to submit your data?',
          style: TextStyle(
              fontFamily: 'Poppins-Medium',
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
              color: Colors.white)),
      action: SnackBarAction(
        label: 'Yes',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
    return snackBar;
  }
}
