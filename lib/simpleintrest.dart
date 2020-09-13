import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }
}

class _SIFormState extends State<SIForm> {
  var _currencies = ["Rupees", "Dollars", "Pounds"];
  var _formkey = GlobalKey<FormState>();
  double _minPad = 5.0;
  ThemeData themeof;
  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();
  TextStyle textStyle;
  String _currentCurrency;
  @override
  void initState() {
    super.initState();
    _currentCurrency = _currencies[0];
  }

  @override
  Widget build(BuildContext context) {
    themeof = Theme.of(context);
    textStyle = themeof.textTheme.subtitle1;
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple Interest Calculator"),
      ),
      body: Form(
          key: _formkey,
          child: Padding(
            padding: EdgeInsets.all(_minPad * 2),
            child: ListView(
              children: <Widget>[
                getImageAsset("images/money.png"),
                getTextField("Principal", "Enter Principal e.g. 12000",
                    principalController),
                getTextField(
                    "Rate of Interest", "In Percentage", roiController),
                Padding(
                    padding: EdgeInsets.only(top: _minPad, bottom: _minPad),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: getTextField(
                                "Term", "Time in Years", termController)),
                        Container(
                          width: _minPad * 5,
                        ),
                        getDropDown(_currencies),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(top: _minPad, bottom: _minPad),
                    child: Row(children: <Widget>[
                      getButton("Calculate", themeof.accentColor,
                          themeof.primaryColorDark, showResult),
                      getButton("Reset", themeof.primaryColorDark,
                          themeof.primaryColorLight, _reset)
                    ]))
              ],
            ),
          )),
    );
  }

  Widget getDropDown(List<String> list) {
    return Expanded(
        child: DropdownButton<String>(
      items: list
          .map((String value) =>
              DropdownMenuItem<String>(value: value, child: Text(value)))
          .toList(),
      onChanged: (String selectedValue) =>
          setState(() => _currentCurrency = selectedValue),
      value: _currentCurrency,
    ));
  }

  Widget getButton(String label,
      [Color color1, Color color2, Function function]) {
    return Expanded(
        child: RaisedButton(
      color: color1,
      textColor: color2,
      child: Text(
        label,
        textScaleFactor: 1.5,
      ),
      onPressed: () => function(context),
    ));
  }

  Widget getTextField(String label, String hint, TextEditingController c) {
    return Padding(
        padding: EdgeInsets.only(top: _minPad, bottom: _minPad),
        child: TextFormField(
          style: textStyle,
          controller: c,
          validator: (String value) {
            if (value.isEmpty) {
              return "Please Enter Value";
            } else if (double.parse(value, (e) => null) == null) {
              return "Please Enter Valid Value";
            }
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.yellowAccent, fontSize: 15.0),
              labelText: label,
              hintText: hint,
              labelStyle: textStyle,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
        ));
  }

  Widget getImageAsset(String file) {
    AssetImage assetImage = AssetImage(file);
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(_minPad * 10),
    );
  }

  void showResult(BuildContext context) {
    if (_formkey.currentState.validate()) {
      double p = double.parse(principalController.text);
      double r = double.parse(roiController.text);
      double t = double.parse(termController.text);
      double result = (p * r * t) / 100;
      var alertDiag = AlertDialog(
        title: Text("Result"),
        content: Text(
            "Your Interest will be $result $_currentCurrency \nYou have to pay total ${p + result} $_currentCurrency"),
      );
      showDialog(
          context: context, builder: (BuildContext context) => alertDiag);
    }
  }

  void _reset(BuildContext context) {
    principalController.text = "";
    roiController.text = "";
    termController.text = "";
  }
}
