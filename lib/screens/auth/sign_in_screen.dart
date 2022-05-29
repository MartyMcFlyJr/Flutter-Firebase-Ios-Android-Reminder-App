import 'package:flutter/material.dart';
import 'package:iosreminder/services/auth_service.dart';
import 'package:lottie/lottie.dart';

class SignInScreen extends StatefulWidget {
  final VoidCallback toggleView;
  const SignInScreen({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () {
              widget.toggleView();
            },
            icon: Icon(Icons.person),
            label: Text('Sign Up'),
          )
        ],
      ),
      body: Column(
        children: [
          Lottie.asset('assets/images/calendar.json', width: 175),
          Text(
            'Yet another Todo List',
            style: Theme.of(context).textTheme.headline6,
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(hintText: 'Enter Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) => val == null || !val.contains('@') ? 'Enter an email address' : null,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(hintText: 'Enter Passwort'),
                        obscureText: true,
                        validator: (val) => val!.length < 6 ? 'Enter a password of at least 6 characters' : null,
                      ),
                      SizedBox(height: 20,),
                      ElevatedButton(onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final user = await AuthService().signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);

                          if (user != null) {
                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                          }
                        }
                      }, child: Text('Sign In'),)
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
