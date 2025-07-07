import 'package:flutter/material.dart';

class OtpField extends StatefulWidget {
  final Function(String) onSubmit;
  final Function(String) onChange;
  final int length;

  const OtpField({
    super.key,
    required this.onSubmit,
    required this.onChange,
    this.length = 6,
  });

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  void _onChanged(String value, int index) {
    widget.onChange(_getOtp());
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (_getOtp().length == widget.length) {
      widget.onSubmit(_getOtp());
    }
  }

  String _getOtp() {
    return _controllers.map((e) => e.text).join();
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 40,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: const TextStyle(fontSize: 20),
            onChanged: (value) => _onChanged(value, index),
            decoration: const InputDecoration(
              counterText: "",
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.teal, width: 2),
              ),
            ),
          ),
        );
      }),
    );
  }
}
