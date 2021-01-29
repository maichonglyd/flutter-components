import 'package:app/components/Dropdown.dart';
import 'package:app/components/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final dropdownState = useState();
    return Scaffold(
      appBar: AppBar(title: text('home')),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(rpx(20)),
            child: Dropdown(
              value: dropdownState.value,
              options: [1, 2, 3, 4, 5, 6, 7, 8, 9]
                  .map((e) => DropdownItem(label: '第$e项', value: e))
                  .toList(),
              multi: true,
              onChange: (v) => dropdownState.value = v,
            ),
          )
        ],
      ),
    );
  }
}
