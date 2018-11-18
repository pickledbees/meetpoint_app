import 'package:flutter/material.dart';
import 'package:meetpoint/MVC.dart';
import 'SessionView.dart';
import 'package:meetpoint/Managers/SessionManager_Client.dart';

///Represents the [View] portion of the Join Session View.
class JoinSessionView extends View<JoinSessionController> {
  JoinSessionView(c) : super(controller: c);

  ///Builds up [Widget] tree of view.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Join Session'),),
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
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                width: 200.0,
                child: TextFormField(
                  maxLength: 13,
                  maxLengthEnforced: true,
                  textAlign: TextAlign.center,
                  validator: controller.validate,
                  controller: controller.fieldController,
                  decoration: InputDecoration(
                    hintText: 'Session ID',
                  ),
                ),
              ),
              RaisedButton(
                child: Text('Join'),
                onPressed: () => controller.joinSessionAndNavigateToSession(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///Represents the [Controller] portion of the Join Session View.
class JoinSessionController extends Controller<JoinSessionModel> {
  JoinSessionController(m) : super(model: m);
  TextEditingController fieldController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  ///Checks if the 'Session ID' text field is empty.
  String validate(val) {
    if (val.isEmpty) return 'Please fill in session title';
  }

  ///Requests through [SessionManager_Client] to request for a session join on the server side.
  ///Navigates user to [SessionView] of joined session on success.
  joinSessionAndNavigateToSession(BuildContext context) async {

    if (formKey.currentState.validate()) {
      try {
        //show loading text
        model.setHeaderTextTo('Attempting to join session...');
        //join session
        await SessionManager_Client.joinSession(sessionId: fieldController.text);
        //navigate to view
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => SessionView(SessionController(SessionModel(fieldController.text))),
        );
        Navigator.pushReplacement(context, route);
      } catch (e) {
        //show error
        model.setHeaderTextTo('Failed to join session, try again\nError:\n$e');
      }
    }
  }
}

///Represents the [Model] portion of the Join Session View.
class JoinSessionModel extends Model {
  String headerText = 'Key in session ID below';

  ///Changes text prompt above the 'Session ID' text field.
  setHeaderTextTo(String text) {
    setViewState(() => headerText = text);
  }
}