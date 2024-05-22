import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [LoginBlock()],
    );
  }
}

class LoginBlock extends StatelessWidget {
  const LoginBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'ID',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'password',
            ),
          )
        ],
      ),
    );
  }
}
