import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safekids/providers/User.dart';
import '../auth.dart';

enum UserType { parent, child }

UserType _selectedUserType = UserType.parent; // Default to parent

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage ='';
  bool isLogin = true ;
   bool _passwordVisible = false;
   final GlobalKey<FormState> _formKey = GlobalKey();
   var _isloading = false;
    UserDTO _user = UserDTO();






// final TextEditingController  _controllerEmail = TextEditingController();
// final TextEditingController  _controllerPassword = TextEditingController();
  
  Future<void> signInWithEmailAndPassword (email,password) async { try {
    await Auth().signInWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch(e) {setState(() {
    errorMessage = e.message;
  });}}

   Future<void> createUserWithEmailAndPassword (email,password) async { try {
    await Auth().createUserWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch(e) {setState(() {
    errorMessage = e.message;
  });}}


    Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      _formKey.currentState!.save();
      setState(() {
        _isloading = true;
      });

     signInWithEmailAndPassword(_user.email,_user.password) ;
     Navigator.pushReplacementNamed(context, '/homepage');
      // await Provider.of<Auth>(context, listen: false).login(_user);
      // print('this is after submit');
      // var role = Provider.of<Auth>(context, listen: false).userRole;
      // if (role == "1") {
      //   Navigator.of(context).popAndPushNamed(MapScreen.routeName);
      // } else {
      //   Navigator.of(context).popAndPushNamed(AgentTransactionsList.routeName);
      // }
    } catch (error) {
      // String? err = Provider.of<Auth>(context, listen: false).erorrMsg;
      // const errorMessage = 'Could not authenticate you. Please try again.';
      // if (err.toString().contains("Email Invalid")) {
      //   _showErrorDialog("Email is Invalid");
      // }
      // if (err.toString().contains("password")) {
      //   _showErrorDialog("Password is Incorrect");
      // }
    }
    setState(() {
      _isloading = false;
    });
  }




  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    void togglePasswordVisibility() {
      setState(() {
        _passwordVisible = !_passwordVisible;
      });
    }

    return MaterialApp(
      home:Scaffold(
        body: SingleChildScrollView(
          
          
          child:Container(
            width: double.infinity,
          height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
            child:Center(
              heightFactor: 1.0,
              child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height:  200),
                        Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                    color: const Color(0xFFF1E6FF),
                    borderRadius: BorderRadius.circular(29)),
                child: TextFormField(
                  onSaved: (value) => {_user.email = value},
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email is invalid';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  cursorColor: const Color(0xFF6F35A5),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(17),
                    border: InputBorder.none,
                    hintText: "Your email",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(16),
                      child: Icon(Icons.person, color: Color(0xFF6F35A5)),
                    ),
                  ),
                ),
              ),
                        ),
                        Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: const Color(0xFFF1E6FF),
                    borderRadius: BorderRadius.circular(29)),
                child: TextFormField(
                  onSaved: (value) => {_user.password = value},
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password is invalid';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  obscureText: !_passwordVisible,
                  cursorColor: const Color(0xFF6F35A5),
                  decoration: InputDecoration(
                    suffix: GestureDetector(
                      onTap: () => {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                          print(_passwordVisible);
                        })
                      },
                      child: Icon(
                        color: const Color(0xFF6F35A5),
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                    border: InputBorder.none,
                    hintText: "Your password",
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Icon(
                        Icons.lock,
                        color: Color(0xFF6F35A5),
                      ),
                    ),
                  ),
                ),
              ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedUserType = UserType.parent;
                      });
                      _submit();
                    },
                    child: const Text("Login as Parent"),
                  ),
                  const SizedBox(width: 16), // Add spacing between buttons
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedUserType = UserType.child;
                      });
                      _submit();
                    },
                    child: const Text("Login as Child"),
                  ),
                ],
              ),
                        //   const SizedBox(height: 16),
                        //    Container(
                        //   decoration: BoxDecoration(
                        //       color: const Color(0xFF6F35A5),
                        //       borderRadius: BorderRadius.circular(29)),
                        //   width: size.width * 0.8,
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.circular(29),
                        //     child: TextButton(
                        //       style: TextButton.styleFrom(
                        //         backgroundColor: const Color(0xFF6F35A5),
                        //         foregroundColor: Colors.white,
                        //       ),
                        //       onPressed: () {
                        //         setState(() {
                        //           isLogin = !isLogin;
                        //         });
                        //       },
                        //       child: _isloading
                        //           ? const CircularProgressIndicator(
                        //               color: Color.fromRGBO(252, 139, 124, 1.0))
                        //           : Text(
                        //               isLogin ? "Register instead".toUpperCase() : "Login instead".toUpperCase(),
                        //               style: const TextStyle(
                        //                 fontFamily: 'Lato',
                        //               ),
                        //             ),
                        //     ),
                        //   ),
                        // ),
                        Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () {
                  // Navigator.pushNamed(context, ForgotPasswordScreen.routeName);
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Colors.grey[600],
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
            )))));
  }
}