import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'mock.dart';

void main() {
  testWidgets('creates a focus node and disposes it', (tester) async {
    FocusNode focusNode;
    await tester.pumpWidget(
      HookBuilder(builder: (_) {
        focusNode = useFocusNode();
        return Container();
      }),
    );

    expect(focusNode, isA<FocusNode>());
    // ignore: invalid_use_of_protected_member
    expect(focusNode.hasListeners, isFalse);

    final previousValue = focusNode;

    await tester.pumpWidget(
      HookBuilder(builder: (_) {
        focusNode = useFocusNode();
        return Container();
      }),
    );

    expect(previousValue, focusNode);
    // ignore: invalid_use_of_protected_member
    expect(focusNode.hasListeners, isFalse);

    await tester.pumpWidget(Container());

    expect(
      // ignore: invalid_use_of_protected_member
      () => focusNode.hasListeners,
      throwsAssertionError,
    );
  });

  testWidgets('default values matches with FocusNode', (tester) async {
    final official = FocusNode();

    FocusNode focusNode;
    await tester.pumpWidget(
      HookBuilder(builder: (_) {
        focusNode = useFocusNode();
        return Container();
      }),
    );

    expect(focusNode.debugLabel, official.debugLabel);
    expect(focusNode.onKey, official.onKey);
    expect(focusNode.skipTraversal, official.skipTraversal);
    expect(focusNode.canRequestFocus, official.canRequestFocus);
    expect(focusNode.descendantsAreFocusable, official.descendantsAreFocusable);
  });

  testWidgets('has all the FocusNode parameters', (tester) async {
    bool onKey(FocusNode node, RawKeyEvent event) => true;

    FocusNode focusNode;
    await tester.pumpWidget(
      HookBuilder(builder: (_) {
        focusNode = useFocusNode(
          debugLabel: 'Foo',
          onKey: onKey,
          skipTraversal: true,
          canRequestFocus: false,
          descendantsAreFocusable: false,
        );
        return Container();
      }),
    );

    expect(focusNode.debugLabel, 'Foo');
    expect(focusNode.onKey, onKey);
    expect(focusNode.skipTraversal, true);
    expect(focusNode.canRequestFocus, false);
    expect(focusNode.descendantsAreFocusable, false);
  });

  testWidgets('handles parameter change', (tester) async {
    bool onKey(FocusNode node, RawKeyEvent event) => true;
    bool onKey2(FocusNode node, RawKeyEvent event) => true;

    FocusNode focusNode;
    await tester.pumpWidget(
      HookBuilder(builder: (_) {
        focusNode = useFocusNode(
          debugLabel: 'Foo',
          onKey: onKey,
          skipTraversal: true,
          canRequestFocus: false,
          descendantsAreFocusable: false,
        );
        return Container();
      }),
    );

    await tester.pumpWidget(
      HookBuilder(builder: (_) {
        focusNode = useFocusNode(
          debugLabel: 'Bar',
          onKey: onKey2,
        );
        return Container();
      }),
    );

    expect(focusNode.onKey, onKey, reason: 'onKey has no setter');
    expect(focusNode.debugLabel, 'Bar');
    expect(focusNode.skipTraversal, false);
    expect(focusNode.canRequestFocus, true);
    expect(focusNode.descendantsAreFocusable, true);
  });
}