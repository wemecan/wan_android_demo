import 'package:flutter/material.dart';
import 'package:wan_android_demo/api/HttpService.dart';
import 'package:wan_android_demo/model/porjectClassification/ProjectClassificationItemModel.dart';
import 'package:wan_android_demo/ui/page/article_list/ArticleListWidget.dart';
import 'package:wan_android_demo/ui/widget/CAppBar.dart';
import 'package:wan_android_demo/ui/widget/NetworkWrapWidget.dart';
import 'package:wan_android_demo/utils/Log.dart';

class WeCahtPage extends StatefulWidget {
  String title;

  WeCahtPage({this.title});

  @override
  State<StatefulWidget> createState() => _WeCahtState();
}

class _WeCahtState extends State<WeCahtPage> with TickerProviderStateMixin {
  TabController controller;
  List<ProjectClassificationItemModel> _list = List();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CAppBar(
          title: widget.title,
          bottom: _list.length > 0
              ? TabBar(
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorPadding: EdgeInsets.only(bottom: 2),
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  indicatorWeight: 1.0,
                  controller: controller,
                  tabs: _list.map((ProjectClassificationItemModel _bean) {
                    return Tab(text: _bean?.name);
                  }).toList())
              : null,
        ),
        body: NetworkWrapWidget(
          widget: TabBarView(
              controller: controller,
              children: _list.map((ProjectClassificationItemModel _bean) {
                return ArticleListWidget(
                    TAG: "${widget.title}${_bean.name}",
                    headerCount: 0,
                    request: (page) {
                      return HttpService().getWxArticleListById(_bean.id, page);
                    });
              }).toList()),
          call: getData,
        ));
  }

  Future getData() async {
    var bean = await HttpService().getWxArticleChapters();
    List<ProjectClassificationItemModel> data = bean.data;
    Log.logT("_WeCahtState", " 公众号数据${bean.data.length}");
    if (data?.length > 0) {
      _list = data;
      controller = TabController(length: _list.length, vsync: this);
      setState(() {});
    }
    return Future.value(true);
  }
}
