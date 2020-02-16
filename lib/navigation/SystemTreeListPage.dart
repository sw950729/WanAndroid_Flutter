import 'package:flutter/material.dart';
import 'package:silence_wan_android/entity/SystemTreeEntity.dart';
import 'package:silence_wan_android/navigation/ArticleListPage.dart';

/// @date:2020-02-16
/// @author:Silence
/// @describe: 体系下的文章列表
class SystemTreeListPage extends StatefulWidget {
  final String title;
  final List<Children> children;

  SystemTreeListPage({@required this.title, @required this.children});

  @override
  _SystemTreeListPageState createState() => _SystemTreeListPageState();
}

class _SystemTreeListPageState extends State<SystemTreeListPage>
    with SingleTickerProviderStateMixin {
  var index = 1;
  TabController _tabController;
  PageController _pageController = PageController(initialPage: 0);
  var isPageCanChanged = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.children.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        index = _tabController.index;
      });
      if (_tabController.indexIsChanging) {
        onPageChange(_tabController.index, p: _pageController);
      }
    });
  }

  onPageChange(int index, {PageController p, TabController t}) async {
    if (p != null) {
      isPageCanChanged = false;
      await _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
      isPageCanChanged = true;
    } else {
      _tabController.animateTo(index);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.white,
          labelColor: Colors.white,
          isScrollable: true,
          tabs: widget.children.map((title) {
            return Tab(text: title.name);
          }).toList(),
        ),
      ),
      body: PageView.builder(
        itemCount: widget.children.length,
        itemBuilder: (BuildContext context, int index) {
          return ArticleListPage(
            id: widget.children[index].id,
          );
        },
        onPageChanged: (index) {
          if (isPageCanChanged) {
            onPageChange(index);
          }
        },
        controller: _pageController,
      ),
    );
  }
}
