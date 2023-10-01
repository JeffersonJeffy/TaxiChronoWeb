import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:taxi_chrono_web/models/salesperson_model.dart';
import 'package:taxi_chrono_web/views/components/salesperson_info_detail.dart';

import '../../../constants/constants.dart';
import '../../../localizations/localization.dart';
import '../../controller/dashboard_controller.dart';
import '../../controller/simple_ui_controller.dart';
import '../../models/car_model.dart';
import '../../models/driver_model.dart';
import '../../models/user_account_model.dart';


class CarForm extends StatefulWidget {
  const CarForm({Key? key, this.admin}) : super(key: key);
  final Administrator? admin;

  @override
  State<CarForm> createState() => _DriverFormState();
}

class _DriverFormState extends State<CarForm> {
  final _db = FirebaseFirestore.instance;
  AppLocalizations? localization;
  Logger? logger;
  final _formKey = GlobalKey<FormState>();
  Car car = Car();
  bool? _state = false;
  bool isLoading = false;
  var size;
  var theme;
  SimpleUIController? simpleUIController;
  List<Driver> driverList = [];
  Driver? selectedDriver;

  TextEditingController activeEndDateController = TextEditingController();
  TextEditingController assuranceController = TextEditingController();
  TextEditingController expirationAssuranceController = TextEditingController();
  TextEditingController imatriculationController = TextEditingController();
  TextEditingController numeroDeChassieController = TextEditingController();


  @override
  void initState() {
    super.initState();
    logger = Logger();
    fetchDriverData();
  }

