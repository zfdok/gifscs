import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

import 'pages/mainPage/MainPage.dart';
import 'pages/movie/MoviePage.dart';
import 'pages/giftPage/GiftPage.dart';
import 'pages/myPage/MyPage.dart';

String version = "V1.0.1";

//xattr -rc .
//flutter clean
//flutter build apk --target-platform android-arm
void main() {
  runApp(MyApp());
}

//2778×1284像素
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GIF车神",
      theme: ThemeData(
        primaryColor: Colors.indigoAccent,
      ),
      home: MainWidget(),
    );
  }
}

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  int _currentIndex = 0; //buttombar索引
  String _updateURL; //升级用url
  String movieURL = 'http://gifcheshen.com'; //影视url
  final ValueNotifier<bool> versionRight =
      ValueNotifier<bool>(true); //用于监听版本是否一致的 值监听器
  //获取用户ip并记录在登录记录表中
  void _accessAndRec() async {
    String url = "http://gifcheshen.com:3000/login";
    await Dio().get(url);
  }

  //启动弹出框
  void _showAlertDialog({context}) {
    _getVerSion().then((v) {
      if (v.data['version'] == version) {
        //版本正确时弹出到对话框
        String message = v.data['message'];
        List picADList = v.data['pic_ad'];
        showDialog<int>(
            barrierDismissible: false,
            context: context,
            builder: (cxt) {
              return AlertDialog(
                backgroundColor: Theme.of(context).cardColor,
                title: Center(
                  child: Text("公告"),
                ),
                titlePadding: EdgeInsets.all(50.w),
                content: Column(
                  children: [
                    Linkify(
                      text: message,
                      onOpen: _onOpen,
                      style: TextStyle(fontSize: 50.w, height: 5.w),
                    ),
                    Column(
                        children: List.generate(
                      picADList.length,
                      (index) {
                        return InkWell(
                          onTap: () => launch(picADList[index]['url']),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 20.w, 0, 0),
                            child: Image.network(
                              picADList[index]['src'],
                            ),
                          ),
                        );
                      },
                    ))
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("我已知晓")),
                ],
              );
            });
      } else {
        //版本错误时弹出到对话框
        showDialog<int>(
            context: context,
            builder: (cxt) {
              return AlertDialog(
                backgroundColor: Theme.of(context).cardColor,
                title: Center(
                  child: Text("版本更新"),
                ),
                titlePadding: EdgeInsets.all(50.w),
                content: Text('版本更新,需要您升级后使用!'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("下载新版本")),
                ],
              );
            }).then((value) {
          setState(() {
            //更新版本不正确信息
            versionRight.value = false;
          });
        }).then((value) {
          setState(() {
            _updateURL = v.data['updateURL'];
          });
          print(_updateURL);
        }).then((value) => _launchUpdateURL()); //弹出升级页面
      }
    });
  }

  //需要升级时的替换页面
  Widget _getUpdateScreen() {
    return Center(
      child: Text(
        "版本更新,需要您升级后使用!",
        style: TextStyle(fontSize: 70.w),
      ),
    );
  }

//获取版本
  Future _getVerSion() async {
    String url = "http://gifcheshen.com:3000/login/version";
    Response rep = await Dio().get(url);
    return rep;
  }

//超链接跳转到网页 配合flutter_linkify组件
  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }

//跳转到升级网页
  _launchUpdateURL() async {
    if (await canLaunch(_updateURL)) {
      await launch(_updateURL);
    } else {
      throw 'Could not launch $_updateURL';
    }
  }

  //初始化状态
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _showAlertDialog(context: context);
      _accessAndRec();
    });
  }

  @override
  Widget build(BuildContext context) {
    //自适应
    ScreenUtil.init(context,
        designSize: Size(1284, 2778), allowFontScaling: true);
    //返回组件
    return Scaffold(
      appBar: AppBar(
        title: Text("GIF车神"),
        actions: [
          _currentIndex == 1
              ? Row(
                  children: [
                    Text("浏览器中打开->"),
                    IconButton(
                        icon: Icon(Icons.language),
                        tooltip: 'print',
                        onPressed: () => launch(movieURL))
                  ],
                )
              : Text("")
        ],
      ),
      body: ValueListenableBuilder(
        builder: (BuildContext context, bool value, Widget child) {
          return IndexedStack(
            index: _currentIndex,
            children: <Widget>[
              value ? MainPage() : _getUpdateScreen(),
              value ? MoviePage(movieURL: movieURL) : _getUpdateScreen(),
              value ? GiftPage() : _getUpdateScreen(),
              value ? MyPage() : _getUpdateScreen(),
            ],
          );
        },
        valueListenable: versionRight,
        child: Text("text"),
      ),
      //底部导航栏
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        unselectedItemColor: Colors.black38,
        showUnselectedLabels: true,
        unselectedFontSize: 38.w,
        selectedFontSize: 50.w,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '首页',
              backgroundColor: Colors.indigoAccent),
          BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_fill),
              label: '影视',
              backgroundColor: Colors.indigoAccent),
          BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard),
              label: '福利',
              backgroundColor: Colors.indigoAccent),
          BottomNavigationBarItem(
              icon: Icon(Icons.face),
              label: '我的',
              backgroundColor: Colors.indigoAccent),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
