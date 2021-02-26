import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

// void main() => runApp(MyApp());

void main() {
  CategoryState categoryState = CategoryState();
  return runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => categoryState)],
      child: MyApp(categoryState),
    ),
  );
}

class MyApp extends StatelessWidget {
  CategoryState categoryState;
  MyApp(CategoryState categoryState) {
    this.categoryState = categoryState;
  }

  @override
  Widget build(BuildContext context) {
    gethttp() async {
      try {
        Response response = await Dio().get(
            'http://api.map.baidu.com/telematics/v3/weather',
            queryParameters: {
              'location': '广州',
              'output': 'json',
              'ak': '5slgyqGDENN7Sy7pw29IUvrZ'
            });
        return response.data;
      } catch (error) {
        print(error);
      }
    }

    Future<dynamic> res = gethttp();
    var then = res.then((data) {
      print('sada' + data.toString());
    });

    getStore(SettingModel model) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.getBool(model.id);
    }

    for (List list in categoryState.dataSource) {
      for (var model in list) {
        if (model is SettingModel) {
          Future<bool> store = getStore(model);
          store.then((bool isOn) {
            bool on = isOn != null ? isOn : false;
            print('oooooo' + on.toString());
            Provider.of<CategoryState>(context, listen: false)
                .changeIsOn(model, on);
          });
        }
      }
    }

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SettingList(),
        ),
      ),
    );
  }
}

class CategoryState extends ChangeNotifier {
  List<List> _dataSource = [
    [
      HeaderModel(),
      SectionModel(),
      SettingModel('icon_setting_date.png', '照片日期', null, 'kDate'),
      SettingModel('icon_setting_save.png', '默认保存到本地', null, 'kSave'),
      SettingModel('icon_setting_quick.png', '快速换卷', '开启后可直接切换胶卷', 'kQuick'),
    ],
    [
      SectionModel(),
      SettingModel('icon_setting_about.png', '关于', null, 'kAbout'),
      SettingModel('icon_setting_feedback.png', '意见反馈', null, 'kFeedbook'),
      SectionModel(),
      FootModel(),
    ],
  ];

  get dataSource => _dataSource;

  void changeIsOn(SettingModel model, bool isOn) {
    model.isOn = isOn;
    notifyListeners();
  }
}

class SettingModel {
  String icon = '';
  String title;
  String detail;
  bool isOn;
  String id;
  SettingModel(String icon, String title, String detail, String id) {
    this.icon = 'assets/' + icon;
    this.title = title;
    this.detail = detail == null ? "" : detail;
    this.id = id;
    this.isOn = false;
  }
}

class HeaderModel {
  HeaderModel() {}
}

class SectionModel {
  SectionModel() {}
}

class FootModel {
  SectionModel() {}
}

class SettingList extends StatefulWidget {
  @override
  _ListState createState() {
    // List<List> _dataSource = [
    //   [
    //     HeaderModel(),
    //     SectionModel(),
    //     SettingModel('icon_setting_date.png', '照片日期', null, 'kDate'),
    //     SettingModel('icon_setting_save.png', '默认保存到本地', null, 'kSave'),
    //     SettingModel('icon_setting_quick.png', '快速换卷', '开启后可直接切换胶卷', 'kQuick'),
    //   ],
    //   [
    //     SectionModel(),
    //     SettingModel('icon_setting_about.png', '关于', null, 'kAbout'),
    //     SettingModel('icon_setting_feedback.png', '意见反馈', null, 'kFeedbook'),
    //     SectionModel(),
    //     FootModel(),
    //   ],
    // ];

    // return _ListState(_dataSource);

    return _ListState();
  }
}

class _ListState extends State {
  // List<List> dataSource;

  // _ListState(List<List> dataSource) {
  //   this.dataSource = dataSource;
  // }

  @override
  Widget build(BuildContext context) {
    var stack = new Stack(
      children: [
        // new Image.asset('assets/img_setting_bg.jpg', width: 100, height: 300,),
        new Container(
          width: MediaQuery.of(context).size.width,
          height: 185,
          decoration: new BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/img_setting_bg.jpg',
                ),
                fit: BoxFit.fill),
          ),
        ),
        _buildList(),

