import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:goedale_management/scoped_model/global_model.dart';

void main() => runApp(MyApp(GlobalModel()));

class MyApp extends StatelessWidget {
final GlobalModel globalModel;
const MyApp(this.globalModel);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<GlobalModel>(
      model: globalModel,
      child: MaterialApp(
        title: 'Goedale management',
        theme: ThemeData.dark(),
        home: MyHomePage(title: 'Goedale management~'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

PageController pageController;

class _MyHomePageState extends State<MyHomePage> {
  var appBarTitleText = "Goedale management";
  int _page =0;

  @override
  void initState() {
    super.initState();
    pageController = new PageController();
    //globalsload?
    //setappbartitle?
  }
  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<GlobalModel>(
      builder: (context, child, globalModel){
        return Scaffold(
          appBar: AppBar(
            title: Text(appBarTitleText),
          ),
          body: PageView(
            children: <Widget>[
              Container(
                child: ,
              ),
              Container(
                child: ,
              ),
              Container(
                child: ,
              ),
            ],
            controller: pageController,
            onPageChanged: onPageChanged,
          ),
          bottomNavigationBar: SizedBox(
            height: 70,
            child: CupertinoTabBar(items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.list, color: (_page == 0) ? Colors.white : Colors.grey)
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.assignment, color: (_page == 1) ? Colors.white : Colors.grey)
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings, color: (_page == 2) ? Colors.white : Colors.grey)
              ),
          ],
            onTap: navigationTapped,
            currentIndex: _page,),
          ),

        );
      },

    );
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