  @override
  void dispose() {
    activeEndDateController.dispose();
    assuranceController.dispose();
    expirationAssuranceController.dispose();
    imatriculationController.dispose();
    numeroDeChassieController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;
    size = MediaQuery.of(context).size;
    theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localization!.trans('form_save')!,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: textColor,
              ),
            ),
            const SizedBox(
              height: appPadding,
            ),
            /// active end date
            TextFormField(
              style: kTextFormFieldStyle(),
              onSaved: (val) => car.activeEndDate = val,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.date_range_outlined),
                hintText: 'Date Fin d\'activité (Format: jj-mm-aaaa)',
                label: Text('Date Fin d\'activité (Format: jj-mm-aaaa)', style: TextStyle(color: Colors.grey),),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                    color: Colors.yellow,
                  ),
                ),
              ),

              controller: activeEndDateController,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localization?.trans('please_enter_field');
                } else if (value.length < 4) {
                  return localization?.trans('at_leaster_enter');
                } else if (value.length > 50) {
                  return localization?.trans('maximum_character');
                }
                return null;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),

            /// assurance
            TextFormField(
              style: kTextFormFieldStyle(),
              onSaved: (val) => car.assurance = val,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.security),
                hintText: 'Assurance',
                label: Text('Assurance', style: TextStyle(color: Colors.grey),),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                    color: Colors.yellow,
                  ),
                ),
              ),

              controller: assuranceController,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localization?.trans('please_enter_field');
                } else if (value.length < 4) {
                  return localization?.trans('at_leaster_enter');
                } else if (value.length > 50) {
                  return localization?.trans('maximum_character');
                }
                return null;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),

            /// expiration Assurance
            TextFormField(
              style: kTextFormFieldStyle(),
              onSaved: (val) => car.expirationAssurance = val,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.numbers),
                hintText: 'Date d\'expiration assurance Ex: jj-mm-yyyy',
                label: Text('Date d\'expiration assurance Ex: jj-mm-yyyy', style: TextStyle(color: Colors.grey),),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                    color: Colors.yellow,
                  ),
                ),
              ),

              controller: expirationAssuranceController,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localization?.trans('please_enter_field');
                } else if (value.length < 4) {
                  return localization?.trans('at_leaster_enter');
                } else if (value.length > 50) {
                  return localization?.trans('maximum_character');
                }
                return null;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),

            /// immatriculation
            TextFormField(
              style: kTextFormFieldStyle(),
              onSaved: (val) => car.imatriculation = val,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.abc_outlined),
                hintText: 'Numéro d\' immatriculation',
                label: Text('Numéro d\' immatriculation', style: TextStyle(color: Colors.grey),),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                    color: Colors.yellow,
                  ),
                ),
              ),

              controller: imatriculationController,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localization?.trans('please_enter_field');
                } else if (value.length < 4) {
                  return localization?.trans('at_leaster_enter');
                } else if (value.length > 50) {
                  return localization?.trans('maximum_character');
                }
                return null;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),

            /// Actif ou Inactif
            DropdownButtonFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.abc_outlined),
                hintText: 'Actif ou Inactif ',
                label: Text('Actif ou Inactif', style: TextStyle(color: Colors.grey),),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                    color: Colors.yellow,
                  ),
                ),
              ),
              value: _state,
              items: const [
                DropdownMenuItem(
                  value: true,
                  child: Text('Oui'),
                ),
                DropdownMenuItem(
                  value: false,
                  child: Text('Non'),
                ),
              ],
              onChanged: (bool? value) {
                setState(() {
                  _state = value;
                });
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),

            /// numeroDeChassie
            TextFormField(
              style: kTextFormFieldStyle(),
              onSaved: (val) => car.numeroDeChassie = val,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.car_crash),
                hintText: 'N° Châssis',
                label: Text('N° Châssis', style: TextStyle(color: Colors.grey),),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                    color: Colors.yellow,
                  ),
                ),
              ),

              controller: numeroDeChassieController,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localization?.trans('please_enter_field');
                } else if (value.length < 4) {
                  return localization?.trans('at_leaster_enter');
                } else if (value.length > 50) {
                  return localization?.trans('maximum_character');
                }
                return null;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),

            ///Liste des chauffeurs
            DropdownButtonFormField<Driver>(
              value: selectedDriver,
              onChanged: (Driver? newValue) {
                setState(() {
                  selectedDriver = newValue;
                });
              },
              items: driverList.map((Driver driver) {
                return DropdownMenuItem<Driver>(
                  value: driver,
                  child: Text(driver.userName ?? ""),
                );
              }).toList(),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.abc_outlined),
                hintText: 'Sélectionner le Chauffeur ',
                label: Text('Sélectionner le chauffeur', style: TextStyle(color: Colors.grey),),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                    color: Colors.yellow,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),

            /// SignUp Button
            signUpButton(theme),
            SizedBox(
              height: size.height * 0.03,
            ),
          ],
        ),
      ),
    );
  }

  Widget signUpButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.green),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () async {
          // Validate returns true if the form is valid, or false otherwise.
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            setState(() {
              isLoading = true;
            });
            car.isActive = _state;
            car.chauffeurId = selectedDriver?.id;
            car.statut = true;
            car.createdBy = widget.admin?.id;
            car.createdAt = Timestamp.now();
            await createCar(car);
          }
        },
        child: isLoading?  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(localization!.trans("loading")!, style: const TextStyle(fontSize: 20),),
            const SizedBox(width: 10,),
            const CircularProgressIndicator(color: Colors.white,),
          ],
        ) : Text(localization!.trans('validate')!, style: const TextStyle(fontSize: 20)),
      ),
    );
  }

  showAlertDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(localization!.trans("error_message")!),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  createCar(Car car) async {
    logger?.d(car.toMap());

    DocumentReference docRef = await _db.collection("cars").add(car.toMap());
    String carId = docRef.id; // Récupérer l'ID généré du document

    await _db.collection("cars").doc(carId).update({"car_id": carId}).then((docRef) async {
      setState(() {
        isLoading = false;
      });
      logger?.i("Votre voiture a ete crée avec succès.");
      //showAlertDialog(context, "Votre compte a ete crée avec succès.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Votre voiture a ete crée avec succès."),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        activeEndDateController.clear();
        assuranceController.clear();
        expirationAssuranceController.clear();
        imatriculationController.clear();
        numeroDeChassieController.clear();
      });

    }).catchError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
      showAlertDialog(context, error);
    });
  }


  Future<void> fetchDriverData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Utilisateur").get();
      List<Driver> drivers = [];
      querySnapshot.docs.forEach((doc) {
        Driver driver = Driver.fromMapDropdownList(doc.data() as Map<String, dynamic>);
        driver.id = doc.id;
        drivers.add(driver);
      });
      setState(() {
        driverList = drivers;
      });
    } catch (e) {
      print("Erreur lors du chargement des données utilisateur : $e");
    }
  }

}




/*class DriverList extends StatelessWidget {
  const DriverList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    Logger logger = Logger();
    return Container(
      height: 540,
      padding: const EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localization.trans("driver_list")!,
                style: const TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              Text(
                localization.trans('view_all')!,
                style: TextStyle(
                  color: textColor.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: appPadding,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Commerciaux').snapshots(),
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return Text("Error: ${snapshot.hasError}");
                }
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final salesPersons = snapshot.data!.docs;
                return ListView.builder(
                  //physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: salesPersons.length,
                  itemBuilder: (context, index) {
                    final salesPerson = salesPersons[index].data() as Map<String, dynamic>;
                    SalesPerson items = SalesPerson.fromMap(salesPerson);
                    logger.d(items.toMap());
                    return SalesPersonInfoDetail(itemSalesPerson: items,);
                  }
                );
              },
            )
          )
        ],
      ),
    );
  }
}*/
