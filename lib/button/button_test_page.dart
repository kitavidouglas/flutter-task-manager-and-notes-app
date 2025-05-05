import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'button.dart';

class ButtonTestPage extends StatelessWidget {
  const ButtonTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Button Test Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomButton(label: 'Primary', onPressed: dummyFunction),
            const SizedBox(height: 10),
            const CustomButton(
                label: 'Secondary',
                onPressed: dummyFunction,
                type: ButtonType.secondary),
            const SizedBox(height: 10),
            const CustomButton(
                label: 'Destructive',
                onPressed: dummyFunction,
                type: ButtonType.destructive),
            const SizedBox(height: 10),
            const CustomButton(
                label: 'Outline',
                onPressed: dummyFunction,
                type: ButtonType.outline),
            const SizedBox(height: 10),
            const CustomButton(
                label: 'Ghost',
                onPressed: dummyFunction,
                type: ButtonType.ghost),
            const SizedBox(height: 10),
            const CustomButton(
                label: 'Link', onPressed: dummyFunction, type: ButtonType.link),
            const SizedBox(height: 10),
            CustomButton(
              label: 'Icon Button',
              onPressed: dummyFunction,
              type: ButtonType.outline,
              icon: Icon(LucideIcons.chevronRight),
            ),
            const SizedBox(height: 10),
            const CustomButton(
              label: 'Login with Email',
              onPressed: dummyFunction,
              icon: Icon(LucideIcons.mail),
            ),
            const SizedBox(height: 10),
            const CustomButton(
                label: 'Loading', onPressed: dummyFunction, isLoading: true),
            const SizedBox(height: 10),
            const CustomButton(
                label: 'Gradient with Shadow',
                onPressed: dummyFunction,
                type: ButtonType.gradient),
          ],
        ),
      ),
    );
  }

  static void dummyFunction() {
    debugPrint('Button pressed');
  }
}
