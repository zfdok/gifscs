import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'components/articalhead.dart';
import 'components/img_swipe.dart';

class ArticalPage extends StatefulWidget {
  final int articalId;
  ArticalPage({Key key, @required this.articalId}) : super(key: key);
  @override
  _ArticalPageState createState() => _ArticalPageState();
}

class _ArticalPageState extends State<ArticalPage> {
  List<dynamic> datas = [];
  String imgDesc = "";
  String imgSecretCode = "";
  String articalTitle = "";
  String articalDate = "";
  String articalRead = "";
  String articalShare = "";

  _getData() async {
    try {
      Response response = await Dio().get(
          "http://gifcheshen.com:3000/sql/get_an_artical?id=${widget.articalId}");
      setState(() {
        datas = response.data['content']['data'];
        articalTitle = response.data['title'];
        articalDate = response.data['created_time'];
        articalRead = response.data['readcount'].toString();
      });
    } catch (e) {
      print(e);
    }
  }

  _getArticalShare() async {
    try {
      Response response = await Dio().get("http://gifcheshen.com:3000/share");
      setState(() {
        articalShare = response.data;
        print(articalShare);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _getData();
    _getArticalShare();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GIF车神"),
      ),
      body: Container(
        child: Column(
          children: [
            ArticalHead(
                articalTitle: articalTitle,
                articalDate: articalDate,
                articalRead: articalRead),
            ImgSwiper(datas: datas, articalShare: articalShare)
          ],
        ),
      ),
    );
  }
}
