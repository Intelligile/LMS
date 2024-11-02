// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lms/core/functions/show_snack_bar.dart';
// import 'package:lms/core/utils/app_router.dart';
// import 'package:lms/core/widgets/build_text_field.dart';
// import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart';

// class SignInForm extends StatefulWidget {
//   final TextEditingController usernameController;
//   final TextEditingController passwordController;
    
//   const SignInForm({
//     super.key,
//     required this.usernameController,
//     required this.passwordController,
//   });

//   @override
//   State<SignInForm> createState() => _SignInFormState();
// }

// class _SignInFormState extends State<SignInForm> {
//   final _formKey = GlobalKey<FormState>();
//   // GlobalKey for the form
//   bool? isLicensor = false;

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<SignInCubit, SignInState>(
//       listener: (context, state) {
//         if (state is SignInSuccess) {
//           showSnackBar(context, 'Sign-in successful', Colors.green);
//           GoRouter.of(context).push(AppRouter.kHomeView);
//         } else if (state is SignInFailure) {
//           showSnackBar(context, state.error, Colors.red);
//         }
//       },
//       child: SingleChildScrollView(
//         // Use SingleChildScrollView to avoid overflow
//         child: Column(
//           children: [
//             // Radio buttons without Expanded
//             RadioListTile<bool>(
//               title: const Text('Licensee'),
//               value: false, // Licensee corresponds to false
//               groupValue: isLicensor,
//               onChanged: (bool? value) {
//                 setState(() {
//                   isLicensor = value;
//                 });
//               },
//             ),
//             RadioListTile<bool>(
//               title: const Text('Licensor'),
//               value: true, // Licensor corresponds to true
//               groupValue: isLicensor,
//               onChanged: (bool? value) {
//                 setState(() {
//                   isLicensor = value;
//                 });
//               },
//             ),

//             Form(
//               key: _formKey, // Assign the key to the Form
//               child: Column(
//                 children: [
//                   buildAuthTextField(
//                       controller: widget.usernameController, label: 'Username'),
//                   buildAuthTextField(
//                       controller: widget.passwordController,
//                       label: 'Password',
//                       obscureText: true),
//                   BlocBuilder<SignInCubit, SignInState>(
//                     builder: (context, state) {
//                       return ElevatedButton(
//                         onPressed: () {
//                           if (_formKey.currentState!.validate()) {
//                             // Validate the form
//                             context.read<SignInCubit>().signIn(
//                                 username: widget.usernameController.text,
//                                 password: widget.passwordController.text,
//                                 isLicensor: isLicensor!);
//                           }
//                         },
//                         child: state is SignInLoading
//                             ? const CircularProgressIndicator()
//                             : const Text('Sign In'),
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   TextButton(
//                     onPressed: () {
//                       context.go('/forgot-password');
//                     },
//                     child: const Text("Forgot Password?",
//                         style: TextStyle(color: Colors.blue)),
//                   ),
//                   const SizedBox(height: 10),
//                   const SignInAlternative(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SignInAlternative extends StatelessWidget {
//   const SignInAlternative({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         const Text("Don't have an account?"),
//         TextButton(
//           onPressed: () {
//             GoRouter.of(context).push(AppRouter.kRegister);
//           },
//           child: const Text("Register", style: TextStyle(color: Colors.blue)),
//         ),
//       ],
//     );
//   }
// }
