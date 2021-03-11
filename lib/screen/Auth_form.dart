import 'dart:io';

import 'package:chat/widgets/piker/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String username,
      File image, bool isLogin, BuildContext ctx) submitFn;
  final bool isLoading;

  AuthForm(this.submitFn, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = "";
  String _password = "";
  String _username = "";
  File _userImageFile;

  void _pickedImage(File pickedImage) {
    _userImageFile = pickedImage;
  }

  void _submit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (!_isLogin && _userImageFile == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Please pick an image."),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(_email.trim(), _password.trim(), _username.trim(),
          _userImageFile, _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.darken),
              image: NetworkImage(
                  "https://image.freepik.com/free-vector/young-adults-colleagues-break-from-work-friends-meeting-coworkers-communication-friendly-conversation-people-drinking-coffee-talking_335657-3564.jpg"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Center(
          child: Card(
            color: Colors.white.withOpacity(.5),
            margin: EdgeInsets.all(20),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isLogin) UserImagePicker(_pickedImage),
                    TextFormField(
                      autocorrect: false,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.none,
                      key: ValueKey('email'),
                      validator: (val) {
                        if (val.isEmpty || !val.contains('@')) {
                          return "Please enter a valid email address";
                        }
                        return null;
                      },
                      onSaved: (val) => _email = val,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: "Email Address"),
                    ),
                    if (!_isLogin)
                      TextFormField(
                        autocorrect: true,
                        enableSuggestions: false,
                        textCapitalization: TextCapitalization.words,
                        key: ValueKey('username'),
                        validator: (val) {
                          if (val.isEmpty || val.length < 4) {
                            return "Please enter at least 4 characters";
                          }
                          return null;
                        },
                        onSaved: (val) => _username = val,
                        decoration: InputDecoration(labelText: "Username"),
                      ),
                    TextFormField(
                      key: ValueKey('password'),
                      validator: (val) {
                        if (val.isEmpty || val.length < 7) {
                          return "Password must be at least 7 characters";
                        }
                        return null;
                      },
                      onSaved: (val) => _password = val,
                      decoration: InputDecoration(labelText: "Password"),
                      obscureText: true,
                    ),
                    SizedBox(height: 12),
                    if (widget.isLoading) CircularProgressIndicator(),
                    if (!widget.isLoading)
                      RaisedButton(
                        color: Colors.pink,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Text(_isLogin ? 'Login' : 'Sign Up'),
                        onPressed: _submit,
                      ),
                    if (!widget.isLoading)
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Text(_isLogin
                            ? 'Create new account'
                            : 'I already have an account'),
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
