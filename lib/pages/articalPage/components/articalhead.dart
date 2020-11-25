import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArticalHead extends StatelessWidget {
  final String articalTitle;
  final String articalDate;
  final String articalRead;
  ArticalHead(
      {Key key,
      @required this.articalTitle,
      @required this.articalDate,
      @required this.articalRead})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(1284, 2778), allowFontScaling: true);
    return Container(
      child: Center(
        child: Card(
            color: Colors.white70,
            margin: EdgeInsets.fromLTRB(30.w, 50.w, 30.w, 60.w),
            elevation: 20.w,
            child: Padding(
              padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 0),
              child: ListTile(
                title: Text(
                  articalTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 25),
                ),
                subtitle: Row(
                  children: [
                    Text("$articalDate"),
                    Expanded(child: SizedBox()),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "阅: $articalRead  ",
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
                contentPadding: EdgeInsets.all(10),
              ),
            )),
      ),
    );
  }
}
