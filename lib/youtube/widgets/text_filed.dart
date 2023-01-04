import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.hint,
      this.fieldController,
      this.validatior,
      this.onFieldSubmitted,
      this.child})
      : super(key: key);

  final String hint;
  final TextEditingController? fieldController;
  final Widget? child;
  final String? Function(String?)? validatior;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextFormField(
                obscureText: false,
                autocorrect: false,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  hintText: hint,
                  filled: true,
                ),
                controller: fieldController,
                validator: validatior,
                onFieldSubmitted: onFieldSubmitted,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
