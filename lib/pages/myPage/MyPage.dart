import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //自适应
    ScreenUtil.init(context,
        designSize: Size(1284, 2778), allowFontScaling: true);
    return Container(
      child: Stack(
        children: [
          ClipPath(
            clipper: MyBottomCliper(),
            child: Container(
              color: Colors.amber,
              height: 800.w,
            ),
          ),
          Container(
            child: Column(
              children: [
                SizedBox(
                  width: 1284.w,
                  height: 900.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(100.w, 220.w, 0, 0),
                        child: SizedBox(
                          height: 284.w,
                          width: 284.w,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://www.picnew.org/images/2020/11/28/16670204-d237cafe27351ca7.jpg"),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(100.w, 250.w, 0, 0),
                        width: 800.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "某霸气网友",
                              style: TextStyle(fontSize: 80.w),
                            ),
                            Text(
                              "很多人听过他唱告白气球,\r\n却没有人真的见过他!",
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 45.w, color: Colors.black45),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(30.w, 20.w, 30.w, 0),
                      child: Card(
                        elevation: 10.w,
                        child: ListTile(
                          leading: Icon(Icons.smart_button),
                          title: Text("请牢记:网址就是“gif车神”😂😂😂"),
                          onTap: () {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30.w, 20.w, 30.w, 0),
                      child: Card(
                        elevation: 10.w,
                        child: ListTile(
                          leading: Icon(Icons.ac_unit_sharp),
                          title: Text("获取最新版本(备用github地址)"),
                          onTap: () => launch(
                              "https://github.com/oliverquinn2021/gifsc_back"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30.w, 20.w, 30.w, 0),
                      child: Card(
                        elevation: 10.w,
                        child: ListTile(
                          leading: Icon(Icons.help),
                          title: Text("获取帮助"),
                          onTap: () => Scaffold.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text("如果软件无法使用,请联系作者邮箱,该邮箱自动回复给您最新的网址"))),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30.w, 20.w, 30.w, 0),
                      child: Card(
                        elevation: 10.w,
                        child: ListTile(
                          leading: Icon(Icons.deck_rounded),
                          title: Text("关于本app"),
                          onTap: () => myAboutDialog(context),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30.w, 20.w, 30.w, 0),
                      child: Card(
                        elevation: 10.w,
                        child: ListTile(
                          leading: Icon(Icons.mail),
                          title: Text("联系作者"),
                          onTap: () {
                            showDialog(
                                context: context,
                                child: AlertDialog(
                                  title: Text("请联系:"),
                                  content: Text("oliverquinn2021@gmail.com"),
                                  actions: [
                                    FlatButton(
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(
                                            text: "oliverquinn2021@gmail.com"));
                                        Clipboard.getData(Clipboard.kTextPlain)
                                            .then((value) {
                                          Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "已复制联系方式:${value.text} 到剪贴板")));
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: Text("复制"),
                                    )
                                  ],
                                ));
                          },
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MyBottomCliper extends CustomClipper<Path> {
  //MyBottomCliper是对CustomClipper的继承,
  @override
  Path getClip(Size size) {
    //必须重写方法getClip, 返回一个path类型的路径
    var path = Path();
    path.lineTo(0, 0); //就像画图一样,从第一个点开始绘制并填充
    path.lineTo(0, size.height - 100.w); // 第二个点

    var firstControlPoint =
        Offset(size.width / 4, size.height); //为了绘制贝塞尔曲线,先声明第一组两个关键点
    var firstEndPoint = Offset(size.width / 2, size.height - 100.w);

    path.quadraticBezierTo(
        firstControlPoint.dx,
        firstControlPoint.dy, //绘制第一组贝塞尔曲线
        firstEndPoint.dx,
        firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width / 4 * 3, size.height - 200.w); //为了绘制贝塞尔曲线,再声明第二组两个关键点
    var secondEndPoint = Offset(size.width, size.height - 100.w);

    path.quadraticBezierTo(
        secondControlPoint.dx,
        secondControlPoint.dy, //绘制第二组贝塞尔曲线
        secondEndPoint.dx,
        secondEndPoint.dy);
    path.lineTo(size.width, 0); //回至顶部
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    //必须重写shouldReclip, 返回false,一般不改动
    return false;
  }
}

void myAboutDialog(context) {
  showDialog(
      context: context,
      builder: (_) => AboutDialog(
            applicationIcon: Icon(Icons.ac_unit),
            applicationName: "GIF车神",
            applicationVersion: "v0.0.1",
            applicationLegalese: "@oliver,@google\r\noliverquinn2021@gmail.com",
          ));
}
