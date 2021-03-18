import 'package:canteen_app/Helpers/widgets.dart';
import 'package:canteen_app/Services/dbdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdminDrawer extends StatefulWidget {
  @override
  _AdminDrawerState createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {

  var selectedItem = -1;

  Widget getDrawerItem(IconData icon, String name, int pos,{var tags}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedItem = pos;
          if(tags!=null){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => tags));
          }
        });
      },
      child: Container(
        color: selectedItem == pos ? Color(0XFFF2ECFD) : Colors.white,
        padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Row(
          children: <Widget>[
            Icon(icon,size: 20,),
            //SvgPicture.asset(icon, width: 20, height: 20),
            SizedBox(width: 20),
            text2(name,
                textColor:
                selectedItem == pos ? Color(0XFF5959fc) : Color(0XFF212121),
                fontSize: 18.0,
                fontFamily: 'Medium')
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height,
      child: Drawer(
        elevation: 8,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 70, right: 20),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
                      decoration: new BoxDecoration(
                          color: Color(0XFF5959fc),
                          borderRadius: new BorderRadius.only(
                              bottomRight: const Radius.circular(24.0),
                              topRight: const Radius.circular(24.0))),
                      /*User Profile*/
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                              backgroundImage: NetworkImage(profileimg),
                              radius: 40),
                          SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  text(name,
                                      textColor: Colors.white,
                                      fontFamily: 'Bold',
                                      fontSize: 20.0),
                                  SizedBox(height: 8),
                                  text("hiii",
                                      textColor: Colors.white,
                                      fontSize: 14.0),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                SizedBox(height: 30),
                getDrawerItem( Icons.dashboard,"Home", 1),
                getDrawerItem( Icons.fastfood_sharp,"Order\'s Recieved", 2),
                getDrawerItem(Icons.add, "Add Items", 3),
                getDrawerItem(Icons.history, "History", 4),
                getDrawerItem(Icons.notifications_active, "Notifications", 5),
                getDrawerItem(Icons.logout, "Logout", 6),
                SizedBox(height: 30),
                Divider(color: Color(0XFFDADADA), height: 1),
                SizedBox(height: 30),
                // getDrawerItem(t2_share, t2_lbl_share_and_invite, 6),
                // getDrawerItem(t2_help, t2_lbl_help_and_feedback, 7),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
