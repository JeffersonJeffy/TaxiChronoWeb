import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taxi_chrono_web/models/reservation_model.dart';
import 'package:taxi_chrono_web/models/user_account_model.dart';

import '../../../constants/constants.dart';
import '../../localizations/localization.dart';


class ReservationInfoDetail extends StatelessWidget {
   const ReservationInfoDetail({Key? key, required this.reservation, required this.user}) : super(key: key);

  final Reservation reservation;
  final UserAccount user;

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(top: appPadding),
      padding: const EdgeInsets.all(appPadding / 2),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.asset(
              user.photo ?? "assets/images/user.png",
              height: 38,
              width: 38,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: appPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user.userName}${localization.trans("made_reservation_from")!}'${reservation.pointDepart?.nom}'${localization.trans("at")!}'${reservation.pointArrive?.nom}'${localization.trans("at_the_price_of")!}${reservation.prixReservation}",
                    style: const TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600
                    ),
                  ),

                  Text(
                    "${localization.trans("date")!}: ${timestampToDateLong(reservation.dateReservation!)}",
                    style: TextStyle(
                        color: textColor.withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Icon(Icons.more_vert_rounded,color: textColor.withOpacity(0.5),size: 18,)
        ],
      ),
    );
  }

   String timestampToDateLong(Timestamp timestamp) {
     DateTime dateTime = timestamp.toDate();
     DateFormat dateFormat = DateFormat.yMMMMd('fr_FR');
     String dateLong = dateFormat.format(dateTime);
     return dateLong;
   }
}
