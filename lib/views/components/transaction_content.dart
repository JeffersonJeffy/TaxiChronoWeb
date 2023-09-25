import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../../constants/constants.dart';
import '../../localizations/localization.dart';
import '../../models/user_account_model.dart';

import 'dart:math';
import 'package:responsive_table/responsive_table.dart';

import 'custom_appbar.dart';


class TransactionContent extends StatefulWidget {
  final Administrator? admin;
  const TransactionContent({Key? key, this.admin}) : super(key: key);

  @override
  State<TransactionContent> createState() => _TransactionContentState();
}

class _TransactionContentState extends State<TransactionContent> {
  late List<DatatableHeader> _headers;

  final List<int> _perPages = [10, 20, 50, 100];
  int _total = 100;
  int? _currentPerPage = 10;
  List<bool>? _expanded;
  String? _searchKey = "id";

  int _currentPage = 1;
  final bool _isSearch = false;
  List<Map<String, dynamic>> _sourceOriginal = [];
  List<Map<String, dynamic>> _sourceFiltered = [];
  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _selecteds = [];
  // ignore: unused_field
  final String _selectableKey = "id";

  String? _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  final bool _showSelect = true;
  var random = Random();
  num globalBalance = 0;

  /*List<Map<String, dynamic>> _generateData({int n = 100}) {
    final List source = List.filled(n, Random.secure());
    List<Map<String, dynamic>> temps = [];
    var i = 1;
    print(i);
    // ignore: unused_local_variable
    for (var data in source) {
      temps.add({
        "id": i,
        "sku": "$i\000$i",
        "name": "Product $i",
        "category": "Category-$i",
        "price": i * 10.00,
        "cost": "20.00",
        "margin": "${i}0.20",
        "in_stock": "${i}0",
        "alert": "5",
        "received": [i + 20, 150]
      });
      i++;
    }
    return temps;
  }*/

  Logger logger = Logger();

  _initializeData() async {
    //_mockPullData();
    await joinCollectionsBetweenTransactionsReservationsUsersDriver();
  }

