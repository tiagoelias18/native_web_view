import 'package:flutter/material.dart';

class LoadingWebview extends StatelessWidget {
  final Stream<bool> stream;
  final Widget? loadingPage;

  const LoadingWebview({Key? key, required this.stream, this.loadingPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: stream,
      initialData: true,
      builder: (context, snapshot) {
        if (snapshot.data!) {
          return loadingPage ?? const SizedBox.shrink();
        }
        return const SizedBox.shrink();
      },
    );
  }
}
