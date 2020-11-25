import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../articalPage/ArticalPage.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ScrollController _scrollController = new ScrollController();
  int _pageNum = 0;
  int _pageSize = 20;
  List _articalList = [];
  bool flag = true;
  bool scrollstaynerd = false;

  void initState() {
    super.initState();
    //初始化数据
    _getDatas();
    //上拉刷新监听器
    _scrollController.addListener(() {
      if (!scrollstaynerd) {
        if (_scrollController.position.pixels >
            _scrollController.position.maxScrollExtent - 20) {
          setState(() {
            _pageNum = _pageNum + 20;
            _pageSize = _pageSize + 20;
          });
          _getDatas();
          scrollstaynerd = true;
        }
      }
    });
  }

  void _getDatas() async {
    if (flag) {
      String url =
          "http://193.149.161.65:3000/sql/get_some_articals?from=$_pageNum&to=$_pageSize";
      Response response = await Dio().get(url);
      List<dynamic> list = response.data;
      setState(() {
        _articalList.addAll(list);
      });
      if (list.length < 20) {
        setState(() {
          flag = false;
        });
      }
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          scrollstaynerd = false;
        });
      });
    }
  }

//下拉刷新->转一秒的圈 回调刷新的方法
  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _pageNum = 0;
        _pageSize = 20;
        _articalList = [];
        flag = true;
      });
      _getDatas();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(1284, 2778), allowFontScaling: true);
    return _articalList.length > 0
        ? RefreshIndicator(
            child: ListView.builder(
              itemCount: _articalList.length,
              itemBuilder: (context, index) {
                if (index == _articalList.length - 1) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          _articalList[index]['title'] +
                              _articalList[index]['id'].toString(),
                          maxLines: 1,
                        ),
                        leading: Image.network(
                          _articalList[index]['preview'],
                          fit: BoxFit.cover,
                          width: 300.w,
                          height: 200.w,
                        ),
                        subtitle: Text(
                            _articalList[index]['created_time'].toString()),
                        trailing:
                            Text("阅读:${_articalList[index]['readcount']}  "),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ArticalPage(
                                      articalId: _articalList[index]['id'])));
                        },
                      ),
                      Divider(),
                      _getMoreWidget()
                    ],
                  );
                } else {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          _articalList[index]['title'] +
                              _articalList[index]['id'].toString(),
                          maxLines: 1,
                        ),
                        leading: Image.network(
                          _articalList[index]['preview'],
                          fit: BoxFit.cover,
                          width: 300.w,
                          height: 200.w,
                        ),
                        subtitle: Text(
                            _articalList[index]['created_time'].toString()),
                        trailing:
                            Text("阅读:${_articalList[index]['readcount']}  "),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ArticalPage(
                                      articalId: _articalList[index]['id'])));
                        },
                      ),
                      Divider(),
                    ],
                  );
                }
              },
              controller: _scrollController,
            ),
            onRefresh: _onRefresh,
          )
        : _getMoreWidget();
  }

//返回一个圈
  Widget _getMoreWidget() {
    if (flag) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '加载中...',
                style: TextStyle(fontSize: 16.0),
              ),
              CircularProgressIndicator(
                strokeWidth: 1.0,
              )
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: Text("---已经到底啦---"),
      );
    }
  }
}