  _mockPullData({List<Map<String, dynamic>>? data}) async {
    _expanded = List.generate(_currentPerPage!, (index) => false);

    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 3)).then((value) {
      _sourceOriginal.clear();
      //_sourceOriginal.addAll(_generateData(n: random.nextInt(10000)));
      _sourceOriginal.addAll(data!);
      _sourceFiltered = _sourceOriginal;
      _total = _sourceFiltered.length;
      _source = _sourceFiltered.getRange(0, _currentPerPage!).toList();
      setState(() => _isLoading = false);
    });
  }

  _resetData({start = 0}) async {
    setState(() => _isLoading = true);
    var _expandedLen =
    _total - start < _currentPerPage! ? _total - start : _currentPerPage;
    Future.delayed(Duration(seconds: 0)).then((value) {
      _expanded = List.generate(_expandedLen as int, (index) => false);
      _source.clear();
      _source = _sourceFiltered.getRange(start, start + _expandedLen).toList();
      setState(() => _isLoading = false);
    });
  }

  _filterData(value) {
    setState(() => _isLoading = true);

    try {
      if (value == "" || value == null) {
        _sourceFiltered = _sourceOriginal;
      } else {
        _sourceFiltered = _sourceOriginal
            .where((data) => data[_searchKey!]
            .toString()
            .toLowerCase()
            .contains(value.toString().toLowerCase()))
            .toList();
      }

      _total = _sourceFiltered.length;
      var _rangeTop = _total < _currentPerPage! ? _total : _currentPerPage!;
      _expanded = List.generate(_rangeTop, (index) => false);
      _source = _sourceFiltered.getRange(0, _rangeTop).toList();
    } catch (e) {
      print(e);
    }
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    /// set headers
    _headers = [
      DatatableHeader(
          text: "ID",
          value: "id",
          show: true,
          sortable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Client",
          value: "customer",
          show: true,
          flex: 2,
          sortable: true,
          editable: true,
          textAlign: TextAlign.left),
      /*DatatableHeader(
          text: "Chauffeur",
          value: "driver",
          show: true,
          sortable: true,
          textAlign: TextAlign.center),*/
      DatatableHeader(
          text: "Type",
          value: "type",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Date",
          value: "date_operation",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Statut",
          value: "statut",
          show: true,
          sortable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Montant (FCFA)",
          value: "amount",
          show: true,
          sortable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Départ",
          value: "start",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Arrive",
          value: "end",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Durée",
          value: "duration",
          show: true,
          sortable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Action",
          value: "action",
          show: true,
          sortable: true,
          textAlign: TextAlign.center),
      /*DatatableHeader(
          text: "Received",
          value: "received",
          show: true,
          sortable: false,
          sourceBuilder: (value, row) {
            print("----------------$value--------sourceBuilder");
            logger.d(value);
            List list = List.from(value);
            return Container(
              child: Column(
                children: [
                  Container(
                    width: 85,
                    child: LinearProgressIndicator(
                      value: list.first / list.last,
                    ),
                  ),
                  Text("${list.first} of ${list.last}")
                ],
              ),
            );
          },
          textAlign: TextAlign.center),*/
    ];

    _initializeData();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return SafeArea(
      /*appBar: AppBar(
        title: Text("RESPONSIVE DATA TABLE"),
        actions: [
          IconButton(
            onPressed: _initializeData,
            icon: Icon(Icons.refresh_sharp),
          ),
        ],
      ),*/
      child: SingleChildScrollView(
          padding: const EdgeInsets.all(appPadding),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomAppbar(admin: widget.admin),
                const SizedBox(
                  height: appPadding,
                ),
                Container(
                  width: 200,
                  padding: const EdgeInsets.symmetric(
                    vertical: appPadding / 2,
                  ),
                  decoration: BoxDecoration(
                      color: secondaryColor, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("$globalBalance FCFA",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),),
                          Container(
                            padding: const EdgeInsets.all(appPadding / 2),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle),
                            child: const Icon(
                              Icons.money,
                              color: Colors.green,
                            ),
                          )
                        ],
                      ),
                      const Text(
                        "Solde",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: appPadding,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(0),
                  constraints: const BoxConstraints(
                    maxHeight: 700,
                  ),
                  child: Card(
                    elevation: 1,
                    shadowColor: Colors.black,
                    clipBehavior: Clip.none,
                    child: ResponsiveDatatable(
                      /*title: TextButton.icon(
                        onPressed: () => {},
                        icon: Icon(Icons.add),
                        label: Text("new item"),
                      ),*/
                      reponseScreenSizes: const [ScreenSize.xs],
                     /* actions: [
                        if (_isSearch)
                          Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                    hintText: 'Enter search term based on ' +
                                        _searchKey!
                                            .replaceAll(new RegExp('[\\W_]+'), ' ')
                                            .toUpperCase(),
                                    prefixIcon: IconButton(
                                        icon: Icon(Icons.cancel),
                                        onPressed: () {
                                          setState(() {
                                            _isSearch = false;
                                          });
                                          _initializeData();
                                        }),
                                    suffixIcon: IconButton(
                                        icon: Icon(Icons.search), onPressed: () {})),
                                onSubmitted: (value) {
                                  _filterData(value);
                                },
                              )),
                        if (!_isSearch)
                          IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                setState(() {
                                  _isSearch = true;
                                });
                              })
                      ],*/
                      headers: _headers,
                      source: _source,
                      selecteds: _selecteds,
                      showSelect: _showSelect,
                      autoHeight: false,
                      dropContainer: (data) {
                        if (int.tryParse(data['id'].toString())!.isEven) {
                          return Text("is Even");
                        }
                        return _DropDownContainer(data: data);
                      },
                      onChangedRow: (value, header) {
                        /// print(value);
                        /// print(header);
                      },
                      onSubmittedRow: (value, header) {
                        /// print(value);
                        /// print(header);
                      },
                      onTabRow: (data) {
                        print(data);
                      },
                      onSort: (value) {
                        setState(() => _isLoading = true);

                        setState(() {
                          _sortColumn = value;
                          _sortAscending = !_sortAscending;
                          if (_sortAscending) {
                            _sourceFiltered.sort((a, b) =>
                                b["$_sortColumn"].compareTo(a["$_sortColumn"]));
                          } else {
                            _sourceFiltered.sort((a, b) =>
                                a["$_sortColumn"].compareTo(b["$_sortColumn"]));
                          }
                          var _rangeTop = _currentPerPage! < _sourceFiltered.length
                              ? _currentPerPage!
                              : _sourceFiltered.length;
                          _source = _sourceFiltered.getRange(0, _rangeTop).toList();
                          _searchKey = value;

                          _isLoading = false;
                        });
                      },
                      expanded: _expanded,
                      sortAscending: _sortAscending,
                      sortColumn: _sortColumn,
                      isLoading: _isLoading,
                      onSelect: (value, item) {
                        print("$value  $item ");
                        if (value!) {
                          setState(() => _selecteds.add(item));
                        } else {
                          setState(
                                  () => _selecteds.removeAt(_selecteds.indexOf(item)));
                        }
                      },
                      onSelectAll: (value) {
                        if (value!) {
                          setState(() => _selecteds =
                              _source.map((entry) => entry).toList().cast());
                        } else {
                          setState(() => _selecteds.clear());
                        }
                      },
                      footers: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: const Text("Lignes par page:"),
                        ),
                        if (_perPages.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: DropdownButton<int>(
                              value: _currentPerPage,
                              items: _perPages
                                  .map((e) => DropdownMenuItem<int>(
                                value: e,
                                child: Text("$e"),
                              ))
                                  .toList(),
                              onChanged: (dynamic value) {
                                setState(() {
                                  _currentPerPage = value;
                                  _currentPage = 1;
                                  _resetData();
                                });
                              },
                              isExpanded: false,
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child:
                          Text("$_currentPage - $_currentPerPage Par $_total"),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 16,
                          ),
                          onPressed: _currentPage == 1
                              ? null
                              : () {
                            var _nextSet = _currentPage - _currentPerPage!;
                            setState(() {
                              _currentPage = _nextSet > 1 ? _nextSet : 1;
                              _resetData(start: _currentPage - 1);
                            });
                          },
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, size: 16),
                          onPressed: _currentPage + _currentPerPage! - 1 > _total
                              ? null
                              : () {
                            var _nextSet = _currentPage + _currentPerPage!;

                            setState(() {
                              _currentPage = _nextSet < _total
                                  ? _nextSet
                                  : _total - _currentPerPage!;
                              _resetData(start: _nextSet - 1);
                            });
                          },
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                        )
                      ],
                      headerDecoration: const BoxDecoration(
                          color: Colors.grey,
                          border: Border(
                              bottom: BorderSide(color: Colors.red, width: 1))),
                      selectedDecoration: BoxDecoration(
                        border: Border(
                            bottom:
                            BorderSide(color: Colors.green[300]!, width: 1)),
                        color: Colors.green,
                      ),
                      headerTextStyle: const TextStyle(color: Colors.white),
                      rowTextStyle: const TextStyle(color: Colors.black),
                      selectedTextStyle: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ])),
    );
  }

  Future joinCollectionsBetweenTransactionsReservationsUsersDriver() async {

    // Récupérez les données de la collection Firestore contenant les transactions
    final transactionsCollectionSnapshot = await FirebaseFirestore.instance.collection('TransactionApp').orderBy('dateAcceptation', descending: true).get();
    final reservationsCollectionSnapshot = await FirebaseFirestore.instance.collection('Reservation').get();
    final threeUsersCollectionSnapshot = await FirebaseFirestore.instance.collection('Utilisateur').get();
    final fourDriversCollectionSnapshot = await FirebaseFirestore.instance.collection('Chauffeur').get();

    // Combinez les données des deux collections
    List<DocumentSnapshot> firstTransactionsCollectionDocs = transactionsCollectionSnapshot.docs;
    List<DocumentSnapshot> secondReservationsCollectionDocs = reservationsCollectionSnapshot.docs;
    List<DocumentSnapshot> threeUsersCollectionDocs = threeUsersCollectionSnapshot.docs;
    List<DocumentSnapshot> fourDriversCollectionDocs = fourDriversCollectionSnapshot.docs;

    List<Map<String, dynamic>> joinedData = [];
    var i = 1;
    for(var firstTransactionDoc in firstTransactionsCollectionDocs){
      for(var secondReservationsDoc in secondReservationsCollectionDocs){
        for(var threeUserDoc in threeUsersCollectionDocs){
          for(var fourDriverDoc in fourDriversCollectionDocs){
            if(firstTransactionDoc["idReservation"]==secondReservationsDoc.id &&
                threeUserDoc.id == firstTransactionDoc['idClient'] &&
                fourDriverDoc["userid"] == firstTransactionDoc['idChauffeur']){
              setState(() {
                globalBalance += secondReservationsDoc['prixReservation'];
              });
              Map<String, dynamic> joinedItem = {
                "id": i,
                'customer': threeUserDoc['userid']==secondReservationsDoc['idClient'] ? threeUserDoc['userName'] : null,
                //'driver': threeUserDoc['userid']==firstTransactionDoc['idChauffeur'] ? threeUserDoc['userName'] : null,
                'type': secondReservationsDoc['typeRservation'],
                'date_operation': timestampToDateLong(secondReservationsDoc['dateReservation']),
                'statut': firstTransactionDoc['etatTransaction'],
                'amount': secondReservationsDoc['prixReservation'],
                'start': secondReservationsDoc['pointDepart']['nom'] + " le " + timestampToDateLong(firstTransactionDoc['tempsDepart']),
                'end': secondReservationsDoc['pointArrive']['nom'] + " le " + timestampToDateLong(firstTransactionDoc['tempsArrive']),
                "duration": calculateDuration(firstTransactionDoc['tempsDepart'], firstTransactionDoc['tempsArrive']),
                "action": "detail"
              };
              joinedData.add(joinedItem);
              i++;
              break;
            }
          }
        }
      }
    }


    if(joinedData.length < 10){
      joinedData.add({});
      joinedData.add({});
      joinedData.add({});
      joinedData.add({});
      joinedData.add({});
      joinedData.add({});
    }

    logger.d(joinedData.length);

    //Logger().d(joinedData);
    _mockPullData(data: joinedData);
    //return joinedData;
  }

  String timestampToDateLong(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateFormat dateFormat = DateFormat.yMMMMd('fr_FR').add_Hm();
    String dateLong = dateFormat.format(dateTime);
    return dateLong;
  }

  String calculateDuration(Timestamp timestampStart, Timestamp timestampEnd) {

    int timestamp1 = timestampStart.millisecondsSinceEpoch;
    int timestamp2 = timestampEnd.millisecondsSinceEpoch;

    DateTime dateTime1 = DateTime.fromMillisecondsSinceEpoch(timestamp1 * 1000);
    DateTime dateTime2 = DateTime.fromMillisecondsSinceEpoch(timestamp2 * 1000);

    Duration difference = dateTime2.difference(dateTime1);

    print('La durée entre les deux timestamps est : ${difference.toString()}');



    return difference.toString();
  }

}


class _DropDownContainer extends StatelessWidget {
  final Map<String, dynamic> data;
  const _DropDownContainer({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = data.entries.map<Widget>((entry) {
      Widget w = Row(
        children: [
          Text(entry.key.toString()),
          Spacer(),
          Text(entry.value.toString()),
        ],
      );
      return w;
    }).toList();

    return Container(
      /// height: 100,
      child: Column(
        /// children: [
        ///   Expanded(
        ///       child: Container(
        ///     color: Colors.red,
        ///     height: 50,
        ///   )),
        /// ],
        children: _children,
      ),
    );
  }
}


