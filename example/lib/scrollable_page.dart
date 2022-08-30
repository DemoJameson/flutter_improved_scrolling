import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';

class CustomScrollBehaviour extends MaterialScrollBehavior {
  const CustomScrollBehaviour();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    switch (getPlatform(context)) {
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
        return Scrollbar(
          controller: details.controller,
          thumbVisibility: true,
          child: child,
        );
      case TargetPlatform.windows:
        return Scrollbar(
          controller: details.controller,
          thumbVisibility: true,
          radius: Radius.zero,
          thickness: 16.0,
          hoverThickness: 16.0,
          trackVisibility: true,
          child: child,
        );
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
        return child;
    }
  }
}

class ScrollablePage extends StatefulWidget {
  const ScrollablePage({Key? key}) : super(key: key);

  @override
  _ScrollablePageState createState() => _ScrollablePageState();
}

class _ScrollablePageState extends State<ScrollablePage> {
  final scrollControllerVertical = ScrollController();
  final scrollControllerVertical2 = ScrollController();
  final scrollControllerHorizontal = ScrollController();
  final scrollControllerHorizontal2 = ScrollController();

  bool get isDesktop =>
      Theme.of(context).platform == TargetPlatform.linux ||
      Theme.of(context).platform == TargetPlatform.macOS ||
      Theme.of(context).platform == TargetPlatform.windows;

  TextStyle? get textStyleBig => Theme.of(context).textTheme.headline5;
  TextStyle? get textStyleMedium => Theme.of(context).textTheme.headline6;
  TextStyle? get textStyleSmall => Theme.of(context).textTheme.bodyText2;

  Axis axis = Axis.vertical;
  bool useSystemCursor = false;
  bool accelerated = true;

  void toggleAccelerated() {
    setState(() {
      accelerated = !accelerated;
      showSnackBar('accelerated: $accelerated');
    });
  }

  void toggleCursor() {
    setState(() {
      useSystemCursor = !useSystemCursor;
      showSnackBar('useSystemCursor: $useSystemCursor');
    });
  }

