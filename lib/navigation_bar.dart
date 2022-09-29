import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ehatid_driver_app/Account/account.dart';
import 'package:ehatid_driver_app/accept_decline.dart';
import 'package:ehatid_driver_app/history.dart';
import 'package:ehatid_driver_app/homepage.dart';
import 'package:ehatid_driver_app/wallet.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {

  GlobalKey<CurvedNavigationBarState> _navKey = GlobalKey();

  TextEditingController latController = TextEditingController();
  TextEditingController lngController = TextEditingController();

  var myindex = 0;

  var PagesAll = [AcceptDecline(), Wallet(), History(), HomePage(),ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    //total height and width
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFCEA),
        bottomNavigationBar: CurvedNavigationBar(
          key: _navKey,
          items: [
            Icon((myindex == 0) ? Icons.home_outlined : Icons.home, size: 30,),
            Icon((myindex == 1) ? Icons.account_balance_wallet_outlined : Icons.account_balance_wallet, size: 30,),
            Icon((myindex == 2) ? Icons.history_outlined : Icons.history, size: 30,),
            Icon((myindex == 3) ? Icons.question_answer_outlined : Icons.question_answer , size: 30,),
            Icon((myindex == 4) ? Icons.account_circle_outlined : Icons.account_circle_sharp , size: 30,),
          ],
          height: 60,
          backgroundColor: Color(0xFFEBE5D8),
          color: Color(0xFFFED90F),
          animationDuration: Duration(milliseconds: 300),
          onTap: (index){
            setState(() {
              myindex = index;
            });
          },
        ),
        body: PagesAll[myindex],
      ),
    );
  }
}