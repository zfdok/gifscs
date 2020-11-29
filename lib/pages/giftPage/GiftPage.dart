import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';

class GiftPage extends StatefulWidget {
  @override
  _GiftPageState createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {
  List giftList = [];

  void _getGiftList() async {
    String url = "http://193.149.161.65:3000/gift";
    Response resp = await Dio().get(url);
    setState(() {
      giftList = resp.data['data'];
      print(giftList.length);
    });
  }

  @override
  void initState() {
    _getGiftList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //自适应
    ScreenUtil.init(context,
        designSize: Size(1284, 2778), allowFontScaling: true);
    return Center(
      child: ListView(
          children: List.generate(giftList.length, (index) {
        return SizedBox(
          // height: 450.w,
          child: InkWell(
            onTap: () => launch(giftList[index]['url']),
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 20.w, 0, 0),
              child: Image.network(
                giftList[index]['src'],
              ),
            ),
          ),
        );
      })),
    );
  }
}
