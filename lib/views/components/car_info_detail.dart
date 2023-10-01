
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:taxi_chrono_web/models/user_account_model.dart';

import '../../constants/responsive.dart';
import '../../models/car_model.dart';
import '../../models/driver_model.dart';

class CarInfoDetail extends StatelessWidget {
  const CarInfoDetail({
    Key? key,
    this.joinedData
  }) : super(key: key);
  final List<Map<String, dynamic>>? joinedData;

  @override
  Widget build(BuildContext context) {
    Logger logger = Logger();
    return SingleChildScrollView(
      scrollDirection: Responsive.isWebDesktop(context) ? Axis.vertical : Axis.horizontal,
      child: SizedBox(
        width: Responsive.isWebDesktop(context) ? double.infinity : MediaQuery.of(context).size.width,
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: joinedData!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final map = joinedData![index];
                    Car car = Car.fromMap(map);
                    UserAccount user = UserAccount.fromMap(map);
                    logger.d(car.toMap());
                    logger.d(user.toMap());
                    return InkWell(
                      splashColor: Colors.grey,
                      onTap: (){
                        logger.i(car.toMap());
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          border:  Border(bottom: BorderSide(color: Colors.grey)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0),
                              child: const CircleAvatar(
                                radius: 17,
                                backgroundImage: AssetImage("assets/icons/taxi.png"),
                              ),
                            ),
                            Text(
                              user.userName?.toLowerCase() ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffa6a6a6),
                              ),
                            ),
                            Text(
                              car.imatriculation ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffa6a6a6),
                              ),
                            ),
                            Text(
                              car.numeroDeChassie ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffa6a6a6),
                              ),
                            ),
                            Text(
                              car.assurance ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffa6a6a6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}