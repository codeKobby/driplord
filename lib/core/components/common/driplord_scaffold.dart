import 'package:flutter/material.dart';

class DripLordScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final bool showAbstractShapes;
  final bool useSafeArea;

  const DripLordScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.showAbstractShapes = true,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: useSafeArea ? SafeArea(child: body) : body,
    );
  }
}