  void toggleAxis() {
    setState(() {
      if (axis == Axis.vertical) {
        axis = Axis.horizontal;
      } else {
        axis = Axis.vertical;
      }
      showSnackBar('axis: $axis');
    });
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), duration: const Duration(milliseconds: 1000),));
  }

  @override
  void dispose() {
    scrollControllerVertical.dispose();
    scrollControllerVertical2.dispose();
    scrollControllerHorizontal.dispose();
    scrollControllerHorizontal2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildHeader(),
          const Divider(
            thickness: 5.0,
            color: Colors.grey,
          ),
          if (axis == Axis.vertical)
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: buildScrollingView(
                      Axis.vertical,
                      scrollControllerVertical,
                    ),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    child: buildScrollingView(
                      Axis.vertical,
                      scrollControllerVertical2,
                    ),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: buildScrollingView(
                      Axis.horizontal,
                      scrollControllerHorizontal,
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: buildScrollingView(
                      Axis.horizontal,
                      scrollControllerHorizontal2,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              onPressed: toggleAxis,
              label: const Text('Toggle axis'),
              backgroundColor: Colors.black,
              heroTag: 'FirstFAB',
            ),
            const SizedBox(height: 10.0),
            FloatingActionButton.extended(
              onPressed: toggleCursor,
              label: const Text('Toggle cursor'),
              backgroundColor: Colors.black,
              heroTag: 'SecondFAB',
            ),
            const SizedBox(height: 10.0),
            FloatingActionButton.extended(
              onPressed: toggleAccelerated,
              label: const Text('Toggle accelerated'),
              backgroundColor: Colors.black,
              heroTag: 'ThirdFAB',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Card(
      margin: const EdgeInsets.all(12.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Advanced scrolling for Flutter web and desktop',
                    style: textStyleBig,
                  ),
                  Text(
                    '  1. Scroll using middle mouse button:',
                    style: textStyleMedium,
                  ),
                  Text(
                    '          - Tap MMB --> Drag --> Tap MMB, or',
                    style: textStyleSmall,
                  ),
                  Text(
                    '          - Press and hold MMB --> Drag --> Release MMB',
                    style: textStyleSmall,
                  ),
                  Text(
                    '          - Can use default system cursors,'
                    ' or custom Widget cursor',
                    style: textStyleSmall,
                  ),
                  Text(
                    '  2. Scroll using keyboard (the scrollable'
                    ' widget must have focus):',
                    style: textStyleMedium,
                  ),
                  Text(
                    '          - Arrows (up, down, left, right)',
                    style: textStyleSmall,
                  ),
                  Text(
                    '          - Space, Shift + Space (reverse)',
                    style: textStyleSmall,
                  ),
                  Text(
                    '          - PageUp, PageDown, End, Home',
                    style: textStyleSmall,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '3. Can also programatically scroll using mouse wheel\n'
                    '(when using NeverScrollableScrollPhysics)',
                    style: textStyleMedium,
                  ),
                  Text(
                    '4. Supports both vertical and horizontal scrolling,'
                    ' but not at the same time',
                    style: textStyleMedium,
                  ),
                  Text(
                    '5. Check out the console for events log',
                    style: textStyleMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Current scrollables orientation: ${describeEnum(axis)}',
                    style: textStyleSmall,
                  ),
                  Text(
                    'Current cursor type: '
                    '${useSystemCursor ? 'system' : 'custom'}',
                    style: textStyleSmall,
                  ),
                  Text(
                    'Current accelerated: $accelerated', style: textStyleSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildScrollingView(Axis axis, ScrollController controller) {
    return ImprovedScrolling(
      scrollController: controller,
      onScroll: (scrollOffset) => debugPrint(
        'Scroll offset: $scrollOffset',
      ),
      onMMBScrollStateChanged: (scrolling) => debugPrint(
        'Is scrolling: $scrolling',
      ),
      onMMBScrollCursorPositionUpdate: (localCursorOffset, scrollActivity) =>
          debugPrint(
        'Cursor position: $localCursorOffset\n'
        'Scroll activity: $scrollActivity',
      ),
      enableMMBScrolling: true,
      enableKeyboardScrolling: true,
      enableCustomMouseWheelScrolling: true,
      mmbScrollConfig: MMBScrollConfig(
        customScrollCursor:
            useSystemCursor ? null : const DefaultCustomScrollCursor(),
      ),
      keyboardScrollConfig: KeyboardScrollConfig(
        homeScrollDurationBuilder: (currentScrollOffset, minScrollOffset) {
          return const Duration(milliseconds: 100);
        },
        endScrollDurationBuilder: (currentScrollOffset, maxScrollOffset) {
          return const Duration(milliseconds: 2000);
        },
      ),
      customMouseWheelScrollConfig: CustomMouseWheelScrollConfig(
        scrollAmountMultiplier: 4.0,
        scrollDuration: const Duration(milliseconds: 350),
        accelerated: accelerated,
      ),
      child: ScrollConfiguration(
        behavior: const CustomScrollBehaviour(),
        child: GridView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: axis,
          padding: const EdgeInsets.all(24.0),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400.0,
            mainAxisExtent: 400.0,
          ),
          children: buildScrollableItemList(axis),
        ),
      ),
    );
  }

  List<Widget> buildScrollableItemList(Axis axis) {
    final isVertical = axis == Axis.vertical;
    final Size itemsSize;
    if (isVertical) {
      itemsSize = const Size(700.0, 300.0);
    } else {
      itemsSize = const Size(300.0, 500.0);
    }

    return [
      for (var i = 1; i <= 100; i++)
        buildScrollableItem(
          size: itemsSize,
          child: Center(
            child: Text(
              '$i',
              style: textStyleMedium,
            ),
          ),
        ),
    ];
  }

  Widget buildScrollableItem({
    required Size size,
    required Widget child,
  }) {
    return GridTile(
      child: Container(
        margin: const EdgeInsets.only(
          top: 24.0,
          left: 24.0,
          right: 24.0,
        ),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.black.withAlpha(10), width: 2.0),
          color: Colors.white,
        ),
        width: size.width,
        height: size.height,
        child: child,
      ),
    );
  }
}
