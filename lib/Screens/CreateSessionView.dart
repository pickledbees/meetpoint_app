import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
import 'SessionView.dart';
import 'package:meetpoint/LocalInfoManagers/LocalSessionManager.dart';

class CreateSessionView extends View<CreateSessionController> {

  CreateSessionView(c) : super(controller: c);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CreateSession'),),
      body: Center(
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(
                  controller.model.headerText,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                width: 200.0,
                child: TextFormField(
                  validator: controller.validate,
                  controller: controller.fieldController,
                  decoration: InputDecoration(
                    hintText: 'Session Title',
                  ),
                ),
              ),
              RaisedButton(
                child: Text('Create'),
                onPressed: () => controller.createSession(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateSessionController extends Controller<CreateSessionModel> {

  CreateSessionController(m) : super(model: m);

  TextEditingController fieldController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String validate(val) {
    if (val.isEmpty) return 'Please fill in session title';
  }

  createSession(BuildContext context) async {

    if (formKey.currentState.validate()) {

      try {
        //show loading text
        model.setHeaderTextTo('Creating your session...');

        //create session
        String sessionId =
        await LocalSessionManager.createSession(sessionTitle: fieldController.text);

        //navigate to view
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => SessionView(SessionController(SessionModel(sessionId))),
        );
        Navigator.pushReplacement(context, route);

      } catch (e) {
        //show error
        model.setHeaderTextTo('Failed to create session, try again\nError:\n$e');

      }
    }
  }

}

class CreateSessionModel extends Model {

  String headerText = 'Title your session below';

  setHeaderTextTo(String text) {
    setViewState(() => headerText = text);
  }
}