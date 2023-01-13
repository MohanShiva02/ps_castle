
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomWidget extends StatelessWidget {

  final double width;
  final double height;

  const CustomWidget.rectangular({
    this.width = double.infinity,
    @required this.height
});


  @override
  Widget build(BuildContext context)  => Shimmer.fromColors(
    baseColor: Color.fromRGBO(45, 47, 49, 1.0),
    highlightColor: Colors.grey[500],
    period: Duration(seconds: 2),
    child: Container(
      // padding: const EdgeInsets.all(10),
      // margin: EdgeInsets.all(10),
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.grey[400],
      ),
    ),
  );
}
