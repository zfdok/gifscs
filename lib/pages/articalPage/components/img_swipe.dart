import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class ImgSwiper extends StatefulWidget {
  final List<dynamic> datas;
  final String articalShare;
  ImgSwiper({Key key, @required this.datas, @required this.articalShare})
      : super(key: key);
  @override
  _ImgSwiperState createState() => _ImgSwiperState();
}

class _ImgSwiperState extends State<ImgSwiper> {
  String imgDesc = "";
  String imgSecretCode = "";
  bool showSecretFlag = false;
  bool showArticalContent = false;

  Widget bottomWidget =
      new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
    ///loading框
    new SpinKitThreeBounce(color: Color(0xFF24292E)),
    new Container(
      width: 5.0,
    ),
  ]);

  _setIndex(int index) async {
    try {
      setState(() {
        showSecretFlag = false;
        imgDesc = widget.datas[index]['desc'];
        imgSecretCode = widget.datas[index]['secret_code'];
      });
    } catch (err) {
      print(err);
    }
  }

  void _showShareDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('阅读次数已达上限'),
            content: Container(
              height: 1400.w,
              child: Column(
                children: [
                  Text(
                    "抱歉打断您,阅读次数已达上限\r\n您的分享真的非常重要",
                    style: TextStyle(fontSize: 65.w, color: Colors.indigo),
                  ),
                  Container(
                    child: Image.network(
                        "https://www.picnew.org/images/2020/11/28/-1534f1.png"),
                  ),
                  Text(
                    "\r\n分享到qq群增加您到阅读次数\r\n\r\n",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  Container(
                    child: Text(
                        "👉您的专属链接已自动复制👈\r\n⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️\r\n"),
                  ),
                  Container(
                    child: Text(widget.articalShare),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: widget.articalShare));
                  _openQQ();
                  Navigator.pop(context);
                },
                child: Text('自动复制并分享到qq群'),
              ),
            ],
          );
        });
  }

  void _openQQ() async {
    const url = 'mqq://';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Could not launch $url')));
    }
  }

  @override
  void initState() {
    Timer(Duration(milliseconds: 1000), () {
      setState(() {
        showArticalContent = true;
        imgDesc = widget.datas[0]['desc'];
        imgSecretCode = widget.datas[0]['secret_code'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(1284, 2778), allowFontScaling: true);
    return Stack(
      children: [
        Visibility(
            visible: !showArticalContent,
            child: Column(
              children: [
                SizedBox(
                  height: 300.w,
                ),
                bottomWidget,
              ],
            )),
        Visibility(
            visible: showArticalContent,
            child: Column(
              children: [
                Container(
                  height: 1000.w,
                  child: Swiper(
                    onIndexChanged: _setIndex,
                    itemBuilder: (BuildContext context, int index) {
                      //条目构建函数传入了index,根据index索引到特定图片
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          bottomWidget,
                          Image.network(
                            widget.datas[index]['url'],
                            fit: BoxFit.cover,
                          ),
                        ],
                      );
                    },
                    itemCount: widget.datas.length,
                    pagination: new SwiperPagination(), //这些都是控件默认写好的,直接用
                    control: new SwiperControl(),
                    viewportFraction: 0.8,
                    scale: 0.8,
                  ),
                ),
                Container(
                  height: 200.w,
                  alignment: Alignment.center,
                  child: Text(
                    imgDesc != null ? imgDesc : "???",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 60.w),
                  ),
                ),
                Stack(
                  children: [
                    Visibility(
                      visible: !showSecretFlag,
                      child: Container(
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          child: SizedBox(
                            height: 100,
                            child: ListTile(
                              onTap: () {
                                Random _random = new Random();
                                if (_random.nextInt(100) < 9) {
                                  _showShareDialog();
                                }
                                setState(() {
                                  showSecretFlag = true;
                                });
                              },
                              title: Center(
                                child: Text(
                                  "获取番号",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 40, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: showSecretFlag,
                      child: Container(
                        child: Card(
                          color: Colors.red,
                          child: SizedBox(
                            height: 100,
                            child: ListTile(
                              onTap: () {
                                if (imgSecretCode != null) {
                                  Clipboard.setData(
                                      ClipboardData(text: imgSecretCode));
                                  Clipboard.getData(Clipboard.kTextPlain)
                                      .then((value) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text(
                                            "已复制神秘代码:${value.text} 到剪贴板")));
                                  });
                                } else {
                                  Scaffold.of(context).showSnackBar(
                                      SnackBar(content: Text("复制错误,请检查网络")));
                                }
                              },
                              title: Center(
                                child: Text(
                                  imgSecretCode != null ? imgSecretCode : "???",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 40),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              trailing: Text(
                                "复\r\n制",
                                style: TextStyle(color: Colors.white60),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ))
      ],
    );
  }
}
