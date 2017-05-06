// ignore: invalid_constant
// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:posse_gallery/managers/category_manager.dart';
import 'package:posse_gallery/managers/route_manager.dart';
import 'package:posse_gallery/models/app_category.dart';
import 'package:posse_gallery/screens/category_screen.dart';
import 'package:posse_gallery/screens/search_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => new _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  static const int _kAnimationDuration = 250;

  List<Widget> _cells;

  Animation<double> _fadeInAnimation;
  AnimationController _animationController;

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.white,
      child: new Center(
        child: new FadeTransition(
          opacity: _fadeInAnimation,
          child: _contentWidget(),
        ),
      ),
    );
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _configureAnimation();
    _animationController.forward();
    setState(() {
      _cells = _loadCategories();
    });
  }

  Widget _buildAppBar() {
    Image searchIcon = new Image(
      image: new AssetImage("assets/icons/ic_search.png"),
      fit: BoxFit.cover,
    );
    return new Container(
      height: 76.0,
      child: new DecoratedBox(
        decoration: new BoxDecoration(),
        child: new Stack(
          children: [
            new Positioned(
              left: 12.0,
              top: 35.0,
              child: const FlutterLogo(),
            ),
            new Positioned(
              left: 52.0,
              top: 38.0,
              child: new Text(
                "Flutter Gallery",
                style: new TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20.0,
                  color: const Color(0xFF29B6F6),
                ),
              ),
            ),
            new Positioned(
              right: 8.0,
              top: 26.0,
              child: new Hero(
                tag: "main.search.hero",
                child: new Material(
                  color: const Color(0x00FFFFFF),
                  child: new IconButton(
                    padding: EdgeInsets.zero,
                    icon: searchIcon,
                    onPressed: () {
                      Navigator.push(
                        context,
                        new PageRouteBuilder<Null>(
                            settings: const RouteSettings(name: "/search"),
                            pageBuilder: (BuildContext context,
                                Animation<double> _, Animation<double> __) {
                              return new SearchScreen();
                            }),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return new Expanded(
      child: new Container(
        color: new Color(0x00FFFFFF),
        child: new Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: new ListView(
            children: _cells,
          ),
        ),
      ),
    );
  }

  Widget _categoryTextWidget({category: AppCategory, categoryIndex: int}) {
    String formattedIndex = categoryIndex.toString().padLeft(2, '0');
    return new Center(
      child: new Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          new Text(
            formattedIndex,
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 10.0,
              color: Colors.white,
            ),
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 7.0),
            child: new Text(
              category.title,
              textAlign: TextAlign.center,
              style: new TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: 1.6,
                height: 1.3,
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _configureAnimation() {
    _animationController = new AnimationController(
      duration: const Duration(milliseconds: _kAnimationDuration),
      vsync: this,
    );
    _fadeInAnimation = _initAnimation(
        from: 0.0,
        to: 1.0,
        curve: Curves.easeOut,
        controller: _animationController);
  }

  Widget _contentWidget() {
    return new Stack(
      children: [
        new Positioned(
          top: 0.0,
          right: 0.0,
          child: new Image(
            image: new AssetImage("assets/images/bg_main_screen.png"),
          ),
        ),
        new Positioned(
          child: new Column(
            children: [
              _buildAppBar(),
              _buildListView(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _createCell(
      {@required AppCategory category,
      @required int categoryIndex,
      @required String routeName}) {
    return new Hero(
      tag: category.title,
      child: new Container(
        padding:
            const EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
        height: 156.0,
        child: new Card(
          child: new Stack(
            children: [
              new Positioned.fill(
                child: new Container(color: category.centerShapeColor),
              ),
              new Positioned(
                right: 0.0,
                top: -45.0,
                child: new Image(
                  height: 200.0,
                  width: 300.0,
                  color: category.rightShapeColor,
                  image: new AssetImage(
                      "assets/images/category_cell_right_shape.png"),
                  fit: BoxFit.cover,
                ),
              ),
              new Positioned(
                left: 0.0,
                top: -40.0,
                child: new Image(
                  height: 250.0,
                  width: 210.0,
                  color: category.leftShapeColor,
                  image: new AssetImage(
                      "assets/images/category_cell_left_shape.png"),
                  fit: BoxFit.cover,
                ),
              ),
              _categoryTextWidget(
                  category: category, categoryIndex: categoryIndex),
              new Material(
                color: const Color(0x00FFFFFF),
                child: new InkWell(
                  highlightColor: Colors.white.withAlpha(30),
                  splashColor: Colors.white.withAlpha(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute<Null>(
                        fullscreenDialog: true,
                        settings:
                            new RouteSettings(name: "/category/$routeName"),
                        builder: (BuildContext context) {
                          return new CategoryScreen(
                            category: RouteManager.retrieveCategory(routeName),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Animation<double> _initAnimation(
      {@required double from,
      @required double to,
      @required Curve curve,
      @required AnimationController controller}) {
    final CurvedAnimation animation = new CurvedAnimation(
      parent: controller,
      curve: curve,
    );
    return new Tween<double>(begin: from, end: to).animate(animation);
  }

  Animation<FractionalOffset> _initSlideAnimation(
      {@required FractionalOffset from,
      @required FractionalOffset to,
      @required Curve curve,
      @required AnimationController controller}) {
    final CurvedAnimation animation = new CurvedAnimation(
      parent: controller,
      curve: curve,
    );
    return new Tween<FractionalOffset>(begin: from, end: to).animate(animation);
  }

  List<Widget> _loadCategories() {
    List<Widget> categoryCells = [];
    int categoryIndex = 1;
    List<AppCategory> categories = new CategoryManager().categories();
    for (AppCategory category in categories) {
      String routeName = category.routeName;
      AnimationController animationController = new AnimationController(
        duration:
            new Duration(milliseconds: _kAnimationDuration * categoryIndex),
        vsync: this,
      );
      Animation<FractionalOffset> animation = _initSlideAnimation(
        from: new FractionalOffset(1.5, 0.0),
        to: const FractionalOffset(0.0, 0.0),
        curve: Curves.easeOut,
        controller: animationController,
      );
      final categoryContainer = new SlideTransition(
        position: animation,
        child: _createCell(
            category: category,
            categoryIndex: categoryIndex,
            routeName: routeName),
      );
      animationController.forward();
      categoryCells.add(categoryContainer);
      categoryIndex += 1;
    }
    return categoryCells;
  }
}