import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowMenu extends StatefulWidget {
  

  @override
  _ShowMenuState createState() => _ShowMenuState();
}

class _ShowMenuState extends State<ShowMenu> {
  PageController? pageViewController;


  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF3972EF),
        automaticallyImplyLeading: true,
        title: Text(
          'Menu',
          style: GoogleFonts.kanit(
            color: Colors.black,
            fontSize: 22,
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 1,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 200, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: Text(
                      'อาหารหมายเลข 1',
                      style: GoogleFonts.kanit(
                        color: Colors.black,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 50, 10, 0),
                child: Container(
                  height: 200,
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                        child: PageView(
                          controller: pageViewController ??=
                              PageController(initialPage: 0),
                          scrollDirection: Axis.horizontal,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 40),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  'https://www.suaheew.com/wp-content/uploads/2019/10/%E0%B8%AB%E0%B8%A1%E0%B8%B9%E0%B8%97%E0%B8%AD%E0%B8%94%E0%B8%99%E0%B9%89%E0%B8%B3%E0%B8%9B%E0%B8%A5%E0%B8%B2-%E0%B8%9B%E0%B8%81-youtube-%E0%B8%A2%E0%B9%88%E0%B8%AD.jpg',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 40),
                              child: Image.network(
                                'https://www.suaheew.com/wp-content/uploads/2019/10/%E0%B8%AB%E0%B8%A1%E0%B8%B9%E0%B8%97%E0%B8%AD%E0%B8%94%E0%B8%99%E0%B9%89%E0%B8%B3%E0%B8%9B%E0%B8%A5%E0%B8%B2-%E0%B8%9B%E0%B8%81-youtube-%E0%B8%A2%E0%B9%88%E0%B8%AD.jpg',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 40),
                              child: Image.network(
                                'https://www.suaheew.com/wp-content/uploads/2019/10/%E0%B8%AB%E0%B8%A1%E0%B8%B9%E0%B8%97%E0%B8%AD%E0%B8%94%E0%B8%99%E0%B9%89%E0%B8%B3%E0%B8%9B%E0%B8%A5%E0%B8%B2-%E0%B8%9B%E0%B8%81-youtube-%E0%B8%A2%E0%B9%88%E0%B8%AD.jpg',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0, 1),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                          child: smooth_page_indicator.SmoothPageIndicator(
                            controller: pageViewController ??=
                                PageController(initialPage: 0),
                            count: 3,
                            axisDirection: Axis.horizontal,
                            onDotClicked: (i) {
                              pageViewController!.animateToPage(
                                i,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            effect: const smooth_page_indicator.ExpandingDotsEffect(
                              expansionFactor: 2,
                              spacing: 8,
                              radius: 16,
                              dotWidth: 16,
                              dotHeight: 16,
                              dotColor: Color(0xFF9E9E9E),
                              activeDotColor: Color(0xFF3F51B5),
                              paintStyle: PaintingStyle.fill,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 350,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Text(
                    'Hello world',
                    style: GoogleFonts.kanit(
                      color: Colors.black,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
