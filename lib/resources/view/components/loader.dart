import 'package:flutter/cupertino.dart';

class Loader extends StatelessWidget {
  const Loader({
    Key? key,
    required this.isLoading,
    this.text,
  }) : super(key: key);

  final bool isLoading;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isLoading,
      child: Column(
        children: [
          const CupertinoActivityIndicator(),
          Text(text ?? 'Please wait'),
        ],
      ),
    );
  }
}
