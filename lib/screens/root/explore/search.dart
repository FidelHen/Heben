import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/search_lists/challenges_tab.dart';
import 'package:heben/components/search_lists/people_tab.dart';
import 'package:heben/components/search_lists/streams_tab.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/device_size.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool tabOneActive = true;
  bool tabTwoActive = false;
  bool tabThreeActive = false;
  bool isSearching;

  TextEditingController searchController;

  @override
  void initState() {
    isSearching = false;
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: GFAppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: DeviceSize().getWidth(context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  autofocus: true,
                  controller: searchController,
                  keyboardAppearance: Brightness.light,
                  onSubmitted: (text) {
                    setState(() {
                      isSearching = true;
                    });
                  },
                  style: GoogleFonts.lato(
                      fontSize: 16, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: GoogleFonts.lato(
                        fontSize: 16, fontWeight: FontWeight.w600),
                    icon: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                      child: Icon(
                        EvaIcons.search,
                        color: hebenActive,
                        size: 20,
                      ),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
        leading: IconButton(
            icon: Icon(
              EvaIcons.chevronLeft,
              size: 40,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: isSearching
          ? DefaultTabController(
              length: 3,
              child: Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      color: Colors.grey[200],
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        child: Container(
                          color: Colors.white,
                          child: TabBar(
                            unselectedLabelColor: Colors.grey[400],
                            labelColor: Colors.black,
                            indicatorColor: Colors.transparent,
                            labelStyle: GoogleFonts.lato(
                                fontSize: 14, fontWeight: FontWeight.w600),
                            isScrollable: false,
                            indicator: UnderlineTabIndicator(
                                borderSide:
                                    BorderSide(width: 2, color: hebenRed)),
                            tabs: [
                              Tab(
                                text: 'People',
                              ),
                              Tab(
                                text: 'Challenges',
                              ),
                              Tab(
                                text: 'Streams',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          PeopleTab(
                            query: searchController.text.trim(),
                          ),
                          ChallengesTab(
                            query: searchController.text.trim(),
                          ),
                          StreamsTab(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          : Container(
              width: DeviceSize().getWidth(context),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Search for users, challenges, and streams',
                        style:
                            GoogleFonts.openSans(fontWeight: FontWeight.w600),
                      ),
                    ]),
              ),
            ),
    );
  }

  setTab(int index) {
    tabOneActive = false;
    tabTwoActive = false;
    tabThreeActive = false;

    setState(() {
      if (index == 0) {
        tabOneActive = true;
      } else if (index == 1) {
        tabTwoActive = true;
      } else if (index == 2) {
        tabThreeActive = true;
      }
    });
  }
}
