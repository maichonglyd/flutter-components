import 'dart:ui';

import 'package:app/r.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'common.dart';

class DropdownItem {
  final String label;
  final dynamic value;
  DropdownItem({this.label, this.value});
}

class Dropdown<T> extends HookWidget {
  final String hintText;
  final dynamic value;
  final bool disabled;
  final Function(dynamic v) onChange;
  final List<DropdownItem> options;
  final bool multi;
  Dropdown({
    this.value,
    this.hintText = '请选择',
    this.onChange,
    this.disabled = false,
    this.options,
    this.multi = false,
  });
  final GlobalKey _gk = GlobalKey(debugLabel: 'dropdown');
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final showMenuState = useState(false);
    final overlayEntry = useState<OverlayEntry>();

    List<dynamic> select;
    if (this.value is List) {
      select = value;
    } else if (this.value != null) {
      select = [this.value];
    } else {
      select = [];
    }

    useEffect(() {
      return () {
        _controller.dispose();
      };
    }, []);

    handleItemTap([item]) {
      if (this.disabled) return;
      showMenuState.value = false;

      if (overlayEntry.value != null) {
        overlayEntry.value.remove();
        overlayEntry.value = null;
      }
      if (item != null && this.onChange != null) {
        if (!this.multi) return this.onChange(item.value);
        List<dynamic> tmpSelect = select.toList();
        var find =
            select.firstWhere((i) => i == item.value, orElse: () => null);
        if (find == null) {
          tmpSelect.add(item.value);
        } else {
          tmpSelect.remove(find);
        }
        this.onChange(tmpSelect);
      }
    }

    Widget buildItem(item) {
      bool isSelect = select.contains(item.value);
      return GestureDetector(
        child: Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border(bottom: borderSide()),
            color: isSelect ? Colors.blue.shade300 : Colors.white,
          ),
          padding: EdgeInsets.only(left: rpx(32), right: rpx(32)),
          height: rpx(88),
          child: text(
            '${item.label}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            color: isSelect ? Colors.white : Colors.black,
          ),
        ),
        onTap: () => handleItemTap(item),
      );
    }

    OverlayEntry getOverlayEntry() {
      RenderBox renderBox = _gk.currentContext.findRenderObject();
      var menuSize = renderBox.size;
      var menuPosition = renderBox.localToGlobal(Offset.zero);
      return OverlayEntry(
        builder: (context) => GestureDetector(
          onTap: handleItemTap, // 重用代码 这里调用itemTap 只是为了让弹窗消失
          child: Material(
            color: Colors.transparent,
            child: Container(
              color: Colors.green.withOpacity(0.01),
              child: Stack(
                children: [
                  Positioned(
                      left: menuPosition.dx,
                      top: menuPosition.dy + menuSize.height,
                      width: menuSize.width,
                      height: rpx(440),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            left: borderSide(),
                            right: borderSide(),
                            bottom: borderSide(),
                          ),
                        ),
                        child: ListView(
                          controller: _controller,
                          padding: EdgeInsets.zero,
                          children: List.generate(this.options.length ?? 0,
                              (index) => buildItem(this.options[index])),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      );
    }

    handleShowMenu() async {
      if (this.disabled) return;
      if (showMenuState.value) {
        handleItemTap(); // 重用代码 这里调用itemTap 只是为了让弹窗消失
      } else {
        var overlayState = Overlay.of(context);
        showMenuState.value = true;
        overlayEntry.value = getOverlayEntry();
        overlayState.insert(overlayEntry.value);
        if ((this.options.length ?? 0) > 5 &&
            this.value != null &&
            this.value is! List) {
          await Future.delayed(Duration(milliseconds: 100));
          for (var i = 0; i < this.options.length; i++) {
            if (this.value == this.options[i].value) {
              await _controller.animateTo(
                  rpx((i -
                          5 +
                          (this.options.length - i < 5
                              ? this.options.length - i
                              : 5)) *
                      88.0),
                  duration: Duration(milliseconds: 500),
                  curve: Curves.decelerate);
              break;
            }
          }
        }
      }
    }

    buildValue() {
      var currentList = [];
      this.options.forEach((item) {
        if (select.contains(item.value)) {
          currentList.add(item.label);
        }
      });
      if (!this.multi) {
        var tmpValue =
            currentList.length > 0 ? currentList[0].toString() : this.hintText;
        return Container(
            height: rpx(88),
            alignment: Alignment.centerLeft,
            child: text(
              tmpValue,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              color: (this.disabled || tmpValue == this.hintText)
                  ? Colors.black54
                  : Colors.black,
            ));
      } else {
        if (currentList.length <= 0) {
          return Container(
              height: rpx(56),
              alignment: Alignment.centerLeft,
              child: text(
                this.hintText,
                color: Colors.black54,
              ));
        }
        return Wrap(
          spacing: rpx(16),
          runSpacing: rpx(16),
          alignment: WrapAlignment.start,
          children: List.generate(
            currentList.length,
            (index) => Container(
              height: rpx(56),
              padding: EdgeInsets.fromLTRB(rpx(16), rpx(4), rpx(16), rpx(4)),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.all(Radius.circular(rpx(48))),
              ),
              child: text(
                currentList[index],
                align: TextAlign.center,
                height: 1.5,
                color: this.disabled ? Colors.black54 : Colors.black,
              ),
            ),
          ),
        );
      }
    }

    return GestureDetector(
      onTap: handleShowMenu,
      child: Container(
        color: Colors.white.withOpacity(0.01),
        key: _gk,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: this.multi
                    ? EdgeInsets.only(
                        top: rpx(16), right: rpx(16), bottom: rpx(16))
                    : null,
                child: buildValue(),
                alignment: Alignment.centerLeft,
              ),
            ),
            this.disabled
                ? Container()
                : Container(
                    height: rpx(88),
                    alignment: Alignment.center,
                    child: Container(
                      width: 1,
                      color: Colors.black54,
                      height: rpx(30),
                    )),
            this.disabled
                ? Container()
                : Container(
                    height: rpx(88),
                    alignment: Alignment.center,
                    child: image(
                      showMenuState.value
                          ? R.imagesIconArrowUpPng
                          : R.imagesIconArrowDownPng,
                      rpx(48),
                      rpx(48),
                    )),
          ],
        ),
      ),
    );
  }
}
