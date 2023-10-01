
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../constants/responsive.dart';
import '../../models/driver_model.dart';

class DriverInfoDetail extends StatelessWidget {
  const DriverInfoDetail({
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
                    Driver driver = Driver.fromMap(map);
                    logger.d(driver.toMap());
                    return InkWell(
                      splashColor: Colors.grey,
                      onTap: (){
                        logger.i(driver.toMap());
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
                                backgroundImage: AssetImage("assets/icons/driver.png"),
                              ),
                            ),
                            Text(
                              driver.userName?.toLowerCase() ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffa6a6a6),
                              ),
                            ),
                            Text(
                              driver.userTelephone!=null ? driver.userTelephone! : "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffa6a6a6),
                              ),
                            ),
                            Text(
                              driver.numeroPermi ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffa6a6a6),
                              ),
                            ),
                            Text(
                              driver.expirePermiDate!=null ? timestampToDateLong(driver.expirePermiDate!) : "",
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

  String timestampToDateLong(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateFormat dateFormat = DateFormat.yMMMMd('fr_FR');
    String dateLong = dateFormat.format(dateTime);
    return dateLong;
  }
}