import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:heben/screens/root/view_stream.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/navigation.dart';

class ContentHomeHeader extends StatefulWidget {
  @override
  _ContentHomeHeaderState createState() => _ContentHomeHeaderState();
}

class _ContentHomeHeaderState extends State<ContentHomeHeader> {
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
                child: Container(
                  height: 150,
                  width: 80,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(
                              image: NetworkImage(imageList[index]),
                              fit: BoxFit.cover),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: hebenContentOverlay,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: GFAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                              'https://source.unsplash.com/1600x900/?portrait'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
