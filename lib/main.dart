import 'package:flutter/material.dart';
import 'package:hidden_local_storage/hidden.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Flutter Form';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MyCustomForm(),
      ),
      routes: <String, WidgetBuilder>{
        HiddenPage.routeName: (BuildContext context) => const HiddenPage()
      },
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class, which holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  late int wasClicked;
  DateTime? previousClickTime;
  DateTime? currentClickTime;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    previousClickTime = null;
    wasClicked = 0;
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Column(children: [
      Expanded(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Your Name',
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A message for Coding Ninjas';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.phone),
                  hintText: 'Enter a phone number',
                  labelText: 'Phone',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter valid phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  hintText: 'Enter your date of birth',
                  labelText: 'Dob',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter valid date';
                  }
                  return null;
                },
              ),
              Container(
                  padding: const EdgeInsets.only(left: 130.0, top: 40.0),
                  child: ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () {
                      // It returns true if the form is valid, otherwise returns false

                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a Snackbar.
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Data is in processing.')));
                      }
                    },
                  )),
            ],
          ),
        ),
      ),
      Container(
        // color: Colors.pink,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Opacity(
            opacity: 0,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  currentClickTime = DateTime.now();
                });
                print("time $wasClicked $currentClickTime $previousClickTime");

                if (previousClickTime != null &&
                    currentClickTime!
                            .difference(previousClickTime!)
                            .inSeconds >=
                        1) {
                  setState(() {
                    wasClicked = 0;
                  });
                } else {
                  setState(() {
                    wasClicked++;
                  });
                }

                // Update the previous click time with the current click time
                previousClickTime = currentClickTime;

                if (wasClicked == 10) {
                  Navigator.of(context).pushNamed(HiddenPage.routeName);
                }
              },
              child: const Text("Navigate"),
            ),
          ),
        ),
      ),
    ]);
  }
}