        // Consumer<CategoryState>(
        //   builder: (context, categoryState, child) {
        //     return ListView.builder(
        //       scrollDirection: Axis.vertical,
        //       itemCount: categoryState.dataSource.length,
        //       itemBuilder: (context, section) {
        //         return ListView.builder(
        //           shrinkWrap: true, // 解决无线高度
        //           physics: new NeverScrollableScrollPhysics(), // 禁用滑动事件
        //           padding: EdgeInsets.all(0),
        //           itemCount: categoryState.dataSource[section].length,
        //           itemBuilder: (context, index) {
        //             var model = categoryState.dataSource[section][index];
        //             if (model is HeaderModel) {
        //               return _buildHeader();
        //             } else if (model is SectionModel) {
        //               return _buildSection();
        //             } else if (model is FootModel) {
        //               return _buildFoot();
        //             } else {
        //               return _buildRow(model, section, index);
        //             }
        //           },
        //         );
        //       },
        //     );
        //   },
        // )
      ],
    );

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(11, 11, 11, 1),
        child: stack,
      ),
    );
  }

  Widget _buildList() {
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   for (List list in CategoryState().dataSource) {
    //     for (var model in list) {
    //       if (model is SettingModel) {
    //         Future<bool> store = getStore(model);
    //         store.then((bool isOn) {
    //           // setState(() {
    //           //   model.isOn = isOn != null ? isOn : false;
    //           // });

    //           bool on = isOn != null ? isOn : false;
    //           print('oooooo' + on.toString());
    //           Provider.of<CategoryState>(context, listen: false)
    //               .changeIsOn(model, on);
    //         });
    //       }
    //     }
    //   }

    // setState(() {
    //   // Here you can write your code for open new view
    // });
    // });

    // getStore(SettingModel model) async {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   return await prefs.getBool(model.id);
    // }

    // for (List list in categoryState.dataSource) {
    //   for (var model in list) {
    //     if (model is SettingModel) {
    //       Future<bool> store = getStore(model);
    //       store.then((bool isOn) {
    //         setState(() {
    //           model.isOn = isOn != null ? isOn : false;
    //           print('oooooo' + model.isOn.toString());
    //         });

    //         // bool on = isOn != null ? isOn : false;
    //         // print('oooooo' + on.toString());
    //         // Provider.of<CategoryState>(context, listen: false)
    //         //     .changeIsOn(model, on);
    //       });
    //     }
    //   }
    // }

    // Future<bool> store = getStore(model);
    // store.then((bool isOn) {
    //   setState(() {
    //     model.isOn = isOn != null ? isOn : false;
    //   });

    //   bool on = isOn != null ? isOn : false;
    //   print('oooooo' + on.toString());
    //   // Provider.of<CategoryState>(context, listen: false)
    //   //     .changeIsOn(model, on);
    // });

    return Consumer<CategoryState>(builder: (context, categoryState, child) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: categoryState.dataSource.length,
        itemBuilder: (context, section) {
          return ListView.builder(
            shrinkWrap: true, // 解决无线高度
            physics: new NeverScrollableScrollPhysics(), // 禁用滑动事件
            padding: EdgeInsets.all(0),
            itemCount: categoryState.dataSource[section].length,
            itemBuilder: (context, index) {
              var model = categoryState.dataSource[section][index];
              if (model is HeaderModel) {
                return _buildHeader();
              } else if (model is SectionModel) {
                return _buildSection();
              } else if (model is FootModel) {
                return _buildFoot();
              } else {
                return _buildRow(model, section, index);
              }
            },
          );
        },
      );
    });
    // return ListView.builder(
    //   scrollDirection: Axis.vertical,
    //   itemCount: dataSource.length,
    //   itemBuilder: (context, section) {
    //     return ListView.builder(
    //       shrinkWrap: true, // 解决无线高度
    //       physics: new NeverScrollableScrollPhysics(), // 禁用滑动事件
    //       padding: EdgeInsets.all(0),
    //       itemCount: dataSource[section].length,
    //       itemBuilder: (context, index) {
    //         var model = dataSource[section][index];
    //         if (model is HeaderModel) {
    //           return _buildHeader();
    //         } else if (model is SectionModel) {
    //           return _buildSection();
    //         } else if (model is FootModel) {
    //           return _buildFoot();
    //         } else {
    //           return _buildRow(model, section, index);
    //         }
    //       },
    //     );
    //   },
    // );
  }

  Widget _buildHeader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 145,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 5, top: 6),
            width: 60,
            height: 60,
            child: IconButton(
              icon: Image.asset('assets/icon_general_back.png'),
              onPressed: () {
                print('123123123');
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 25.5, top: 20),
            child: Text(
              '设置',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      padding: const EdgeInsets.only(left: 25),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 12,
          height: 3,
          decoration: new BoxDecoration(
            color: Color.fromRGBO(171, 142, 78, 1),
          ),
        ),
      ),
    );
  }

  Widget _buildFoot() {
    var itemWidth = (MediaQuery.of(context).size.width - 27.5 * 3.0) / 2.0;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: itemWidth,
            height: 40,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/btn_setting_weibo.png'),
              fit: BoxFit.fill,
            )),
            child: FlatButton(
              onPressed: () {},
              child: Text(''),
            ),
          ),
          Container(
            width: itemWidth,
            height: 40,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/btn_setting_instagram.png'),
              fit: BoxFit.fill,
            )),
            alignment: Alignment.center,
            child: FlatButton(
              onPressed: () {
                print('123123');
              },
              child: Text(''),
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildRow(SettingModel model, int section, int row) {
    saveStore(SettingModel model) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(model.id, model.isOn);
    }

    return Container(
      height: 60,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 23, right: 20),
            child: Image.asset(model.icon, width: 36, height: 36),
          ),
          if (model.detail.length > 0)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      model.title,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      model.detail,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: Container(
                child: Text(
                  model.title,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          if (section == 0)
            Container(
              padding: const EdgeInsets.only(right: 0),
              width: 54,
              height: 60,
              child: FlatButton(
                  onPressed: () {
                    Provider.of<CategoryState>(context, listen: false)
                        .changeIsOn(model, true);
                    saveStore(model);

                    // setState(() {
                    //   model.isOn = true;
                    //   saveStore(model);
                    // });
                  },
                  child: Text("开",
                      style: model.isOn
                          ? TextStyle(color: Color.fromRGBO(171, 142, 78, 1))
                          : TextStyle(color: Colors.grey))),
            ),
          if (section == 0)
            Container(
              padding: const EdgeInsets.only(right: 10),
              width: 54,
              height: 60,
              child: FlatButton(
                  onPressed: () {
                    Provider.of<CategoryState>(context, listen: false)
                        .changeIsOn(model, false);
                    saveStore(model);

                    // setState(() {
                    //   model.isOn = false;
                    //   saveStore(model);
                    // });
                  },
                  child: Text("关",
                      style: model.isOn
                          ? TextStyle(color: Colors.grey)
                          : TextStyle(color: Color.fromRGBO(171, 142, 78, 1)))),
            ),
          if (section == 1)
            Container(
              padding: const EdgeInsets.only(right: 17),
              child: Image.asset('assets/icon_setting_more.png',
                  width: 12, height: 18),
            ),
        ],
      ),
    );
  }
}
