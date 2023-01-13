import 'package:flutter/material.dart';
import 'package:onwords_home/product_page/tank_pro_page.dart';

import 'gate_page.dart';

class DevicePages extends StatefulWidget {
  final bool wta;
  final bool gate;
  const DevicePages({Key key, this.wta, this.gate}) : super(key: key);

  @override
  State<DevicePages> createState() => _DevicePagesState();
}

class _DevicePagesState extends State<DevicePages> {
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return PageView(
      scrollDirection: Axis.vertical,
      controller: controller,
      children: <Widget>[
        if(widget.wta??false)
          TankPro(deviceName: "Water tank ",),
        if(widget.gate??false)
          GateLock(deviceName: "Gate ",),
      ],
    );
  }
}
