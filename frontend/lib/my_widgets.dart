import 'package:flutter/material.dart';
import 'package:frontend/app_state.dart';
import 'package:provider/provider.dart';

class MyPageController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          onPressed: context.watch<AppStateProvider>().page == 1
              ? null
              : () {
                  context.read<AppStateProvider>().incrementPage(-1);
                },
          icon: Icon(Icons.arrow_back),
        ),
        Spacer(),
        Text("page ${context.watch<AppStateProvider>().page}"),
        Spacer(),
        IconButton(
          onPressed: () {
            context.read<AppStateProvider>().incrementPage(1);
          },
          icon: Icon(Icons.arrow_forward),
        ),
      ],
    );
  }
}
