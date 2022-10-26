import 'package:ehatid_driver_app/global.dart';
import 'package:ehatid_driver_app/navigation_bar.dart';
import 'package:ehatid_driver_app/user_ride_request_information.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FareAmountCollectionDialog extends StatefulWidget
{
  double? totalFareAmount;
  UserRideRequestInformation? userRideRequestDetails;

  FareAmountCollectionDialog({this.totalFareAmount, this.userRideRequestDetails});

  @override
  State<FareAmountCollectionDialog> createState() => _FareAmountCollectionDialogState();
}

class _FareAmountCollectionDialogState extends State<FareAmountCollectionDialog>
{
  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      backgroundColor: Colors.grey,
      child: Container(
        margin: const EdgeInsets.all(6),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 4.h),

            Text(
              "Trip Fare Amount",
              style: const TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18,
              ),
            ),

            SizedBox(height: 2.h),

            Divider(
              thickness: 0.5.w,
              color: Colors.black,
              indent: 4.w,
              endIndent: 4.w,
            ),

            SizedBox(height: 3.h),

            Text(
              "₱" + widget.totalFareAmount.toString(),
              style: const TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
                color: Color(0xFF0CBC8B),
                fontSize: 50,
              ),
            ),

            SizedBox(height: 1.h),

            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "This is the total trip amount.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),

            SizedBox(height: 2.h),

            //confirm button
            SizedBox(
              width: 50.w,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0CBC8B),
                  ),
                  onPressed: ()
                  {
                    Future.delayed(const Duration(seconds: 2), ()
                    {
                      FirebaseDatabase.instance.ref()
                          .child("drivers")
                          .child(currentFirebaseUser!.uid)
                          .child("newRideStatus")
                          .set("idle");

                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (_) => Navigation(),
                      ),
                      );
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Confirm",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(width: 1.w),

                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
