import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../helpers/http_exception.dart';

import '../providers/auth.dart';

import '../widgets/splashed_flex.dart';
import '../widgets/side_tabbed_title.dart';
import '../widgets/tap_to_action.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

import 'car_info_screen.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _passwordController = TextEditingController();

  final _focusNode = FocusNode();

  bool _obscure = true;

  bool _isLoading = false;

  AuthMode _authMode = AuthMode.Login;

  late AnimationController _controller;

  late Animation<Offset> _slideAnimation;

  late Animation<double> _opacityAnimation;

  Map<String, String> _authData = {
    'name': '',
    'email': '',
    'mobile': '',
    'password': '',
  };

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).login(
          email: (_authData['email'] as String).trim(),
          password: _authData['password'] as String,
        );
      } else {
        Navigator.of(context).pushNamed(CarInfoScreen.routeName);
        await Provider.of<Auth>(context, listen: false).signupWithEmail(
          email: (_authData['email'] as String).trim(),
          password: _authData['password'] as String,
          name: (_authData['name'] as String).trim(),
          mobile: (_authData['mobile'] as String).trim(),
        );
      }
    } on FirebaseAuthException catch (e) {
      var errorMessage = 'Firebase Authentication failed';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      }
      _showErrorDialog(errorMessage);
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      } else if (error.toString().contains('User does not exist')) {
        errorMessage = 'User does not exist.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
      print(error);
    }
    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
    _formKey.currentState!.reset();
    _passwordController.clear();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(-1.5, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.decelerate,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.slowMiddle,
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 70),
            SplashedFlex(),
            SizedBox(height: 40),
            SideTabbedTitle(
              _authMode == AuthMode.Login ? 'Login' : 'Sign Up',
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeIn,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_authMode == AuthMode.Signup)
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: CustomTextField(
                              label: 'Name',
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Field is empty';
                                }
                              },
                              onSaved: (value) {
                                _authData['name'] = value!;
                              },
                            ),
                          ),
                        ),
                      ),
                    if (_authMode == AuthMode.Signup)
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        constraints: BoxConstraints(
                          minHeight: _authMode == AuthMode.Signup ? 24 : 0,
                          maxHeight: _authMode == AuthMode.Signup ? 24 : 0,
                        ),
                        curve: Curves.easeIn,
                      ),
                    CustomTextField(
                      label: 'E-mail',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field is empty';
                        }
                        if (!value.contains('@')) {
                          return 'Invalid email address';
                        }
                      },
                      onSaved: (value) {
                        _authData['email'] = value!;
                      },
                    ),
                    SizedBox(height: 24),
                    if (_authMode == AuthMode.Signup)
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: CustomTextField(
                              label: 'Mobile',
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Field is empty';
                                }
                                if (value.length < 9) {
                                  return 'Invalid mobile number';
                                }
                              },
                              onSaved: (value) {
                                _authData['mobile'] = value!;
                              },
                            ),
                          ),
                        ),
                      ),
                    if (_authMode == AuthMode.Signup)
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        constraints: BoxConstraints(
                          minHeight: _authMode == AuthMode.Signup ? 24 : 0,
                          maxHeight: _authMode == AuthMode.Signup ? 24 : 0,
                        ),
                        curve: Curves.easeIn,
                      ),
                    CustomTextField(
                      label: 'Password',
                      obscure: _obscure,
                      textInputAction: _authMode == AuthMode.Signup
                          ? TextInputAction.next
                          : TextInputAction.done,
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field is empty';
                        }
                        if (value.length < 5) {
                          return 'Password is too short';
                        }
                      },
                      onSaved: (value) {
                        _authData['password'] = value!;
                      },
                      onFieldSubmitted: _authMode == AuthMode.Signup
                          ? (_) {
                              FocusScope.of(context).requestFocus(_focusNode);
                            }
                          : null,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscure = !_obscure;
                          });
                        },
                        icon: Icon(
                          _obscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        color: Color(0xffB8AAA3),
                      ),
                    ),
                    if (_authMode == AuthMode.Signup)
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        constraints: BoxConstraints(
                          minHeight: _authMode == AuthMode.Signup ? 24 : 0,
                          maxHeight: _authMode == AuthMode.Signup ? 24 : 0,
                        ),
                        curve: Curves.easeIn,
                      ),
                    if (_authMode == AuthMode.Signup)
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: CustomTextField(
                              label: 'Confirm Password',
                              obscure: true,
                              textInputAction: TextInputAction.done,
                              focusNode: _focusNode,
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                if (value!.isEmpty) {
                                  return 'Field is empty';
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 36),
                    if (_isLoading)
                      CircularProgressIndicator()
                    else
                      CustomButton(
                        label: _authMode == AuthMode.Login
                            ? 'Enter'
                            : 'Create Account',
                        onTap: _submit,
                      ),
                    SizedBox(height: 16),
                    TapToActionText(
                      label:
                          '${_authMode == AuthMode.Login ? 'Don\'t' : 'Already'} have an account? ',
                      tapLabel:
                          _authMode == AuthMode.Login ? 'Sign up' : 'Login',
                      onTap: _switchAuthMode,
                    ),
                    if (_authMode == AuthMode.Signup)
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        constraints: BoxConstraints(
                          minHeight: _authMode == AuthMode.Signup ? 70 : 0,
                          maxHeight: _authMode == AuthMode.Signup ? 70 : 0,
                        ),
                        curve: Curves.easeIn,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
