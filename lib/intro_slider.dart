import 'package:ehatid_driver_app/Screens/Welcome/components/background.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

import 'signup.dart';

class IntroSliderPage extends StatefulWidget {
  @override
  _IntroSliderPageState createState() => _IntroSliderPageState();
}

class _IntroSliderPageState extends State<IntroSliderPage> {
  List<Slide> slides = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    slides.add(
      new Slide(
        title: "More Passengers",
        description:
        "Work with convenience, and get more \n passengers along your way!",
        pathImage: "assets/images/illus1.png",
      ),
    );
    slides.add(
      new Slide(
        title: "Convenient",
        description: "Book movie tickets for your family and friends!",
        pathImage: "assets/images/illus2.png",
      ),
    );
    slides.add(
      new Slide(
        title: "Earn More",
        description: "Best discounts on every single service we offer!",
        pathImage: "assets/images/illus3.png",
      ),
    );
    slides.add(
      new Slide(
        title: "Accept a Job",
        description: "Book tickets of any transportation and travel the world!",
        pathImage: "assets/images/illus4.png",
      ),
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = [];
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Container(
            margin: EdgeInsets.only(bottom: 160, top: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Image.asset(
                    currentSlide.pathImage.toString(),
                    matchTextDirection: true,
                    height: 230,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Text(
                    currentSlide.title.toString(),
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 32, letterSpacing: -2, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3,
                  ),
                  child: Text(
                    currentSlide.description.toString(),
                    style: TextStyle(
                        fontFamily: 'Montserrat', fontSize: 15, color: Color(0xff646262), letterSpacing: -0.5, fontWeight: FontWeight.w500
                    ),
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  margin: EdgeInsets.only(
                    top: 15,
                    left: 20,
                    right: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      backgroundColorAllSlides: Colors.yellow,
      renderSkipBtn: Text("Skip"),
      renderNextBtn: Text(
        "Next",
        style: TextStyle(color: Colors.green[700]),
      ),
      renderDoneBtn: Text(
        "Done",
        style: TextStyle(color: Colors.green[700]),
      ),
      colorDoneBtn: Colors.white,
      colorActiveDot: Colors.white,
      sizeDot: 8.0,
      typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,
      listCustomTabs: this.renderListCustomTabs(),
      scrollPhysics: BouncingScrollPhysics(),
      onDonePress: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(),
        ),
      ),
    );
  }
}