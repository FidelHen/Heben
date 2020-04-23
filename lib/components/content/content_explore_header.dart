import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/screens/root/friend.dart';
import 'package:heben/screens/root/view_stream.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/navigation.dart';

class ContentExploreHeader extends StatefulWidget {
  @override
  _ContentExploreHeaderState createState() => _ContentExploreHeaderState();
}

class _ContentExploreHeaderState extends State<ContentExploreHeader> {
  final List<String> imageList = [
    "https://cdn.pixabay.com/photo/2017/12/03/18/04/christmas-balls-2995437_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/12/13/00/23/christmas-3015776_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/19/10/55/christmas-market-4705877_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/20/00/03/road-4707345_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/22/04/18/x-mas-4711785__340.jpg",
    "https://cdn.pixabay.com/photo/2016/11/22/07/09/spruce-1848543__340.jpg",
    "https://cdn.pixabay.com/photo/2017/12/03/18/04/christmas-balls-2995437_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/12/13/00/23/christmas-3015776_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/19/10/55/christmas-market-4705877_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/20/00/03/road-4707345_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/22/04/18/x-mas-4711785__340.jpg",
    "https://cdn.pixabay.com/photo/2016/11/22/07/09/spruce-1848543__340.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          topLeft: Radius.circular(40),
        ),
      ),
      height: 150,
      constraints: const BoxConstraints(minHeight: 50),
      padding: EdgeInsets.fromLTRB(5, 25, 5, 0),
      margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: imageList.length,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigation().segue(
                    page: ViewStream(), context: context, fullScreen: true);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Container(
                    height: 150,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://source.unsplash.com/1600x900/?workout'),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 4.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigation().segue(
                                          page: Friend(
                                            uid: null,
                                            username: null,
                                          ),
                                          context: context,
                                          fullScreen: false);
                                    },
                                    child: GFAvatar(
                                      size: 20,
                                      backgroundColor: Colors.grey,
                                      backgroundImage: NetworkImage(
                                          'https://source.unsplash.com/1600x900/?portrait'),
                                    ),
                                  ),
                                ),
                                Text(
                                  Faker().internet.userName(),
                                  style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 2.0),
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                                    decoration: BoxDecoration(
                                      color: hebenActive,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                    ),
                                    child: Text(Faker().lorem.word(),
                                        style: GoogleFonts.openSans(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: Colors.white)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 2.0),
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                                    decoration: BoxDecoration(
                                      color: hebenActive,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                    ),
                                    child: Text(Faker().lorem.word(),
                                        style: GoogleFonts.openSans(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: Colors.white)),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                                  decoration: BoxDecoration(
                                    color: hebenActive,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                  ),
                                  child: Text(Faker().lorem.word(),
                                      style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Row(children: [
                              Icon(
                                EvaIcons.eyeOutline,
                                color: Colors.grey[400],
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 3.0),
                                child: Text(
                                    '${Faker().randomGenerator.integer(10000)}',
                                    style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: Colors.black)),
                              ),
                            ]),
                          ),
                        ]),
                  )
                ]),
              ),
            );
          }),
    );
  }
}
